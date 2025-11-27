#!/usr/bin/env node

import * as yargs from 'yargs';
import { execSync } from 'child_process';

interface ExecutionDetails {
  executionArn: string;
  stateMachineArn: string;
  name: string;
  status: string;
  startDate: string;
  input?: string;
  inputId?: string;
}

interface CliArgs {
  id: string;
  region?: string;
  profile?: string;
  stateMachine?: string;
  status?: string;
  maxResults?: number;
  verbose?: boolean;
}

/**
 * Execute AWS CLI command and return parsed JSON result
 */
function executeAwsCommand(command: string): any {
  try {
    const result = execSync(command, { encoding: 'utf-8', stdio: ['pipe', 'pipe', 'pipe'] });
    return JSON.parse(result);
  } catch (error) {
    if (error instanceof Error) {
      console.error(`AWS CLI command failed: ${command}`);
      console.error(`Error: ${error.message}`);
    }
    throw error;
  }
}

/**
 * List all state machines or filter by name pattern
 */
function listStateMachines(args: CliArgs): any[] {
  const awsOptions = buildAwsOptions(args);
  const command = `aws stepfunctions list-state-machines ${awsOptions}`;
  
  console.log(`Listing state machines...`);
  const result = executeAwsCommand(command);
  
  let stateMachines = result.stateMachines || [];
  
  // Filter for QA state machines if no specific state machine is provided
  if (!args.stateMachine) {
    stateMachines = stateMachines.filter((sm: any) => 
      sm.name.toLowerCase().includes('qa') || 
      sm.name.toLowerCase().includes('quality') ||
      sm.name.toLowerCase().includes('test')
    );
  } else {
    stateMachines = stateMachines.filter((sm: any) => 
      sm.name.includes(args.stateMachine)
    );
  }
  
  console.log(`Found ${stateMachines.length} QA state machine(s)`);
  return stateMachines;
}

/**
 * List executions for a specific state machine
 */
function listExecutions(stateMachineArn: string, args: CliArgs): any[] {
  const awsOptions = buildAwsOptions(args);
  const statusFilter = args.status ? `--status-filter ${args.status}` : '';
  const maxResults = args.maxResults ? `--max-results ${args.maxResults}` : '--max-results 100';
  
  const command = `aws stepfunctions list-executions --state-machine-arn "${stateMachineArn}" ${statusFilter} ${maxResults} ${awsOptions}`;
  
  if (args.verbose) {
    console.log(`Executing: ${command}`);
  }
  
  const result = executeAwsCommand(command);
  return result.executions || [];
}

/**
 * Get execution details including input
 */
function getExecutionDetails(executionArn: string, args: CliArgs): any {
  const awsOptions = buildAwsOptions(args);
  const command = `aws stepfunctions describe-execution --execution-arn "${executionArn}" ${awsOptions}`;
  
  if (args.verbose) {
    console.log(`Getting details for: ${executionArn}`);
  }
  
  return executeAwsCommand(command);
}

/**
 * Build AWS CLI options string
 */
function buildAwsOptions(args: CliArgs): string {
  const options: string[] = [];
  
  if (args.region) {
    options.push(`--region ${args.region}`);
  }
  
  if (args.profile) {
    options.push(`--profile ${args.profile}`);
  }
  
  options.push('--output json');
  
  return options.join(' ');
}

/**
 * Parse execution input and extract ID if present
 */
function parseExecutionInput(input: string): string | null {
  try {
    const inputObj = JSON.parse(input);
    
    // Check various common ID field names
    const idFields = ['id', 'Id', 'ID', 'identifier', 'executionId', 'requestId'];
    
    for (const field of idFields) {
      if (inputObj[field]) {
        return String(inputObj[field]);
      }
    }
    
    return null;
  } catch (error) {
    // Input is not valid JSON or doesn't contain an ID
    return null;
  }
}

/**
 * Main function to find executions with matching ID
 */
