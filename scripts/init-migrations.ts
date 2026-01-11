#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/types';
import {
  DBMigration,
  DBMigrationData,
  getAllDBMigrations
} from '../src/db-utils';

const { VKD_ENVIRONMENT, LOG_LEVEL } = process.env;

// Set up logging
const serviceName = `migration-init-${VKD_ENVIRONMENT}`;
const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});

// Files that should be marked as "run every time"
const RUN_EVERY_TIME_FILES = [
  '20250924-act76.sql',
  'act76-child-data-2025-09.sql',
  'act76-family-data-2025-09.sql'
];

/**
 * Get all SQL files from the scripts directory
 */
function getSQLFiles(): string[] {
  const scriptsDir = path.join(__dirname);
  const files = fs.readdirSync(scriptsDir);
  
  const sqlFiles = files
    .filter(file => file.endsWith('.sql'))
    .sort(); // Alphanumeric sort
  
  logger.info({ message: `Found ${sqlFiles.length} SQL files`, files: sqlFiles });
  return sqlFiles;
}

/**
 * Initialize migration records for all existing SQL files
 */
async function initializeMigrations(): Promise<void> {
  logger.info({ message: 'Starting migration initialization process' });
  
  try {
    // Get all SQL files
    const sqlFiles = getSQLFiles();
    
    if (sqlFiles.length === 0) {
      logger.info({ message: 'No SQL files found - initialization complete' });
      return;
    }
    
    // Get existing migration records to avoid duplicates
    const existingMigrations = await getAllDBMigrations();
    const existingFilenames = new Set(existingMigrations.map(m => m.filename));
    
    logger.info({ message: `Found ${existingMigrations.length} existing migration records` });
    
    let createdCount = 0;
    let skippedCount = 0;
    
    // Create migration records for each SQL file
    for (const filename of sqlFiles) {
      if (existingFilenames.has(filename)) {
        logger.info({ message: `Migration record already exists for ${filename} - skipping` });
        skippedCount++;
        continue;
      }
      
      const runEveryTime = RUN_EVERY_TIME_FILES.includes(filename);
      const migrationData: DBMigrationData = {
        filename,
        executedAt: new Date().toISOString(),
        runEveryTime
      };
      
      try {
        await DBMigration.put(migrationData);
        logger.info({ 
          message: `Created migration record for ${filename}`, 
          runEveryTime 
        });
        createdCount++;
      } catch (error) {
        logger.error({ 
          message: `Failed to create migration record for ${filename}`, 
          error 
        });
        throw new Error(`Failed to initialize migration record for ${filename}: ${error}`);
      }
    }
    
    logger.info({ 
      message: 'Migration initialization completed successfully',
      totalFiles: sqlFiles.length,
      created: createdCount,
      skipped: skippedCount,
      runEveryTimeFiles: RUN_EVERY_TIME_FILES.length
    });
    
  } catch (error) {
    logger.error({ message: 'Migration initialization failed', error });
    throw error;
  }
}

/**
 * CLI entry point
 */
async function main(): Promise<void> {
  try {
    // Validate environment
    if (!VKD_ENVIRONMENT) {
      throw new Error('VKD_ENVIRONMENT environment variable is required');
    }
    
    logger.info({ message: `Initializing migrations for environment: ${VKD_ENVIRONMENT}` });
    
    // Confirm with user before proceeding
    console.log('\n=== MIGRATION INITIALIZATION ===');
    console.log('This script will create DynamoDB records for all existing SQL files in the scripts directory.');
    console.log('This marks them as "already executed" so they won\'t run during future migrations.');
    console.log('\nFiles that will be marked as "run every time":');
    RUN_EVERY_TIME_FILES.forEach(file => console.log(`  - ${file}`));
    console.log('\nAll other files will be marked as "executed once".');
    console.log('\nThis should only be run ONCE during initial setup.');
    console.log('\nPress Ctrl+C to cancel, or any key to continue...');
    
    // Wait for user input (in a real CLI environment)
    // For automated environments, we'll skip this check if SKIP_CONFIRMATION is set
    if (!process.env.SKIP_CONFIRMATION) {
      await new Promise(resolve => {
        process.stdin.setRawMode(true);
        process.stdin.resume();
        process.stdin.once('data', () => {
          process.stdin.setRawMode(false);
          process.stdin.pause();
          resolve(void 0);
        });
      });
    }
    
    await initializeMigrations();
    
    logger.info({ message: 'Migration initialization completed successfully' });
    console.log('\n✅ Migration initialization completed successfully!');
    console.log('All existing SQL files have been marked as executed.');
    console.log('Future migrations will only run new SQL files or those marked as "run every time".');
    
    process.exit(0);
  } catch (error) {
    logger.error({ message: 'Migration initialization failed', error });
    console.error('\n❌ Migration initialization failed:', error);
    process.exit(1);
  }
}

// Run if this file is executed directly
if (require.main === module) {
  main();
}

export { initializeMigrations };