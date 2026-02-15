
/**
 * Lambda handler for MCP requests
 * @param event API Gateway event
 * @returns API Gateway response
 */
// Import and use the SSE-enabled handler
export { handler } from "./sse-mcp-server";

// Export the universal handler for deployment