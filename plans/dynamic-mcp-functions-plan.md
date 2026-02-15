# Dynamic MCP Functions from Queries Table - Implementation Plan

## Overview

Currently, the MCP server exposes 5 hardcoded functions. The goal is to dynamically expose all 416 queries from the `queries` table as MCP functions, with parameters automatically generated from their filter definitions.

## Current State Analysis

### Database Structure
- **Total queries**: 416
- **Queries with filters**: 50 (12%)
- **Queries without filters**: 366 (88%)

### Query Table Schema
```sql
- id: int (PK)
- name: varchar(45) (unique) - Function identifier
- sqlText: varchar(4096) - SQL query with @variable placeholders
- columnMap: varchar(500) - Column mapping (optional)
- metadata: json - Chart metadata including filter definitions
- uploadType: varchar(128) - Upload type reference
- filters: varchar(4096) - Filter configuration JSON
```

### Filter Structure Analysis
Filters are defined in two places:
1. **`filters` column**: JSON defining filter logic and data sources
2. **`metadata.filters` column**: UI filter definitions

Example filter structure:
```json
{
  "table": "data_act76_child_race",
  "filters": {
    "race_filter": {"column": "race", "exclude": ["total"]},
    "county_filter": {"column": "geography"},
    "month_filter": {"column": "month", "sort": "number"},
    "year_filter": {"column": "year", "sort": "number"}
  },
  "extra_filter_values": {
    "stars_filter": ["4 or 5 Star"]
  }
}
```

### Current Query Execution Pipeline
1. Query lookup by name from `queries` table
2. Variable substitution using MySQL `SET @variable = 'value'`
3. SQL execution with parameterized queries
4. Result transformation to standard format (cat, label, value)

## Implementation Plan

### Phase 1: Dynamic Function Discovery

#### 1.1 Query Metadata Service
Create a service to dynamically load and cache query definitions:

```typescript
interface DynamicQueryFunction {
  name: string;
  description: string;
  parameters: {
    type: "object";
    properties: Record<string, ParameterSchema>;
    required: string[];
  };
  sqlText: string;
  filters?: QueryFilters;
  metadata?: QueryMetadata;
}

class QueryFunctionService {
  async getAllFunctions(): Promise<DynamicQueryFunction[]>
  async getFunction(name: string): Promise<DynamicQueryFunction | null>
  async getFilterValues(queryName: string, filterKey: string): Promise<string[]>
}
```

#### 1.2 Parameter Schema Generation
Transform filter definitions into MCP parameter schemas:

```typescript
interface ParameterSchema {
  type: "string" | "number" | "boolean";
  description: string;
  enum?: string[];
  default?: string;
}

function generateParameterSchema(filters: QueryFilters): Record<string, ParameterSchema> {
  // Convert filter definitions to MCP parameter schemas
  // Handle different filter types: column-based, extra values, sorting
}
```

### Phase 2: Dynamic Function Execution

#### 2.1 Enhanced MCP Server
Extend the existing MCP server to handle dynamic functions:

```typescript
class DynamicMCPServer extends MCPServer {
  private queryService: QueryFunctionService;
  
  async listFunctions(): Promise<VKDFunctionTool[]> {
    // Return both hardcoded functions AND dynamic query functions
    const staticFunctions = await super.listFunctions();
    const dynamicFunctions = await this.queryService.getAllFunctions();
    return [...staticFunctions, ...this.convertToDynamicTools(dynamicFunctions)];
  }
  
  async executeFunction(functionName: string, parameters: Record<string, any>): Promise<any> {
    // Check if it's a dynamic query function
    if (await this.queryService.getFunction(functionName)) {
      return await this.executeDynamicQuery(functionName, parameters);
    }
    // Fall back to existing hardcoded functions
    return await super.executeFunction(functionName, parameters);
  }
}
```

#### 2.2 Dynamic Query Execution Pipeline
Reuse existing chartsApi logic for query execution:

```typescript
async executeDynamicQuery(queryName: string, parameters: Record<string, any>): Promise<any> {
  // 1. Load query definition
  const queryFunction = await this.queryService.getFunction(queryName);
  
  // 2. Validate parameters against schema
  this.validateDynamicParameters(queryFunction, parameters);
  
  // 3. Transform external values to internal format
  const variables = this.transformParameters(queryFunction, parameters);
  
  // 4. Execute query using existing getDefaultDataset logic
  const result = await getDefaultDataset(queryFunction, variables);
  
  // 5. Return standardized result format
  return {
    value: this.extractPrimaryValue(result),
    url: this.generateChartUrl(queryName, parameters),
    data: result
  };
}
```

