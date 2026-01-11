#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/types';
import {
  DBMigration,
  DBMigrationData,
  getAllDBMigrations,
  doDBOpen,
  doDBClose,
  doDBQuery
} from '../src/db-utils';

const { VKD_ENVIRONMENT, LOG_LEVEL } = process.env;

// Set up logging
const serviceName = `migration-runner-${VKD_ENVIRONMENT}`;
const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});

// Files that should run every time (idempotent operations)
const RUN_EVERY_TIME_FILES = [
  '20250924-act76.sql',
  'act76-child-data-2025-09.sql',
  'act76-family-data-2025-09.sql'
];

interface MigrationFile {
  filename: string;
  fullPath: string;
  content: string;
}

/**
 * Read all SQL files from the scripts directory
 */
async function readSQLFiles(): Promise<MigrationFile[]> {
  const scriptsDir = path.join(__dirname);
  const files = fs.readdirSync(scriptsDir);
  
  const sqlFiles = files
    .filter(file => file.endsWith('.sql'))
    .sort(); // Alphanumeric sort ensures YYYYMMDD files are in chronological order
  
  logger.info({ message: `Found ${sqlFiles.length} SQL files`, files: sqlFiles });
  
  const migrationFiles: MigrationFile[] = [];
  
  for (const filename of sqlFiles) {
    const fullPath = path.join(scriptsDir, filename);
    try {
      const content = fs.readFileSync(fullPath, 'utf8');
      migrationFiles.push({
        filename,
        fullPath,
        content
      });
    } catch (error) {
      logger.error({ message: `Failed to read file ${filename}`, error });
      throw new Error(`Failed to read migration file: ${filename}`);
    }
  }
  
  return migrationFiles;
}

/**
 * Get existing migration records from DynamoDB
 */
async function getExistingMigrations(): Promise<Map<string, DBMigrationData>> {
  try {
    const migrations = await getAllDBMigrations();
    const migrationMap = new Map<string, DBMigrationData>();
    
    for (const migration of migrations) {
      migrationMap.set(migration.filename, migration);
    }
    
    logger.info({ message: `Found ${migrations.length} existing migration records` });
    return migrationMap;
  } catch (error) {
    logger.error({ message: 'Failed to get existing migrations', error });
    throw new Error('Failed to retrieve existing migration records');
  }
}

/**
 * Execute a SQL file against the MySQL database
 */
async function executeSQLFile(migrationFile: MigrationFile, dryRun: boolean = false): Promise<void> {
  const action = dryRun ? 'DRY RUN - Would execute migration' : 'Executing migration';
  logger.info({ message: `${action}: ${migrationFile.filename}` });
  
  try {
    // Split the SQL content by semicolons to handle multiple statements
    const statements = migrationFile.content
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0 && !stmt.startsWith('--'));
    
    logger.info({ message: `Found ${statements.length} SQL statements in ${migrationFile.filename}` });
    
    if (dryRun) {
      // In dry-run mode, just log what would be executed
      for (let i = 0; i < statements.length; i++) {
        const statement = statements[i];
        if (statement) {
          logger.info({
            message: `DRY RUN - Would execute statement ${i + 1}/${statements.length}`,
            statement: statement.substring(0, 200) + (statement.length > 200 ? '...' : '')
          });
        }
      }
      logger.info({ message: `DRY RUN - Would complete migration: ${migrationFile.filename}` });
    } else {
      // Normal execution mode
      for (let i = 0; i < statements.length; i++) {
        const statement = statements[i];
        if (statement) {
          logger.debug({ message: `Executing statement ${i + 1}/${statements.length}`, statement: statement.substring(0, 100) + '...' });
          await doDBQuery(statement);
        }
      }
      logger.info({ message: `Successfully executed migration: ${migrationFile.filename}` });
    }
  } catch (error) {
    logger.error({ message: `Failed to execute migration: ${migrationFile.filename}`, error });
    throw new Error(`Migration execution failed for ${migrationFile.filename}: ${error}`);
  }
}

/**
 * Record a successful migration in DynamoDB
 */
async function recordMigration(filename: string, runEveryTime: boolean, dryRun: boolean = false): Promise<void> {
  if (dryRun) {
    logger.info({ message: `DRY RUN - Would record migration: ${filename}`, runEveryTime });
    return;
  }

  try {
    const migrationData: DBMigrationData = {
      filename,
      executedAt: new Date().toISOString(),
      runEveryTime
    };
    
    await DBMigration.put(migrationData);
    logger.info({ message: `Recorded migration: ${filename}`, runEveryTime });
  } catch (error) {
    logger.error({ message: `Failed to record migration: ${filename}`, error });
    // Don't throw here - we want to continue with other migrations even if recording fails
    logger.warn({ message: `Continuing with next migration despite recording failure` });
  }
}

