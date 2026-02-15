import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { UniversalMCPServer } from "./universal-mcp-server";

/**
 * MCP-compliant server for Cursor integration
 * Implements the Model Context Protocol specification
 */

interface MCPRequest {
  jsonrpc: "2.0";
  id?: string | number;
  method: string;
  params?: any;
}

interface MCPResponse {
  jsonrpc: "2.0";
  id?: string | number;
  result?: any;
  error?: {
    code: number;
    message: string;
    data?: any;
  };
}

interface MCPTool {
  name: string;
  description: string;
  inputSchema: {
    type: "object";
    properties: Record<string, any>;
    required?: string[];
  };
}

class CursorMCPServer extends UniversalMCPServer {
  constructor() {
    // Create a minimal assistant definition for the MCP server
    const assistant = {
      description: "Vermont Kids Data MCP Server",
      instructions: "Provides access to Vermont Kids Data queries and functions",
      metadata: {},
      model: "gpt-4",
      name: "VKD MCP Server",
      tools: []
    };
    super(assistant);
  }

  /**
   * Handle MCP protocol requests
   */
  async handleMCPRequest(request: MCPRequest): Promise<MCPResponse> {
    try {
      switch (request.method) {
        case "initialize":
          return this.handleInitialize(request);
        
        case "tools/list":
          return this.handleToolsList(request);
        
        case "tools/call":
          return this.handleToolsCall(request);
        
        case "resources/list":
          return this.handleResourcesList(request);
        
        case "prompts/list":
          return this.handlePromptsList(request);
        
        default:
          return {
            jsonrpc: "2.0",
            id: request.id,
            error: {
              code: -32601,
              message: `Method not found: ${request.method}`
            }
          };
      }
    } catch (error) {
      return {
        jsonrpc: "2.0",
        id: request.id,
        error: {
          code: -32603,
          message: "Internal error",
          data: error instanceof Error ? error.message : String(error)
        }
      };
    }
  }

  private async handleInitialize(request: MCPRequest): Promise<MCPResponse> {
    return {
      jsonrpc: "2.0",
      id: request.id,
      result: {
        protocolVersion: "2024-11-05",
        capabilities: {
          tools: {},
          resources: {},
          prompts: {}
        },
        serverInfo: {
          name: "Vermont Kids Data MCP Server",
          version: "1.0.0"
        }
      }
    };
  }

  private async handleToolsList(request: MCPRequest): Promise<MCPResponse> {
    try {
      // Get all functions from the universal server
      const functions = await this.listFunctions();
      
      // Convert to MCP tool format
      const tools: MCPTool[] = functions.map(func => ({
        name: func.function.name,
        description: func.function.description || "No description available",
        inputSchema: {
          type: "object",
          properties: func.function.parameters?.properties || {},
          required: Array.isArray(func.function.parameters?.required) ? func.function.parameters.required : []
        }
      }));

      return {
        jsonrpc: "2.0",
        id: request.id,
        result: {
          tools
        }
      };
    } catch (error) {
      return {
        jsonrpc: "2.0",
        id: request.id,
        error: {
          code: -32603,
          message: "Failed to list tools",
          data: error instanceof Error ? error.message : String(error)
        }
      };
    }
  }

  private async handleToolsCall(request: MCPRequest): Promise<MCPResponse> {
    try {
      const { name, arguments: args } = request.params;
      
      // Execute the function using the universal server
      const result = await this.executeFunction(name, args || {});
      
      return {
        jsonrpc: "2.0",
        id: request.id,
        result: {
          content: [
            {
              type: "text",
              text: JSON.stringify(result, null, 2)
            }
          ]
        }
      };
    } catch (error) {
      return {
        jsonrpc: "2.0",
        id: request.id,
        error: {
          code: -32603,
          message: "Tool execution failed",
          data: error instanceof Error ? error.message : String(error)
        }
      };
    }
  }

  private async handleResourcesList(request: MCPRequest): Promise<MCPResponse> {
    return {
      jsonrpc: "2.0",
      id: request.id,
      result: {
        resources: []
      }
    };
  }

  private async handlePromptsList(request: MCPRequest): Promise<MCPResponse> {
    return {
      jsonrpc: "2.0",
      id: request.id,
      result: {
        prompts: []
      }
    };
  }
}

/**
 * Pure MCP protocol server handler for Cursor
 */
export const cursorMCPHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Accept, Cache-Control',
  };

  // Handle OPTIONS request for CORS
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers,
      body: '',
    };
  }

  try {
    const server = new CursorMCPServer();
    
    // Parse the MCP request
    let mcpRequest: MCPRequest;
    
    if (event.httpMethod === 'GET') {
      // Handle GET requests - convert to MCP format
      const queryParams = event.queryStringParameters || {};
      mcpRequest = {
        jsonrpc: "2.0",
        id: Date.now(),
        method: queryParams.method || "tools/list",
        params: queryParams.params ? JSON.parse(queryParams.params) : {}
      };
    } else {
      // Handle POST requests
      if (!event.body) {
        return {
          statusCode: 400,
          headers,
          body: JSON.stringify({
            jsonrpc: "2.0",
            error: {
              code: -32700,
              message: "Parse error: No request body"
            }
          })
        };
      }

      try {
        mcpRequest = JSON.parse(event.body);
      } catch {
        return {
          statusCode: 400,
          headers,
          body: JSON.stringify({
            jsonrpc: "2.0",
            error: {
              code: -32700,
              message: "Parse error: Invalid JSON"
            }
          })
        };
      }
    }

    // Validate MCP request format
    if (!mcpRequest.jsonrpc || mcpRequest.jsonrpc !== "2.0" || !mcpRequest.method) {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({
          jsonrpc: "2.0",
          id: mcpRequest.id,
          error: {
            code: -32600,
            message: "Invalid Request: Missing required MCP fields"
          }
        })
      };
    }

    // Process the MCP request
    const response = await server.handleMCPRequest(mcpRequest);

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify(response)
    };

  } catch (error) {
    console.error('MCP Server Error:', error);
    
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({
        jsonrpc: "2.0",
        error: {
          code: -32603,
          message: "Internal error",
          data: error instanceof Error ? error.message : String(error)
        }
      })
    };
  }
};