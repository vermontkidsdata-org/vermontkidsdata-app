import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { UniversalMCPServer } from "./universal-mcp-server";
import { getAssistantInfo } from "./assistant-def";

/**
 * SSE-Enhanced MCP Server
 * Supports both regular HTTP responses and Server-Sent Events streaming
 */

interface SSEMessage {
  id?: string;
  event?: string;
  data: any;
  retry?: number;
}

class SSEStream {
  private messages: string[] = [];
  private id: number = 0;

  /**
   * Add a message to the SSE stream
   */
  write(message: SSEMessage): void {
    const lines: string[] = [];
    
    if (message.id) {
      lines.push(`id: ${message.id}`);
    } else {
      lines.push(`id: ${++this.id}`);
    }
    
    if (message.event) {
      lines.push(`event: ${message.event}`);
    }
    
    if (message.retry) {
      lines.push(`retry: ${message.retry}`);
    }
    
    // Handle multi-line data
    const dataString = typeof message.data === 'string' 
      ? message.data 
      : JSON.stringify(message.data);
    
    dataString.split('\n').forEach(line => {
      lines.push(`data: ${line}`);
    });
    
    lines.push(''); // Empty line to separate messages
    
    this.messages.push(lines.join('\n'));
  }

  /**
   * Add a progress message
   */
  progress(message: string, step?: number, total?: number): void {
    this.write({
      event: 'progress',
      data: {
        message,
        step,
        total,
        timestamp: new Date().toISOString()
      }
    });
  }

  /**
   * Add a data message
   */
  data(data: any): void {
    this.write({
      event: 'data',
      data
    });
  }

  /**
   * Add an error message
   */
  error(error: Error): void {
    this.write({
      event: 'error',
      data: {
        error: error.message,
        timestamp: new Date().toISOString()
      }
    });
  }

  /**
   * Add a completion message
   */
  complete(): void {
    this.write({
      event: 'complete',
      data: {
        message: 'Stream completed',
        timestamp: new Date().toISOString()
      }
    });
  }

  /**
   * Get the complete SSE stream as string
   */
  toString(): string {
    return this.messages.join('\n');
  }
}

class SSEMCPServer extends UniversalMCPServer {
  /**
   * Execute function with SSE streaming support
   */
  async executeWithStreaming(functionName: string, parameters: Record<string, any>, stream: SSEStream): Promise<any> {
    stream.progress(`Starting execution of ${functionName}`, 1, 4);
    
    try {
      // Execute the function
      stream.progress(`Executing function...`, 2, 4);
      const result = await this.executeFunction(functionName, parameters);
      
      stream.progress(`Function completed successfully`, 3, 4);
      stream.data(result);
      
      stream.progress(`Streaming complete`, 4, 4);
      stream.complete();
      
      return result;
    } catch (error) {
      stream.error(error as Error);
      stream.complete();
      throw error;
    }
  }

  /**
   * List functions with SSE streaming support
   */
  async listFunctionsWithStreaming(stream: SSEStream): Promise<any> {
    stream.progress(`Loading function definitions...`, 1, 3);
    
    try {
      const functions = await this.listFunctions();
      
      stream.progress(`Found ${functions.length} functions`, 2, 3);
      stream.data(functions);
      
      stream.progress(`Function list complete`, 3, 3);
      stream.complete();
      
      return functions;
    } catch (error) {
      stream.error(error as Error);
      stream.complete();
      throw error;
    }
  }
}

/**
 * SSE-enabled Lambda handler for MCP requests
 */