/**
 * Determine if a migration should be executed
 */
function shouldExecuteMigration(
  filename: string,
  existingMigration: DBMigrationData | undefined
): boolean {
  // Always execute if no existing record
  if (!existingMigration) {
    logger.info({ message: `Migration ${filename} has no existing record - will execute` });
    return true;
  }
  
  // Execute if marked as "run every time"
  if (existingMigration.runEveryTime) {
    logger.info({ message: `Migration ${filename} is marked as runEveryTime - will execute` });
    return true;
  }
  
  // Skip if already executed and not marked as "run every time"
  logger.info({ message: `Migration ${filename} already executed on ${existingMigration.executedAt} - will skip` });
  return false;
}

/**
 * Main migration runner function
 */
async function runMigrations(dryRun: boolean = false): Promise<void> {
  const mode = dryRun ? 'DRY RUN' : 'EXECUTION';
  logger.info({ message: `Starting database migration process in ${mode} mode` });
  
  let dbConnectionOpened = false;
  
  try {
    // Read all SQL files
    const migrationFiles = await readSQLFiles();
    
    if (migrationFiles.length === 0) {
      logger.info({ message: 'No SQL files found - migration complete' });
      return;
    }
    
    // Get existing migration records
    const existingMigrations = await getExistingMigrations();
    
    // Open database connection (only if not in dry-run mode)
    if (!dryRun) {
      await doDBOpen();
      dbConnectionOpened = true;
      logger.info({ message: 'Database connection opened' });
    } else {
      logger.info({ message: 'DRY RUN - Skipping database connection' });
    }
    
    let executedCount = 0;
    let skippedCount = 0;
    
    // Process each migration file
    for (const migrationFile of migrationFiles) {
      const existingMigration = existingMigrations.get(migrationFile.filename);
      const runEveryTime = RUN_EVERY_TIME_FILES.includes(migrationFile.filename);
      
      if (shouldExecuteMigration(migrationFile.filename, existingMigration)) {
        try {
          await executeSQLFile(migrationFile, dryRun);
          await recordMigration(migrationFile.filename, runEveryTime, dryRun);
          executedCount++;
        } catch (error) {
          logger.error({ message: `Migration failed: ${migrationFile.filename}`, error });
          if (!dryRun) {
            throw error; // Stop processing on first failure in execution mode
          }
          // In dry-run mode, continue processing other files
          logger.warn({ message: 'DRY RUN - Continuing with next migration despite error' });
        }
      } else {
        skippedCount++;
      }
    }
    
    logger.info({
      message: `Migration process completed successfully in ${mode} mode`,
      totalFiles: migrationFiles.length,
      executed: executedCount,
      skipped: skippedCount
    });
    
  } catch (error) {
    logger.error({ message: 'Migration process failed', error });
    throw error;
  } finally {
    if (dbConnectionOpened) {
      try {
        await doDBClose();
        logger.info({ message: 'Database connection closed' });
      } catch (error) {
        logger.error({ message: 'Failed to close database connection', error });
      }
    }
  }
}

/**
 * Parse command line arguments
 */
function parseArguments() {
  return yargs(hideBin(process.argv))
    .option('dry-run', {
      alias: 'd',
      type: 'boolean',
      default: false,
      description: 'Show what migrations would be executed without actually running them'
    })
    .help()
    .alias('help', 'h')
    .parseSync();
}

/**
 * CLI entry point
 */
async function main(): Promise<void> {
  try {
    // Parse command line arguments
    const argv = parseArguments();
    
    // Validate environment
    if (!VKD_ENVIRONMENT) {
      throw new Error('VKD_ENVIRONMENT environment variable is required');
    }
    
    const mode = argv['dry-run'] ? 'DRY RUN' : 'EXECUTION';
    logger.info({
      message: `Running migrations for environment: ${VKD_ENVIRONMENT} in ${mode} mode`,
      dryRun: argv['dry-run']
    });
    
    await runMigrations(argv['dry-run']);
    
    logger.info({ message: 'Migration runner completed successfully' });
    process.exit(0);
  } catch (error) {
    logger.error({ message: 'Migration runner failed', error });
    process.exit(1);
  }
}

// Run if this file is executed directly
if (require.main === module) {
  main();
}

export { runMigrations };