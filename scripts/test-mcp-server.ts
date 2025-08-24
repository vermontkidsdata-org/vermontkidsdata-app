import axios from 'axios';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

/**
 * Test script for the MCP server
 * Usage:
 *   ts-node scripts/test-mcp-server.ts --env qa --tool list_functions
 *   ts-node scripts/test-mcp-server.ts --env qa --tool execute_function --params '{"functionName":"children_in_poverty_under_12_all-chart","parameters":{"location":"Vermont","year":"2020"}}'
 */

// Parse command-line arguments
const argv = yargs(hideBin(process.argv))
  .option('env', {
    alias: 'e',
    description: 'Environment (qa or prod)',
    type: 'string',
    demandOption: true,
    choices: ['qa', 'prod']
  })
  .option('tool', {
    alias: 't',
    description: 'Tool name (list_functions or execute_function)',
    type: 'string',
    demandOption: true,
    choices: ['list_functions', 'execute_function']
  })
  .option('params', {
    alias: 'p',
    description: 'Parameters as JSON string',
    type: 'string',
    default: '{}'
  })
  .help()
  .alias('help', 'h')
  .argv as {
    env: string;
    tool: string;
    params: string;
    [x: string]: unknown;
  };

// No need to map tool names as they are already the correct action names

// Main function
async function main() {
  try {
    // Parse parameters
    const params = JSON.parse(argv.params);
    
    // Determine API endpoint based on environment
    const baseUrl = argv.env === 'qa' 
      ? 'https://api.qa.vtkidsdata.org'
      : 'https://api.vtkidsdata.org';
    
    const url = `${baseUrl}/ai/mcp`;
    
    // Prepare request payload
    const payload = {
      action: argv.tool,
      params: params
    };
    
    console.log(`Sending request to ${url}`);
    console.log('Payload:', JSON.stringify(payload, null, 2));
    
    // Send request to MCP server
    const response = await axios.post(url, payload);
    
    // Display response
    console.log('Response:');
    console.log(JSON.stringify(response.data, null, 2));
  } catch (error) {
    if (axios.isAxiosError(error)) {
      console.error('Error making request:');
      console.error(`Status: ${error.response?.status}`);
      console.error('Response data:', error.response?.data);
    } else {
      console.error('Error:', (error as Error).message);
    }
    process.exit(1);
  }
}

main();