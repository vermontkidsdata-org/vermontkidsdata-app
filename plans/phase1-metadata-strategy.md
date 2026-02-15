# Phase 1 Implementation: Metadata Strategy for Universal MCP Functions

## Metadata Analysis Results

**Available Metadata Coverage:**
- **277/416 (67%)** have titles in metadata
- **167/416 (40%)** have chart types in names (format: `name:charttype`)
- **50/416 (12%)** have filter definitions
- **Query names** often contain semantic information

## Recommended Approach: Hybrid Metadata Strategy

### What We Should Extract (Server-Side)
✅ **Structured Data We Can Parse Reliably:**
- Title from `metadata.title` (67% coverage)
- Chart type from name pattern `query_name:chart_type` 
- Filter schema from `filters` JSON (12% coverage)
- Basic categorization from name patterns

### What AI Clients Should Infer (Client-Side)
🤖 **Semantic Understanding Best Left to AI:**
- Query purpose from name when title is missing
- Parameter meanings when filter metadata is sparse
- Data relationships and context
- User intent matching

## Implementation Strategy

### 1. Enhanced Query Metadata Extraction

```typescript
interface QueryInfo {
  name: string;
  title?: string;           // From metadata.title
  description?: string;     // Generated from name patterns + title
  chart_type?: string;      // Extracted from name (e.g., "bar", "line")
  category?: string;        // Inferred from name patterns
  has_filters: boolean;     // Whether filters exist
  filter_schema?: object;   // Full filter definition if available
  tags?: string[];          // Generated from name analysis
}

function extractQueryMetadata(queryRow: QueryRow): QueryInfo {
  const name = queryRow.name;
  const metadata = queryRow.metadata ? JSON.parse(queryRow.metadata) : {};
  
  return {
    name,
    title: metadata.title,
    description: generateDescription(name, metadata.title),
    chart_type: extractChartType(name),
    category: inferCategory(name),
    has_filters: !!queryRow.filters,
    filter_schema: queryRow.filters ? JSON.parse(queryRow.filters) : undefined,
    tags: generateTags(name)
  };
}
```

### 2. Smart Description Generation

```typescript
function generateDescription(name: string, title?: string): string {
  if (title) {
    return title;
  }
  
  // Parse name patterns for semantic meaning
  const patterns = {
    'act76_': 'Act 76 (Child Care Financial Assistance Program) data',
    'child_': 'Child-related statistics',
    'family_': 'Family-related statistics', 
    'poverty_': 'Poverty-related data',
    '_ccfap': 'related to Child Care Financial Assistance Program',
    ':bar': 'as bar chart data',
    ':line': 'as time series data',
    ':column': 'as column chart data'
  };
  
  let description = `Data query: ${name}`;
  
  // Apply pattern matching to enhance description
  for (const [pattern, meaning] of Object.entries(patterns)) {
    if (name.includes(pattern)) {
      description += ` (${meaning})`;
    }
  }
  
  return description;
}
```

### 3. Category Inference

```typescript
function inferCategory(name: string): string {
  const categories = {
    'act76_': 'Child Care Assistance',
    'child_': 'Child Welfare',
    'family_': 'Family Services',
    'poverty_': 'Economic Indicators',
    'health_': 'Health Statistics',
    'education_': 'Education Data',
    'housing_': 'Housing Data'
  };
  
  for (const [pattern, category] of Object.entries(categories)) {
    if (name.startsWith(pattern)) {
      return category;
    }
  }
  
  return 'General Statistics';
}
```

### 4. Core MCP Functions with Rich Metadata

```typescript
// Function 1: List queries with enhanced metadata
async function vkd_list_queries(params?: {
  category?: string,
  has_filters?: boolean,
  search?: string,
  chart_type?: string
}): Promise<QueryInfo[]> {
  const queries = await getAllQueries();
  
  return queries
    .map(extractQueryMetadata)
    .filter(query => {
      if (params?.category && query.category !== params.category) return false;
      if (params?.has_filters !== undefined && query.has_filters !== params.has_filters) return false;
      if (params?.chart_type && query.chart_type !== params.chart_type) return false;
      if (params?.search && !query.name.includes(params.search) && !query.title?.includes(params.search)) return false;
      return true;
    });
}

// Function 2: Get detailed query info
async function vkd_get_query_info(query_name: string): Promise<DetailedQueryInfo> {
  const queryRow = await getQueryRow(query_name);
  const basicInfo = extractQueryMetadata(queryRow);
  
  return {
    ...basicInfo,
    sql_preview: queryRow.sqlText.substring(0, 200) + '...',
    parameter_schema: generateParameterSchema(queryRow.filters),
    sample_parameters: generateSampleParameters(queryRow.filters),
    estimated_result_format: inferResultFormat(queryRow.sqlText)
  };
}
```

### 5. AI-Friendly Response Format

```typescript
interface AIFriendlyQueryInfo {
  // Structured data for reliable parsing
  name: string;
  title?: string;
  category: string;
  chart_type?: string;
  has_filters: boolean;
  
  // Rich context for AI interpretation
  description: string;
  tags: string[];
  name_components: {
    dataset?: string;    // e.g., "act76", "child"
    metric?: string;     // e.g., "age", "race", "total"
    geography?: string;  // e.g., "county", "ahsd"
    chart_type?: string; // e.g., "bar", "line"
  };
  
  // Let AI infer these when missing
  inferred_purpose?: string;  // Only if we're confident
  suggested_use_cases?: string[];  // Only for well-known patterns
}
```

## Recommended Implementation Priority

### Phase 1A: Basic Extraction (Week 1)
- Extract titles, chart types, basic categories
- Implement core 4 MCP functions
- Basic name pattern analysis

### Phase 1B: Enhanced Metadata (Week 2)  
- Smart description generation
- Tag generation from name patterns
- Parameter schema extraction for filtered queries

### Phase 1C: AI Optimization (Week 3)
- Optimize response format for AI consumption
- Add context hints without over-interpreting
- Test with AI clients for usability

## Key Principle: Complement AI, Don't Compete

**Server Should Provide:**
- ✅ Structured, reliable data extraction
- ✅ Schema definitions and parameter types
- ✅ Basic categorization from clear patterns
- ✅ Available filter values

**AI Client Should Handle:**
- 🤖 Semantic interpretation of query purposes
- 🤖 Understanding user intent and matching to queries
- 🤖 Inferring meaning from sparse metadata
- 🤖 Contextual recommendations

This approach gives AI clients rich, structured data to work with while avoiding over-interpretation that might be wrong or limiting.