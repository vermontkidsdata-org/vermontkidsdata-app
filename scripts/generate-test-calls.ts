import fs from 'fs';
import path from 'path';
import axios from 'axios';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

/**
 * Test script that generates calls for the first two functions from the MCP server
 * Usage:
 *   ts-node scripts/generate-test-calls.ts --env qa
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
  .help()
  .alias('help', 'h')
  .argv as {
    env: string;
    [x: string]: unknown;
  };

// Determine API endpoint based on environment
const baseUrl = argv.env === 'qa' 
  ? 'https://api.qa.vtkidsdata.org'
  : 'https://api.vtkidsdata.org';

const url = `${baseUrl}/ai/mcp`;

// Test cases for the first function: children_in_poverty_under_12_all-chart
const childrenInPovertyTests = [
  {
    name: 'Vermont 2020',
    params: {
      functionName: 'children_in_poverty_under_12_all-chart',
      parameters: {
        location: 'Vermont',
        // Note: The "type" parameter is listed in required parameters but not defined in properties
        // Removing it since it might be causing the 500 error
        year: '2020'
      }
    }
  },
  {
    name: 'Chittenden 2019',
    params: {
      functionName: 'children_in_poverty_under_12_all-chart',
      parameters: {
        location: 'Chittenden',
        year: '2019'
      }
    }
  },
  {
    name: 'With older year (should use earliest available)',
    params: {
      functionName: 'children_in_poverty_under_12_all-chart',
      parameters: {
        location: 'Vermont',
        year: '2015' // Before the minimum year of 2017
      }
    }
  }
];

// Test cases for the second function: avgbenefit_3squares_vt-chart
const avgBenefitTests = [
  {
    name: 'Individual 2020',
    params: {
      functionName: 'avgbenefit_3squares_vt-chart',
      parameters: {
        group: 'individual',
        year: '2020'
      }
    }
  },
  {
    name: 'Household 2019',
    params: {
      functionName: 'avgbenefit_3squares_vt-chart',
      parameters: {
        group: 'household',
        year: '2019'
      }
    }
  },
  {
    name: 'Only required parameter',
    params: {
      functionName: 'avgbenefit_3squares_vt-chart',
      parameters: {
        group: 'individual'
        // Year is optional, so not providing it
      }
    }
  }
];

// Function to run a test case
async function runTest(testCase: { name: string, params: any }) {
  console.log(`\n=== Running test: ${testCase.name} ===`);
  
  const payload = {
    action: 'execute_function',
    params: testCase.params
  };
  
  console.log(`Sending request to ${url}`);
  console.log('Payload:', JSON.stringify(payload, null, 2));
  
  try {
    const response = await axios.post(url, payload);
    console.log('Response:');
    console.log(JSON.stringify(response.data, null, 2));
    return { success: true, result: response.data };
  } catch (error) {
    if (axios.isAxiosError(error)) {
      console.error('Error making request:');
      console.error(`Status: ${error.response?.status}`);
      console.error('Response data:', error.response?.data);
    } else {
      console.error('Error:', (error as Error).message);
    }
    return { success: false, error };
  }
}

// Main function
async function main() {
  console.log(`Testing MCP server in ${argv.env} environment`);
  
  // Create results directory if it doesn't exist
  const resultsDir = path.join(__dirname, 'test-results');
  if (!fs.existsSync(resultsDir)) {
    fs.mkdirSync(resultsDir);
  }
  
  // Run tests for the first function
  console.log('\n=== Testing children_in_poverty_under_12_all-chart ===');
  const childrenResults = [];
  for (const test of childrenInPovertyTests) {
    const result = await runTest(test);
    childrenResults.push({ test, result });
  }
  
  // Run tests for the second function
  console.log('\n=== Testing avgbenefit_3squares_vt-chart ===');
  const avgBenefitResults = [];
  for (const test of avgBenefitTests) {
    const result = await runTest(test);
    avgBenefitResults.push({ test, result });
  }
  
  // Save results to file
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const resultsFile = path.join(resultsDir, `test-results-${timestamp}.json`);
  
  fs.writeFileSync(
    resultsFile,
    JSON.stringify(
      {
        timestamp,
        environment: argv.env,
        childrenInPovertyTests: childrenResults,
        avgBenefitTests: avgBenefitResults
      },
      null,
      2
    )
  );
  
  console.log(`\nTest results saved to ${resultsFile}`);
}

main().catch(error => {
  console.error('Unhandled error:', error);
  process.exit(1);
});