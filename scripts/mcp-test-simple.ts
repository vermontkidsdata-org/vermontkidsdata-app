#!/usr/bin/env ts-node

import axios from 'axios';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

/**
 * Simple MCP Tester - Non-interactive version for testing
 * 
 * Usage:
 *   npx ts-node scripts/mcp-test-simple.ts --env qa
 */

interface MCPFunction {
  type: string;
  function: {
    name: string;
    description: string;
    parameters: {
      type: string;
      properties: Record<string, any>;
      required?: string[];
    };
  };
}

interface MCPResponse {
  result: MCPFunction[] | any;
}

class SimpleMCPTester {
  private baseUrl: string;

  constructor(environment: string) {
    this.baseUrl = environment === 'qa' 
      ? 'https://api.qa.vtkidsdata.org'
      : 'https://api.vtkidsdata.org';
  }

  private async makeRequest(action: string, params: Record<string, any> = {}): Promise<any> {
    const url = `${this.baseUrl}/ai/mcp`;
    const payload = { action, params };
    
    console.log(`🔄 Making request to ${url}`);
    console.log(`📤 Payload: ${JSON.stringify(payload, null, 2)}`);
    
    try {
      const response = await axios.post(url, payload);
      console.log(`✅ Response received (${response.status})`);
      return response.data;
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.error(`❌ HTTP Error ${error.response?.status}: ${error.response?.statusText}`);
        console.error(`📥 Response: ${JSON.stringify(error.response?.data, null, 2)}`);
      } else {
        console.error(`❌ Error: ${(error as Error).message}`);
      }
      throw error;
    }
  }

  async testListFunctions(): Promise<void> {
    console.log('\n📋 Testing list_functions...');
    try {
      const response: MCPResponse = await this.makeRequest('list_functions');
      const functions = response.result;
      
      console.log(`✅ Found ${functions.length} functions:`);
      functions.forEach((func: MCPFunction, index: number) => {
        console.log(`  ${index + 1}. ${func.function.name}`);
        console.log(`     ${func.function.description.substring(0, 100)}...`);
      });
      
      return;
    } catch (error) {
      console.error('❌ Failed to list functions');
      throw error;
    }
  }

  async testExecuteFunction(): Promise<void> {
    console.log('\n🚀 Testing execute_function...');
    try {
      // Test with a simple function that has minimal parameters
      const response = await this.makeRequest('execute_function', {
        functionName: 'avgbenefit_3squares_vt-chart',
        parameters: {
          group: 'individual',
          year: '2020'
        }
      });
      
      console.log('✅ Function executed successfully!');
      console.log('📥 Result:', JSON.stringify(response.result, null, 2));
      
      if (response.result && response.result.url) {
        console.log(`🔗 View result at: ${response.result.url}`);
      }
    } catch (error) {
      console.error('❌ Failed to execute function');
      throw error;
    }
  }

  async runTests(): Promise<void> {
    console.log('🧪 Simple MCP Tester');
    console.log(`🌐 Environment: ${this.baseUrl}`);
    
    try {
      await this.testListFunctions();
      await this.testExecuteFunction();
      console.log('\n🎉 All tests passed!');
    } catch (error) {
      console.error('\n💥 Tests failed:', (error as Error).message);
      process.exit(1);
    }
  }
}

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

// Run the tests
async function main() {
  const tester = new SimpleMCPTester(argv.env);
  await tester.runTests();
}

if (require.main === module) {
  main().catch(console.error);
}