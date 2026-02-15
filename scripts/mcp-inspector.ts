#!/usr/bin/env ts-node

import axios from 'axios';
import * as readline from 'readline';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

/**
 * Interactive MCP Inspector
 * A tool to explore and test MCP servers following the MCP HTTP protocol
 * 
 * Usage:
 *   npx ts-node scripts/mcp-inspector.ts --env qa
 *   npx ts-node scripts/mcp-inspector.ts --env prod
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

class MCPInspector {
  private baseUrl: string;
  private rl: readline.Interface;

  constructor(environment: string) {
    this.baseUrl = environment === 'qa' 
      ? 'https://api.qa.vtkidsdata.org'
      : 'https://api.vtkidsdata.org';
    
    this.rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });
  }

  private async makeRequest(action: string, params: Record<string, any> = {}): Promise<any> {
    const url = `${this.baseUrl}/ai/mcp`;
    const payload = { action, params };
    
    console.log(`\n🔄 Making request to ${url}`);
    console.log(`📤 Payload: ${JSON.stringify(payload, null, 2)}`);
    
    try {
      const response = await axios.post(url, payload);
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

  private async listFunctions(): Promise<MCPFunction[]> {
    console.log('\n📋 Fetching available functions...');
    const response: MCPResponse = await this.makeRequest('list_functions');
    return response.result;
  }

  private displayFunctions(functions: MCPFunction[]): void {
    console.log('\n📚 Available Functions:');
    console.log('='.repeat(80));
    
    functions.forEach((func, index) => {
      console.log(`\n${index + 1}. ${func.function.name}`);
      console.log(`   📝 ${func.function.description}`);
      
      const params = func.function.parameters;
      if (params && params.properties && Object.keys(params.properties).length > 0) {
        console.log('   📋 Parameters:');
        Object.entries(params.properties).forEach(([paramName, paramDef]: [string, any]) => {
          const required = params.required?.includes(paramName) ? '(required)' : '(optional)';
          const type = paramDef.type || 'unknown';
          console.log(`     • ${paramName}: ${type} ${required}`);
          if (paramDef.description) {
            console.log(`       ${paramDef.description}`);
          }
          if (paramDef.enum) {
            console.log(`       Options: ${paramDef.enum.join(', ')}`);
          }
        });
      } else {
        console.log('   📋 No parameters required');
      }
    });
    console.log('='.repeat(80));
  }

  private async promptUser(question: string): Promise<string> {
    return new Promise((resolve) => {
      this.rl.question(question, (answer) => {
        resolve(answer.trim());
      });
    });
  }

  private async selectFunction(functions: MCPFunction[]): Promise<MCPFunction | null> {
    while (true) {
      const selection = await this.promptUser('\n🎯 Select a function (number) or "q" to quit: ');
      
      if (selection.toLowerCase() === 'q') {
        return null;
      }
      
      const index = parseInt(selection) - 1;
      if (index >= 0 && index < functions.length) {
        return functions[index];
      }
      
      console.log('❌ Invalid selection. Please try again.');
    }
  }

  private async collectParameters(func: MCPFunction): Promise<Record<string, any>> {
    const parameters: Record<string, any> = {};
    const paramDefs = func.function.parameters?.properties || {};
    const required = func.function.parameters?.required || [];
    
    console.log(`\n🔧 Collecting parameters for: ${func.function.name}`);
    
    for (const [paramName, paramDef] of Object.entries(paramDefs)) {
      const isRequired = required.includes(paramName);
      const paramInfo = paramDef as any;
      
      let prompt = `📝 ${paramName} (${paramInfo.type || 'unknown'})`;
      if (isRequired) {
        prompt += ' [REQUIRED]';
      }
      if (paramInfo.description) {
        prompt += `\n   ${paramInfo.description}`;
      }
      if (paramInfo.enum) {
        prompt += `\n   Options: ${paramInfo.enum.join(', ')}`;
      }
      prompt += '\n   Value: ';
      
      while (true) {
        const value = await this.promptUser(prompt);
        
        // Skip optional parameters if empty
        if (!value && !isRequired) {
          break;
        }
        
        // Require value for required parameters
        if (!value && isRequired) {
          console.log('❌ This parameter is required. Please provide a value.');
          continue;
        }
        
        // Type conversion and validation
        try {
          let convertedValue: any = value;
          
          switch (paramInfo.type) {
            case 'number':
              convertedValue = parseFloat(value);
              if (isNaN(convertedValue)) {
                throw new Error('Must be a valid number');
              }
              break;
            case 'boolean':
              convertedValue = value.toLowerCase() === 'true';
              break;
            case 'object':
              if (value) {
                convertedValue = JSON.parse(value);
              }
              break;
            case 'array':
              if (value) {
                convertedValue = JSON.parse(value);
              }
              break;
          }
          
          // Enum validation
          if (paramInfo.enum && !paramInfo.enum.includes(convertedValue)) {
            throw new Error(`Must be one of: ${paramInfo.enum.join(', ')}`);
          }
          
          parameters[paramName] = convertedValue;
          break;
        } catch (error) {
          console.log(`❌ Invalid value: ${(error as Error).message}`);
        }
      }
    }
    
    return parameters;
  }

  private async executeFunction(functionName: string, parameters: Record<string, any>): Promise<void> {
    console.log(`\n🚀 Executing function: ${functionName}`);
    console.log(`📋 Parameters: ${JSON.stringify(parameters, null, 2)}`);
    
    try {
      const response = await this.makeRequest('execute_function', {
        functionName,
        parameters
      });
      
      console.log('\n✅ Function executed successfully!');
      console.log('📥 Result:');
      console.log(JSON.stringify(response.result, null, 2));
      
      // If there's a URL in the result, highlight it
      if (response.result && response.result.url) {
        console.log(`\n🔗 View result at: ${response.result.url}`);
      }
    } catch (error) {
      console.log('\n❌ Function execution failed');
    }
  }

  async run(): Promise<void> {
    console.log('🔍 MCP Inspector - Interactive MCP Server Explorer');
    console.log(`🌐 Environment: ${this.baseUrl}`);
    
    try {
      // List all available functions
      const functions = await this.listFunctions();
      
      if (!functions || functions.length === 0) {
        console.log('❌ No functions available');
        return;
      }
      
      // Main interaction loop
      while (true) {
        this.displayFunctions(functions);
        
        const selectedFunction = await this.selectFunction(functions);
        if (!selectedFunction) {
          console.log('👋 Goodbye!');
          break;
        }
        
        console.log(`\n🎯 Selected: ${selectedFunction.function.name}`);
        
        // Collect parameters
        const parameters = await this.collectParameters(selectedFunction);
        
        // Execute function
        await this.executeFunction(selectedFunction.function.name, parameters);
        
        // Ask if user wants to continue
        const continueChoice = await this.promptUser('\n🔄 Try another function? (y/n): ');
        if (continueChoice.toLowerCase() !== 'y') {
          console.log('👋 Goodbye!');
          break;
        }
      }
    } catch (error) {
      console.error('💥 Inspector failed:', (error as Error).message);
    } finally {
      this.rl.close();
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

// Run the inspector
async function main() {
  const inspector = new MCPInspector(argv.env);
  await inspector.run();
}

if (require.main === module) {
  main().catch(console.error);
}