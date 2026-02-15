# MCP Inspector and Testing Tools

This directory contains tools for testing and exploring the Vermont Kids Data MCP (Model Context Protocol) server.

## Available Tools

### 1. Interactive MCP Inspector (`mcp-inspector.ts`)

An interactive command-line tool that lets you explore and test MCP functions dynamically. It follows the MCP HTTP protocol and provides a user-friendly interface for:

- Listing all available functions with descriptions and parameters
- Selecting functions interactively
- Prompting for required parameters with validation
- Executing functions and displaying results

**Usage:**
```bash
# For QA environment
npx ts-node scripts/mcp-inspector.ts --env qa

# For Production environment
npx ts-node scripts/mcp-inspector.ts --env prod
```

**Features:**
- 🔍 Automatic function discovery
- 📋 Parameter validation and type conversion
- 🎯 Interactive function selection
- ✅ Real-time execution and results
- 🔗 Direct links to chart visualizations

### 2. Simple MCP Tester (`mcp-test-simple.ts`)

A non-interactive testing tool that runs automated tests against the MCP server to verify basic functionality.

**Usage:**
```bash
# Test QA environment
npx ts-node scripts/mcp-test-simple.ts --env qa

# Test Production environment
npx ts-node scripts/mcp-test-simple.ts --env prod
```

**What it tests:**
- ✅ `list_functions` endpoint
- ✅ `execute_function` endpoint with sample parameters
- ✅ Response format validation

### 3. Original Test Script (`test-mcp-server.ts`)

The original command-line tool for testing specific functions when you know the function name and parameters ahead of time.

**Usage:**
```bash
# List functions
npx ts-node scripts/test-mcp-server.ts --env qa --tool list_functions

# Execute specific function
npx ts-node scripts/test-mcp-server.ts --env qa --tool execute_function --params '{"functionName":"avgbenefit_3squares_vt-chart","parameters":{"group":"individual","year":"2020"}}'
```

## MCP Server Endpoints

### QA Environment
- **Base URL**: `https://api.qa.vtkidsdata.org`
- **MCP Endpoint**: `https://api.qa.vtkidsdata.org/ai/mcp`

### Production Environment
- **Base URL**: `https://api.vtkidsdata.org`
- **MCP Endpoint**: `https://api.vtkidsdata.org/ai/mcp`

## Request Format

The MCP server accepts requests in the following format:

```json
{
  "action": "list_functions" | "execute_function",
  "params": {
    // Parameters specific to the action
  }
}
```

### List Functions
```json
{
  "action": "list_functions",
  "params": {}
}
```

### Execute Function
```json
{
  "action": "execute_function",
  "params": {
    "functionName": "function-name",
    "parameters": {
      "param1": "value1",
      "param2": "value2"
    }
  }
}
```

## Response Format

All responses follow this structure:

```json
{
  "result": {
    // Response data specific to the action
  }
}
```

### Function Execution Response
```json
{
  "result": {
    "value": "131",
    "url": "https://ui.qa.vtkidsdata.org/columnchart/avgbenefit_3squares_vt:chart"
  }
}
```

## Available Functions

The MCP server currently exposes these Vermont Kids Data functions:

1. **`children_in_poverty_under_12_all-chart`** - Children in poverty statistics
2. **`avgbenefit_3squares_vt-chart`** - Average 3 Squares VT benefits
3. **`iep-chart`** - Students with Individualized Education Programs
4. **`get_idea_by_year`** - IDEA early intervention services
5. **`get_babies_count`** - Birth statistics

Each function has specific parameters and requirements. Use the interactive inspector to explore them dynamically.

## Troubleshooting

### Common Issues

1. **Connection Errors**: Verify the environment (qa/prod) and network connectivity
2. **Parameter Validation**: Use the interactive inspector to see required parameters
3. **Function Not Found**: Use `list_functions` to see available functions

### Testing Workflow

1. Start with the simple tester to verify basic connectivity:
   ```bash
   npx ts-node scripts/mcp-test-simple.ts --env qa
   ```

2. Use the interactive inspector to explore functions:
   ```bash
   npx ts-node scripts/mcp-inspector.ts --env qa
   ```

3. Use the original test script for automated/scripted testing:
   ```bash
   npx ts-node scripts/test-mcp-server.ts --env qa --tool list_functions
   ```

## Direct API Testing

You can also test the MCP server directly using curl:

```bash
# List functions
curl -X POST https://api.qa.vtkidsdata.org/ai/mcp \
  -H "Content-Type: application/json" \
  -d '{"action": "list_functions", "params": {}}'

# Execute function
curl -X POST https://api.qa.vtkidsdata.org/ai/mcp \
  -H "Content-Type: application/json" \
  -d '{"action": "execute_function", "params": {"functionName": "avgbenefit_3squares_vt-chart", "parameters": {"group": "individual", "year": "2020"}}}'