import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { MCPServer } from "./mcp-server-base";
import { LimitedAssistantDef, VKDFunctionTool } from "./assistant-def";
import { getAssistantInfo } from "./assistant-def";
import { QueryFunctionService, QueryInfo, DetailedQueryInfo } from "./query-function-service";

/**
 * Enhanced MCP Server with Universal Query Functions
 * Extends the existing MCP server to add 4 universal functions:
 * 1. vkd_list_queries - List all available queries with metadata
 * 2. vkd_get_query_info - Get detailed information about a specific query
 * 3. vkd_execute_query - Execute any query with parameters
 * 4. vkd_get_filter_values - Get available values for query filters
 */
export class UniversalMCPServer extends MCPServer {
  protected queryService: QueryFunctionService;

  constructor(assistant: LimitedAssistantDef) {
    super(assistant);
    this.queryService = new QueryFunctionService();
  }

  /**
   * Lists all available functions (both static and universal)
   */
  async listFunctions(): Promise<VKDFunctionTool[]> {
    // Get existing static functions
    const staticFunctions = await super.listFunctions();
    
    // Add the 4 universal functions
    const universalFunctions: VKDFunctionTool[] = [
      {
        type: "function",
        function: {
          name: "vkd_list_queries",
          description: "List all available Vermont Kids Data queries with metadata. Supports filtering by category, chart type, and whether queries have filters.",
          parameters: {
            type: "object",
            properties: {
              category: {
                type: "string",
                description: "Filter by category (e.g., 'Child Care Assistance', 'Child Welfare', 'Economic Indicators')",
                enum: [
                  "Child Care Assistance",
                  "Child Welfare", 
                  "Family Services",
                  "Economic Indicators",
                  "Health Statistics",
                  "Education Data",
                  "Housing Data",
                  "General Statistics"
                ]
              },
              has_filters: {
                type: "boolean",
                description: "Filter by whether queries accept parameters (true) or not (false)"
              },
              search: {
                type: "string", 
                description: "Search query names and titles for specific terms"
              },
              chart_type: {
                type: "string",
                description: "Filter by chart type (e.g., 'bar', 'line', 'column')",
                enum: ["bar", "line", "column", "chart"]
              }
            },
            required: []
          }
        }
      },
      {
        type: "function",
        function: {
          name: "vkd_get_query_info",
          description: "Get detailed information about a specific query, including parameter schema, sample parameters, and SQL preview.",
          parameters: {
            type: "object",
            properties: {
              query_name: {
                type: "string",
                description: "The exact name of the query to get information about"
              }
            },
            required: ["query_name"]
          }
        }
      },
      {
        type: "function", 
        function: {
          name: "vkd_execute_query",
          description: "Execute any Vermont Kids Data query with optional parameters. Returns data in standard chart format plus metadata.",
          parameters: {
            type: "object",
            properties: {
              query_name: {
                type: "string",
                description: "The exact name of the query to execute"
              },
              parameters: {
                type: "object",
                description: "Optional parameters for the query. Use vkd_get_query_info to see available parameters for a specific query.",
                additionalProperties: true
              }
            },
            required: ["query_name"]
          }
        }
      },
      {
        type: "function",
        function: {
          name: "vkd_get_filter_values",
          description: "Get available values for a specific filter parameter of a query. Useful for discovering valid parameter values.",
          parameters: {
            type: "object",
            properties: {
              query_name: {
                type: "string",
                description: "The name of the query"
              },
              filter_name: {
                type: "string", 
                description: "The name of the filter parameter to get values for"
              }
            },
            required: ["query_name", "filter_name"]
          }
        }
      }
    ];

    return [...staticFunctions, ...universalFunctions];
  }

  /**
   * Execute function (handles both static and universal functions)
   */
  async executeFunction(functionName: string, parameters: Record<string, any>): Promise<any> {
    // Handle universal functions
    switch (functionName) {
      case "vkd_list_queries":
        return await this.handleListQueries(parameters);
      
      case "vkd_get_query_info":
        return await this.handleGetQueryInfo(parameters);
      
      case "vkd_execute_query":
        return await this.handleExecuteQuery(parameters);
      
      case "vkd_get_filter_values":
        return await this.handleGetFilterValues(parameters);
      
      default:
        // Fall back to existing static functions
        return await super.executeFunction(functionName, parameters);
    }
  }

