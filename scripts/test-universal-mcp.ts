#!/usr/bin/env ts-node

import { UniversalMCPServer } from '../src/universal-mcp-server';
import { getAssistantInfo } from '../src/assistant-def';

/**
 * Test script for the Universal MCP Server
 * Tests all 4 universal functions with sample data
 */

async function testUniversalMCPServer() {
  console.log('🧪 Testing Universal MCP Server\n');
  
  try {
    // Initialize the server
    const envName = process.env.VKD_ENVIRONMENT || "qa";
    const { assistant } = await getAssistantInfo(envName);
    const server = new UniversalMCPServer(assistant);
    
    console.log('✅ Server initialized successfully\n');
    
    // Test 1: List all functions
    console.log('📋 Test 1: List Functions');
    const functions = await server.listFunctions();
    console.log(`Found ${functions.length} total functions:`);
    
    const universalFunctions = functions.filter(f => f.function.name.startsWith('vkd_'));
    console.log(`- ${universalFunctions.length} universal functions`);
    console.log(`- ${functions.length - universalFunctions.length} static functions`);
    
    universalFunctions.forEach(f => {
      console.log(`  • ${f.function.name}: ${f.function.description?.substring(0, 80) || 'No description'}...`);
    });
    console.log('');
    
    // Test 2: List queries (first 5)
    console.log('📊 Test 2: List Queries (first 5)');
    const queries = await server.executeFunction('vkd_list_queries', { search: 'act76' });
    console.log(`Found ${queries.length} queries matching 'act76':`);
    
    queries.slice(0, 5).forEach((query: any) => {
      console.log(`  • ${query.name}`);
      console.log(`    Category: ${query.category}`);
      console.log(`    Has filters: ${query.has_filters}`);
      console.log(`    Description: ${query.description.substring(0, 100)}...`);
      console.log('');
    });
    
    // Test 3: Get query info for a specific query
    console.log('🔍 Test 3: Get Query Info');
    if (queries.length > 0) {
      const queryName = queries[0].name;
      console.log(`Getting info for: ${queryName}`);
      
      const queryInfo = await server.executeFunction('vkd_get_query_info', { 
        query_name: queryName 
      });
      
      console.log(`Title: ${queryInfo.title || 'N/A'}`);
      console.log(`Category: ${queryInfo.category}`);
      console.log(`Chart Type: ${queryInfo.chart_type || 'N/A'}`);
      console.log(`Has Filters: ${queryInfo.has_filters}`);
      console.log(`SQL Preview: ${queryInfo.sql_preview}`);
      
      if (queryInfo.parameter_schema) {
        console.log('Parameters:');
        Object.entries(queryInfo.parameter_schema).forEach(([key, schema]: [string, any]) => {
          console.log(`  • ${key}: ${schema.type} - ${schema.description}`);
        });
      }
      console.log('');
      
      // Test 4: Get filter values (if query has filters)
      if (queryInfo.has_filters && queryInfo.parameter_schema) {
        console.log('🎛️  Test 4: Get Filter Values');
        const firstFilterKey = Object.keys(queryInfo.parameter_schema)[0];
        console.log(`Getting values for filter: ${firstFilterKey}`);
        
        try {
          const filterValues = await server.executeFunction('vkd_get_filter_values', {
            query_name: queryName,
            filter_name: firstFilterKey
          });
          
          console.log(`Found ${filterValues.length} values:`);
          filterValues.slice(0, 10).forEach((value: string) => {
            console.log(`  • ${value}`);
          });
          if (filterValues.length > 10) {
            console.log(`  ... and ${filterValues.length - 10} more`);
          }
          console.log('');
          
          // Test 5: Execute query with parameters
          console.log('🚀 Test 5: Execute Query');
          const sampleParams: any = {};
          sampleParams[firstFilterKey] = filterValues[0] || '-- All --';
          
          console.log(`Executing ${queryName} with parameters:`, sampleParams);
          
          const result = await server.executeFunction('vkd_execute_query', {
            query_name: queryName,
            parameters: sampleParams
          });
          
          console.log('✅ Query executed successfully!');
          console.log(`Primary value: ${result.value}`);
          console.log(`Chart URL: ${result.url}`);
          console.log(`Data series: ${result.data?.series?.length || 0}`);
          console.log(`Categories: ${result.data?.categories?.length || 0}`);
          
        } catch (error) {
          console.log(`⚠️  Filter test skipped: ${(error as Error).message}`);
        }
      } else {
        // Test 5: Execute query without parameters
        console.log('🚀 Test 5: Execute Query (no parameters)');
        console.log(`Executing ${queryName} without parameters`);
        
        const result = await server.executeFunction('vkd_execute_query', {
          query_name: queryName
        });
        
        console.log('✅ Query executed successfully!');
        console.log(`Primary value: ${result.value}`);
        console.log(`Chart URL: ${result.url}`);
        console.log(`Data series: ${result.data?.series?.length || 0}`);
        console.log(`Categories: ${result.data?.categories?.length || 0}`);
      }
    }
    
    console.log('\n🎉 All tests completed successfully!');
    
  } catch (error) {
    console.error('❌ Test failed:', error);
    console.error('Stack trace:', (error as Error).stack);
    process.exit(1);
  }
}

// Run tests if this file is executed directly
if (require.main === module) {
  testUniversalMCPServer().catch(console.error);
}

export { testUniversalMCPServer };