async function findExecutionsWithId(args: CliArgs): Promise<ExecutionDetails[]> {
  const matchingExecutions: ExecutionDetails[] = [];
  
  try {
    // Get all QA state machines
    const stateMachines = listStateMachines(args);
    
    if (stateMachines.length === 0) {
      console.log('No QA state machines found');
      return matchingExecutions;
    }
    
    // Process each state machine
    for (const stateMachine of stateMachines) {
      console.log(`\nChecking executions for: ${stateMachine.name}`);
      
      try {
        const executions = listExecutions(stateMachine.stateMachineArn, args);
        console.log(`Found ${executions.length} execution(s)`);
        
        // Check each execution
        for (const execution of executions) {
          try {
            const details = getExecutionDetails(execution.executionArn, args);
            
            if (details.input) {
              const inputId = parseExecutionInput(details.input);
              
              if (inputId === args.id) {
                const executionDetail: ExecutionDetails = {
                  executionArn: execution.executionArn,
                  stateMachineArn: stateMachine.stateMachineArn,
                  name: execution.name,
                  status: execution.status,
                  startDate: execution.startDate,
                  input: details.input,
                  inputId: inputId
                };
                
                matchingExecutions.push(executionDetail);
                console.log(`✓ Found matching execution: ${execution.name}`);
                
                // Exit immediately after finding the first match
                console.log('Found first matching execution, stopping search.');
                return matchingExecutions;
              } else if (args.verbose && inputId) {
                console.log(`  - Execution ${execution.name} has ID: ${inputId}`);
              }
            }
          } catch (error) {
            if (args.verbose) {
              console.error(`Error processing execution ${execution.name}:`, error);
            }
          }
        }
      } catch (error) {
        console.error(`Error processing state machine ${stateMachine.name}:`, error);
      }
    }
    
  } catch (error) {
    console.error('Error finding executions:', error);
    throw error;
  }
  
  return matchingExecutions;
}

/**
 * Display results
 */
function displayResults(executions: ExecutionDetails[], args: CliArgs): void {
  console.log(`\n=== RESULTS ===`);
  
  if (executions.length === 0) {
    console.log(`No executions found with ID: ${args.id}`);
    return;
  }
  
  console.log(`Found first matching execution with ID: ${args.id}`);
  
  const execution = executions[0]; // Only show the first (and only) match
  console.log(`\nName: ${execution.name}`);
  console.log(`Status: ${execution.status}`);
  console.log(`Start Date: ${execution.startDate}`);
  console.log(`Execution ARN: ${execution.executionArn}`);
  console.log(`State Machine ARN: ${execution.stateMachineArn}`);
  
  if (args.verbose && execution.input) {
    console.log(`Input: ${execution.input}`);
  }
}

// CLI setup
const argv = yargs
  .usage('Usage: $0 --id <id> [options]')
  .option('id', {
    alias: 'i',
    type: 'string',
    demandOption: true,
    describe: 'ID to search for in state machine execution inputs'
  })
  .option('region', {
    alias: 'r',
    type: 'string',
    describe: 'AWS region (defaults to AWS CLI default)'
  })
  .option('profile', {
    alias: 'p',
    type: 'string',
    describe: 'AWS profile to use (defaults to AWS CLI default)'
  })
  .option('state-machine', {
    alias: 's',
    type: 'string',
    describe: 'Filter state machines by name pattern (defaults to QA-related machines)'
  })
  .option('status', {
    type: 'string',
    choices: ['RUNNING', 'SUCCEEDED', 'FAILED', 'TIMED_OUT', 'ABORTED'],
    describe: 'Filter executions by status'
  })
  .option('max-results', {
    alias: 'm',
    type: 'number',
    default: 100,
    describe: 'Maximum number of executions to check per state machine'
  })
  .option('verbose', {
    alias: 'v',
    type: 'boolean',
    default: false,
    describe: 'Enable verbose output'
  })
  .help()
  .alias('help', 'h')
  .example('$0 --id "12345"', 'Find executions with ID "12345"')
  .example('$0 --id "abc-123" --region us-east-1 --verbose', 'Find executions with verbose output in us-east-1')
  .example('$0 --id "test-id" --state-machine "MyQAStateMachine" --status SUCCEEDED', 'Find successful executions in specific state machine')
  .argv as CliArgs;

// Main execution
(async () => {
  try {
    console.log(`Searching for executions with ID: ${argv.id}`);
    
    const executions = await findExecutionsWithId(argv);
    displayResults(executions, argv);
    
    process.exit(0);
  } catch (error) {
    console.error('Script failed:', error);
    process.exit(1);
  }
})();