export const sseHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  // Set standard JSON headers
  const headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Accept, Cache-Control',
  };

  // Check if client wants SSE
  const acceptHeader = event.headers.Accept || event.headers.accept || '';
  const wantsSSE = acceptHeader.includes('text/event-stream');

  // SSE-specific headers
  const sseHeaders = {
    ...headers,
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
    'Access-Control-Allow-Headers': 'Content-Type, Accept, Cache-Control',
  };

  // Handle OPTIONS request for CORS
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: wantsSSE ? sseHeaders : headers,
      body: '',
    };
  }

  try {
    // Support both formats for backward compatibility
    let action: string;
    let params: Record<string, any> = {};

    // Handle GET requests with query parameters
    if (event.httpMethod === 'GET') {
      const queryParams = event.queryStringParameters || {};
      action = queryParams.action || 'list_functions';
      
      // Parse parameters from query string
      if (queryParams.params) {
        try {
          params = JSON.parse(queryParams.params);
        } catch {
          params = {};
        }
      }
      
      // Handle individual query parameters for common actions
      if (action === 'execute_function') {
        params.functionName = queryParams.functionName || params.functionName;
        if (queryParams.parameters) {
          try {
            params.parameters = JSON.parse(queryParams.parameters);
          } catch {
            params.parameters = {};
          }
        }
      }
    } else {
      // Handle POST requests with JSON body
      const body = JSON.parse(event.body || "{}");
      
      // New format: { "action": "list_functions", "params": {...} }
      if (body.action) {
        action = body.action;
        params = body.params || {};
      }
      // Legacy format: { "tool_name": "list_functions", "arguments": {...} }
      else if (body.tool_name) {
        const { tool_name, arguments: toolArguments } = body;
        
        if (tool_name === 'list_functions') {
          action = 'list_functions';
        } else if (tool_name === 'execute_function') {
          action = 'execute_function';
          params = {
            functionName: toolArguments?.functionName,
            parameters: toolArguments?.parameters || {},
          };
        } else {
          // Check if it's one of our universal functions
          if (['vkd_list_queries', 'vkd_get_query_info', 'vkd_execute_query', 'vkd_get_filter_values'].includes(tool_name)) {
            action = 'execute_function';
            params = {
              functionName: tool_name,
              parameters: toolArguments || {}
            };
          } else {
            return {
              statusCode: 400,
              headers: wantsSSE ? sseHeaders : headers,
              body: wantsSSE 
                ? 'event: error\ndata: {"error": "Invalid tool_name"}\n\n'
                : JSON.stringify({ error: `Invalid tool_name: ${tool_name}` }),
            };
          }
        }
      } else {
        return {
          statusCode: 400,
          headers: wantsSSE ? sseHeaders : headers,
          body: wantsSSE 
            ? 'event: error\ndata: {"error": "Invalid request format"}\n\n'
            : JSON.stringify({ error: "Invalid request format. Expected 'action' or 'tool_name' field" }),
        };
      }
    }

    // Get the assistant info
    const envName = process.env.VKD_ENVIRONMENT || "qa";
    const { assistant } = await getAssistantInfo(envName);

    // Create the enhanced MCP server
    const mcpServer = new SSEMCPServer(assistant);

    // Handle SSE streaming
    if (wantsSSE) {
      const stream = new SSEStream();
      
      try {
        if (action === 'list_functions') {
          await mcpServer.listFunctionsWithStreaming(stream);
        } else if (action === 'execute_function') {
          const { functionName, parameters } = params;
          if (!functionName) {
            throw new Error("Function name is required");
          }
          await mcpServer.executeWithStreaming(functionName, parameters || {}, stream);
        } else {
          throw new Error(`Unknown action: ${action}`);
        }

        return {
          statusCode: 200,
          headers: sseHeaders,
          body: stream.toString(),
        };
      } catch (error) {
        stream.error(error as Error);
        stream.complete();
        
        return {
          statusCode: 500,
          headers: sseHeaders,
          body: stream.toString(),
        };
      }
    } else {
      // Handle regular HTTP response
      const result = await mcpServer.processRequest(action, params);

      return {
        statusCode: 200,
        headers,
        body: JSON.stringify({ result }),
      };
    }
  } catch (error) {
    console.error("Error processing MCP request:", error);
    
    if (wantsSSE) {
      const stream = new SSEStream();
      stream.error(error as Error);
      stream.complete();
      
      return {
        statusCode: 500,
        headers: sseHeaders,
        body: stream.toString(),
      };
    } else {
      return {
        statusCode: 500,
        headers,
        body: JSON.stringify({ error: (error as Error).message }),
      };
    }
  }
};

// Export both handlers for flexibility
export const handler = sseHandler;