### Phase 3: Parameter Value Discovery

#### 3.1 Filter Value API
Extend the existing filter API to support dynamic queries:

```typescript
async getFilterValues(queryName: string, filterKey: string): Promise<string[]> {
  // Reuse existing lambdaHandlerGetFilter logic
  // Support both static and dynamic queries
}
```

#### 3.2 Enhanced Inspector
Update the MCP inspector to handle dynamic parameter discovery:

```typescript
// In mcp-inspector.ts
async collectDynamicParameters(func: DynamicQueryFunction): Promise<Record<string, any>> {
  for (const [paramName, paramDef] of Object.entries(func.parameters.properties)) {
    if (paramDef.enum) {
      // Use predefined enum values
    } else {
      // Fetch available values from filter API
      const availableValues = await this.fetchFilterValues(func.name, paramName);
      // Present as options to user
    }
  }
}
```

### Phase 4: Integration Strategy

#### 4.1 Backward Compatibility
- Keep existing hardcoded functions working
- Gradually migrate to dynamic system
- Support both approaches during transition

#### 4.2 Performance Considerations
- **Caching**: Cache query definitions and filter values
- **Lazy Loading**: Load filter values on demand
- **Connection Pooling**: Reuse database connections

#### 4.3 Error Handling
- **Query Validation**: Validate SQL syntax and parameters
- **Parameter Validation**: Type checking and enum validation
- **Graceful Degradation**: Fall back to basic execution if filters fail

## Implementation Steps

### Step 1: Core Infrastructure
1. Create `QueryFunctionService` class
2. Implement parameter schema generation
3. Add dynamic function discovery to MCP server
4. Create unit tests for core functionality

### Step 2: Query Execution
1. Implement dynamic query execution pipeline
2. Add parameter validation and transformation
3. Integrate with existing chartsApi logic
4. Test with sample queries

### Step 3: Filter Integration
1. Extend filter API for dynamic queries
2. Update MCP inspector for dynamic parameters
3. Add filter value caching
4. Test with filtered queries

### Step 4: Production Deployment
1. Add comprehensive error handling
2. Implement performance optimizations
3. Add monitoring and logging
4. Deploy and test in QA environment

## Technical Considerations

### Database Performance
- **Query Optimization**: Ensure filter queries are efficient
- **Index Strategy**: Add indexes for commonly filtered columns
- **Connection Management**: Pool database connections

### Memory Management
- **Function Caching**: Cache function definitions in memory
- **Filter Caching**: Cache filter values with TTL
- **Memory Limits**: Monitor memory usage with 416 functions

### Security
- **SQL Injection**: Use parameterized queries only
- **Parameter Validation**: Strict validation of all inputs
- **Access Control**: Consider function-level permissions

### Monitoring
- **Function Usage**: Track which functions are called
- **Performance Metrics**: Monitor query execution times
- **Error Tracking**: Log and alert on failures

## Expected Outcomes

### Immediate Benefits
- **416 functions available** instead of 5
- **Automatic parameter discovery** from filter definitions
- **Consistent API interface** for all queries

### Long-term Benefits
- **Self-maintaining**: New queries automatically become functions
- **Reduced Development Overhead**: No manual function creation
- **Better Data Exploration**: Easy access to all data through MCP

### Migration Path
1. **Phase 1**: Deploy alongside existing functions
2. **Phase 2**: Migrate clients to use dynamic functions
3. **Phase 3**: Deprecate hardcoded functions
4. **Phase 4**: Remove legacy code

## Risk Mitigation

### Technical Risks
- **Performance Impact**: Mitigate with caching and optimization
- **Memory Usage**: Monitor and implement limits
- **Database Load**: Use connection pooling and query optimization

### Operational Risks
- **Breaking Changes**: Maintain backward compatibility
- **Data Quality**: Validate query results
- **Monitoring**: Comprehensive logging and alerting

## Success Metrics

- **Function Coverage**: 416/416 queries exposed as functions
- **Response Time**: < 2s for function execution
- **Error Rate**: < 1% for valid requests
- **Memory Usage**: < 512MB for function definitions
- **User Adoption**: Successful migration of existing clients