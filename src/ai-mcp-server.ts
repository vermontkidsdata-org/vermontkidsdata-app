
/**
 * Lambda handler for MCP requests
 * @param event API Gateway event
 * @returns API Gateway response
 */
// Import and use the Cursor-compatible MCP handler
export { cursorMCPHandler as handler } from "./cursor-mcp-server";

// Export the universal handler for deployment