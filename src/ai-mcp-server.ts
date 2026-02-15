import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { ToolCallHandler } from "./ai-utils";
import { LimitedAssistantDef, VKDFunctionTool } from "./assistant-def";
import { getAssistantInfo } from "./assistant-def";

/**
 * MCP Server that fronts ToolCallHandler.handleToolCall
 * Exposes two MCP tools:
 * 1. list_functions - Returns a list of available function definitions
 * 2. execute_function - Executes a specific function by name with parameters
 */
export class MCPServer {
  private toolCallHandler: ToolCallHandler;
  private assistant: LimitedAssistantDef;

  constructor(assistant: LimitedAssistantDef) {
    this.toolCallHandler = new ToolCallHandler();
    this.assistant = assistant;
  }

  /**
   * Lists all available function definitions
   * @returns Array of function definitions with descriptions and parameter schemas
   */
  async listFunctions(): Promise<VKDFunctionTool[]> {
    // Filter tools to only include function tools
    return this.assistant.tools.filter(
      (tool): tool is VKDFunctionTool => tool.type === "function"
    );
  }

  /**
   * Executes a specific function by name with parameters
   * @param functionName Name of the function to execute
   * @param parameters Parameters to pass to the function
   * @returns Result of the function execution
   */
  async executeFunction(functionName: string, parameters: Record<string, any>): Promise<any> {
    // Find the function definition
    const functionDef = this.assistant.tools.find(
      (tool) => tool.type === "function" && tool.function.name === functionName
    ) as VKDFunctionTool | undefined;

    if (!functionDef) {
      throw new Error(`Function "${functionName}" not found`);
    }

    // Validate parameters against function definition
    // this.validateParameters(functionDef, parameters);

    // Create a mock tool call object
    const toolCall = {
      id: `call_${Date.now()}`,
      type: "function" as const,
      function: {
        name: functionName,
        arguments: JSON.stringify(parameters),
      },
    };

    // Execute the function using ToolCallHandler
    const result = await this.toolCallHandler.handleToolCall({
      toolCall,
      assistant: this.assistant,
    });

    if (!result) {
      throw new Error(`Function "${functionName}" execution failed`);
    }

    // Parse the output JSON
    return JSON.parse(result.output);
  }

  /**
   * Validates parameters against function definition
   * @param functionDef Function definition
   * @param parameters Parameters to validate
   * @throws Error if validation fails
   */
  private validateParameters(functionDef: VKDFunctionTool, parameters: Record<string, any>): void {
    // Use type assertion to help TypeScript understand the structure
    const properties = (functionDef.function.parameters?.properties || {}) as Record<string, any>;
    const required = functionDef.function.parameters?.required || [];

    if (Object.keys(properties).length === 0) {
      return; // No parameters defined, nothing to validate
    }

    // Check for missing required parameters that are defined in properties
    if (Array.isArray(required)) {
      for (const requiredParam of required) {
        // Only validate required parameters that are actually defined in properties
        if (properties[requiredParam] && parameters[requiredParam] === undefined) {
          throw new Error(`Missing required parameter: ${requiredParam}`);
        }
      }
    }

    // Validate parameter types for provided parameters
    for (const [paramName, paramValue] of Object.entries(parameters)) {
      const paramDef = properties[paramName];
      // Skip validation for parameters not defined in properties
      if (!paramDef) {
        console.log(`Warning: Parameter ${paramName} is not defined in function definition`);
        continue;
      }

      // Type validation
      switch (paramDef.type) {
        case "string":
          if (typeof paramValue !== "string") {
            throw new Error(`Parameter ${paramName} must be a string`);
          }
          // Check enum if defined
          if (paramDef.enum && !paramDef.enum.includes(paramValue)) {
            throw new Error(`Parameter ${paramName} must be one of: ${paramDef.enum.join(", ")}`);
          }
          break;
        case "number":
          if (typeof paramValue !== "number") {
            throw new Error(`Parameter ${paramName} must be a number`);
          }
          break;
        case "boolean":
          if (typeof paramValue !== "boolean") {
            throw new Error(`Parameter ${paramName} must be a boolean`);
          }
          break;
        case "object":
          if (typeof paramValue !== "object" || paramValue === null || Array.isArray(paramValue)) {
            throw new Error(`Parameter ${paramName} must be an object`);
          }
          break;
        case "array":
          if (!Array.isArray(paramValue)) {
            throw new Error(`Parameter ${paramName} must be an array`);
          }
          break;
      }
    }
  }

  /**
   * Processes an MCP request
   * @param action The MCP action to perform (list_functions or execute_function)
   * @param params Parameters for the action
   * @returns Result of the action
   */
  async processRequest(action: string, params: Record<string, any>): Promise<any> {
    switch (action) {
      case "list_functions":
        return await this.listFunctions();
      
      case "execute_function":
        const { functionName, parameters } = params;
        if (!functionName) {
          throw new Error("Function name is required");
        }
        return await this.executeFunction(functionName, parameters || {});
      
      default:
        throw new Error(`Unknown action: ${action}`);
    }
  }
}

/**
 * Lambda handler for MCP requests
 * @param event API Gateway event
 * @returns API Gateway response
 */
export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
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
      const { server_name, tool_name, arguments: toolArguments } = body;
      
      if (tool_name === 'list_functions') {
        action = 'list_functions';
      } else if (tool_name === 'execute_function') {
        action = 'execute_function';
        params = {
          functionName: toolArguments?.functionName,
          parameters: toolArguments?.parameters || {},
        };
      } else {
        return {
          statusCode: 400,
          headers,
          body: JSON.stringify({ error: "Invalid tool_name. Expected 'list_functions' or 'execute_function'" }),
        };
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

    // Create the MCP server
    const mcpServer = new MCPServer(assistant);

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