  /**
   * Handle vkd_list_queries function
   */
  private async handleListQueries(parameters: Record<string, any>): Promise<QueryInfo[]> {
    const allQueries = await this.queryService.getAllQueries();
    
    // Apply filters
    let filteredQueries = allQueries;
    
    if (parameters.category) {
      filteredQueries = filteredQueries.filter(q => q.category === parameters.category);
    }
    
    if (parameters.has_filters !== undefined) {
      filteredQueries = filteredQueries.filter(q => q.has_filters === parameters.has_filters);
    }
    
    if (parameters.search) {
      const searchTerm = parameters.search.toLowerCase();
      filteredQueries = filteredQueries.filter(q => 
        q.name.toLowerCase().includes(searchTerm) ||
        q.title?.toLowerCase().includes(searchTerm) ||
        q.description.toLowerCase().includes(searchTerm)
      );
    }
    
    if (parameters.chart_type) {
      filteredQueries = filteredQueries.filter(q => q.chart_type === parameters.chart_type);
    }
    
    return filteredQueries;
  }

  /**
   * Handle vkd_get_query_info function
   */
  private async handleGetQueryInfo(parameters: Record<string, any>): Promise<DetailedQueryInfo | null> {
    const queryName = parameters.query_name;
    if (!queryName) {
      throw new Error("query_name parameter is required");
    }
    
    const queryInfo = await this.queryService.getDetailedQueryInfo(queryName);
    if (!queryInfo) {
      throw new Error(`Query "${queryName}" not found`);
    }
    
    return queryInfo;
  }

  /**
   * Handle vkd_execute_query function
   */
  private async handleExecuteQuery(parameters: Record<string, any>): Promise<any> {
    const queryName = parameters.query_name;
    if (!queryName) {
      throw new Error("query_name parameter is required");
    }
    
    const queryParameters = parameters.parameters || {};
    
    try {
      return await this.queryService.executeQuery(queryName, queryParameters);
    } catch (error) {
      throw new Error(`Failed to execute query "${queryName}": ${(error as Error).message}`);
    }
  }

  /**
   * Handle vkd_get_filter_values function
   */
  private async handleGetFilterValues(parameters: Record<string, any>): Promise<string[]> {
    const queryName = parameters.query_name;
    const filterName = parameters.filter_name;
    
    if (!queryName) {
      throw new Error("query_name parameter is required");
    }
    
    if (!filterName) {
      throw new Error("filter_name parameter is required");
    }
    
    try {
      return await this.queryService.getFilterValues(queryName, filterName);
    } catch (error) {
      throw new Error(`Failed to get filter values for "${queryName}.${filterName}": ${(error as Error).message}`);
    }
  }

  /**
   * Process MCP request (extends base functionality)
   */
  async processRequest(action: string, params: Record<string, any>): Promise<any> {
    // Handle new universal actions
    switch (action) {
      case "vkd_list_queries":
        return await this.handleListQueries(params);
      
      case "vkd_get_query_info":
        return await this.handleGetQueryInfo(params);
      
      case "vkd_execute_query":
        return await this.handleExecuteQuery(params);
      
      case "vkd_get_filter_values":
        return await this.handleGetFilterValues(params);
      
      default:
        // Fall back to base implementation
        return await super.processRequest(action, params);
    }
  }
}

/**
 * Enhanced Lambda handler that uses UniversalMCPServer
 */
export const universalHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  // Set standard JSON headers
  const headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
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
    // Parse the request body
    const body = JSON.parse(event.body || "{}");
    
    // Support both formats for backward compatibility
    let action: string;
    let params: Record<string, any> = {};

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
            headers,
            body: JSON.stringify({ error: `Invalid tool_name: ${tool_name}` }),
          };
        }
      }
    } else {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ error: "Invalid request format. Expected 'action' or 'tool_name' field" }),
      };
    }

    // Get the assistant info
    const envName = process.env.VKD_ENVIRONMENT || "qa";
    const { assistant } = await getAssistantInfo(envName);

    // Create the enhanced MCP server
    const mcpServer = new UniversalMCPServer(assistant);

    // Process the request
    const result = await mcpServer.processRequest(action, params);

    // Return the result as standard JSON
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({ result }),
    };
  } catch (error) {
    console.error("Error processing MCP request:", error);
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: (error as Error).message }),
    };
  }
};