#!/usr/bin/env ts-node

/**
 * Simple test for Universal MCP Server using HTTP API
 * Tests the 4 universal functions via the deployed API
 */

import axios from 'axios';

async function testUniversalMCPAPI() {
  console.log('🧪 Testing Universal MCP Server via API\n');
  
  const baseUrl = 'https://api.qa.vtkidsdata.org/ai/mcp';
  
  try {
    // Test 1: List functions
    console.log('📋 Test 1: List Functions');
    const functionsResponse = await axios.post(baseUrl, {
      action: 'list_functions',
      params: {}
    });
    
    const functions = functionsResponse.data.result;
    console.log(`Found ${functions.length} total functions`);
    
    const universalFunctions = functions.filter((f: any) => f.function.name.startsWith('vkd_'));
    console.log(`- ${universalFunctions.length} universal functions`);
    console.log(`- ${functions.length - universalFunctions.length} static functions`);
    
    if (universalFunctions.length > 0) {
      console.log('Universal functions found:');
      universalFunctions.forEach((f: any) => {
        console.log(`  • ${f.function.name}`);
      });
    } else {
      console.log('⚠️  No universal functions found - using execute_function approach');
    }
    console.log('');
    
    // Test 2: List queries
    console.log('📊 Test 2: List Queries');
    const queriesResponse = await axios.post(baseUrl, {
      action: 'execute_function',
      params: {
        functionName: 'vkd_list_queries',
        parameters: { search: 'act76' }
      }
    });
    
    const queries = queriesResponse.data.result;
    console.log(`Found ${queries.length} queries matching 'act76'`);
    
    if (queries.length > 0) {
      queries.slice(0, 3).forEach((query: any) => {
        console.log(`  • ${query.name}`);
        console.log(`    Category: ${query.category}`);
        console.log(`    Has filters: ${query.has_filters}`);
      });
      console.log('');
      
      // Test 3: Get query info
      console.log('🔍 Test 3: Get Query Info');
      const queryName = queries[0].name;
      console.log(`Getting info for: ${queryName}`);
      
      const queryInfoResponse = await axios.post(baseUrl, {
        action: 'execute_function',
        params: {
          functionName: 'vkd_get_query_info',
          parameters: { query_name: queryName }
        }
      });
      
      const queryInfo = queryInfoResponse.data.result;
      console.log(`Title: ${queryInfo.title || 'N/A'}`);
      console.log(`Category: ${queryInfo.category}`);
      console.log(`Has Filters: ${queryInfo.has_filters}`);
      console.log('');
      
      // Test 4: Execute query
      console.log('🚀 Test 4: Execute Query');
      const executeResponse = await axios.post(baseUrl, {
        action: 'execute_function',
        params: {
          functionName: 'vkd_execute_query',
          parameters: { 
            query_name: queryName,
            parameters: {}
          }
        }
      });
      
      const result = executeResponse.data.result;
      console.log('✅ Query executed successfully!');
      console.log(`Primary value: ${result.value}`);
      console.log(`Chart URL: ${result.url}`);
      console.log('');
    }
    
    console.log('🎉 All API tests completed successfully!');
    
  } catch (error) {
    if (axios.isAxiosError(error)) {
      console.error('❌ API Error:', error.response?.status, error.response?.statusText);
      console.error('Response:', JSON.stringify(error.response?.data, null, 2));
    } else {
      console.error('❌ Test failed:', error);
    }
    process.exit(1);
  }
}

// Run tests if this file is executed directly
if (require.main === module) {
  testUniversalMCPAPI().catch(console.error);
}

export { testUniversalMCPAPI };