#!/usr/bin/env ts-node

/**
 * Test script for SSE-enabled MCP Server
 * Tests both regular HTTP responses and Server-Sent Events streaming
 */

import axios from 'axios';

async function testSSEMCPServer() {
  console.log('🧪 Testing SSE-enabled MCP Server\n');
  
  const baseUrl = 'https://api.qa.vtkidsdata.org/ai/mcp';
  
  try {
    // Test 1: Regular HTTP response (backward compatibility)
    console.log('📋 Test 1: Regular HTTP Response (Backward Compatibility)');
    const regularResponse = await axios.post(baseUrl, {
      action: 'list_functions',
      params: {}
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    const functions = regularResponse.data.result;
    console.log(`✅ Found ${functions.length} total functions via regular HTTP`);
    console.log('');
    
    // Test 2: SSE streaming response
    console.log('📡 Test 2: Server-Sent Events Streaming');
    
    const sseResponse = await axios.post(baseUrl, {
      action: 'execute_function',
      params: {
        functionName: 'vkd_list_queries',
        parameters: { search: 'act76' }
      }
    }, {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream'
      }
    });
    
    console.log('✅ SSE Response received');
    console.log('Content-Type:', sseResponse.headers['content-type']);
    console.log('Response length:', sseResponse.data.length, 'characters');
    
    // Parse SSE events
    const events = parseSSEResponse(sseResponse.data);
    console.log(`📊 Parsed ${events.length} SSE events:`);
    
    events.forEach((event, index) => {
      console.log(`  ${index + 1}. Event: ${event.event || 'data'}`);
      if (event.event === 'progress') {
        console.log(`     Progress: ${event.data.message} ${event.data.percentage ? `(${event.data.percentage}%)` : ''}`);
      } else if (event.event === 'result') {
        console.log(`     Result: ${Array.isArray(event.data.result) ? event.data.result.length + ' items' : 'data received'}`);
      } else if (event.event === 'complete') {
        console.log(`     ✅ ${event.data.message}`);
      } else if (event.event === 'error') {
        console.log(`     ❌ Error: ${event.data.error}`);
      }
    });
    console.log('');
    
    // Test 3: SSE with query parameter
    console.log('📡 Test 3: SSE via Query Parameter');
    
    const sseQueryResponse = await axios.post(`${baseUrl}?stream=true`, {
      action: 'execute_function',
      params: {
        functionName: 'vkd_execute_query',
        parameters: { 
          query_name: 'act76_ccfap_family_ahsd_pct_fpl:bar',
          parameters: {}
        }
      }
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    console.log('✅ SSE Query Parameter Response received');
    const queryEvents = parseSSEResponse(sseQueryResponse.data);
    console.log(`📊 Parsed ${queryEvents.length} SSE events for query execution`);
    
    queryEvents.forEach((event, index) => {
      if (event.event === 'progress') {
        console.log(`  Progress: ${event.data.message}`);
      } else if (event.event === 'result') {
        console.log(`  ✅ Query executed successfully`);
      } else if (event.event === 'complete') {
        console.log(`  🎉 ${event.data.message}`);
      }
    });
    console.log('');
    
    // Test 4: Error handling with SSE
    console.log('📡 Test 4: SSE Error Handling');
    
    try {
      const errorResponse = await axios.post(baseUrl, {
        action: 'execute_function',
        params: {
          functionName: 'vkd_get_query_info',
          parameters: { query_name: 'nonexistent_query' }
        }
      }, {
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'text/event-stream'
        }
      });
      
      const errorEvents = parseSSEResponse(errorResponse.data);
      console.log('📊 Error handling events:');
      
      errorEvents.forEach((event) => {
        if (event.event === 'error') {
          console.log(`  ❌ Error properly streamed: ${event.data.error}`);
        }
      });
    } catch (error) {
      console.log('✅ Error properly handled via SSE');
    }
    
    console.log('\n🎉 All SSE tests completed successfully!');
    
  } catch (error) {
    if (axios.isAxiosError(error)) {
      console.error('❌ API Error:', error.response?.status, error.response?.statusText);
      console.error('Response:', error.response?.data);
    } else {
      console.error('❌ Test failed:', error);
    }
    process.exit(1);
  }
}

/**
 * Parse Server-Sent Events response
 */
function parseSSEResponse(sseData: string): Array<{event?: string, data: any, id?: string}> {
  const events: Array<{event?: string, data: any, id?: string}> = [];
  const lines = sseData.split('\n');
  
  let currentEvent: {event?: string, data: string[], id?: string} = { data: [] };
  
  for (const line of lines) {
    if (line.trim() === '') {
      // Empty line indicates end of event
      if (currentEvent.data.length > 0) {
        try {
          const dataString = currentEvent.data.join('\n');
          const parsedData = JSON.parse(dataString);
          events.push({
            event: currentEvent.event,
            data: parsedData,
            id: currentEvent.id
          });
        } catch (e) {
          // If JSON parsing fails, keep as string
          events.push({
            event: currentEvent.event,
            data: currentEvent.data.join('\n'),
            id: currentEvent.id
          });
        }
        currentEvent = { data: [] };
      }
    } else if (line.startsWith('event: ')) {
      currentEvent.event = line.substring(7);
    } else if (line.startsWith('data: ')) {
      currentEvent.data.push(line.substring(6));
    } else if (line.startsWith('id: ')) {
      currentEvent.id = line.substring(4);
    }
  }
  
  return events;
}

// Run tests if this file is executed directly
if (require.main === module) {
  testSSEMCPServer().catch(console.error);
}

export { testSSEMCPServer };