import { doDBOpen, doDBClose, doDBQuery } from "./db-utils";
import { getDefaultDataset, QueryRow, QueryFilters } from "./chartsApi";
import { getUploadType, transformValueIntToExt } from "./uploadData";

/**
 * Enhanced query metadata for MCP functions
 */
export interface QueryInfo {
  name: string;
  title?: string;
  description: string;
  category: string;
  chart_type?: string;
  has_filters: boolean;
  filter_schema?: QueryFilters;
  tags: string[];
  name_components: {
    dataset?: string;
    metric?: string;
    geography?: string;
    chart_type?: string;
  };
}

/**
 * Detailed query information including parameter schemas
 */
export interface DetailedQueryInfo extends QueryInfo {
  sql_preview: string;
  parameter_schema?: Record<string, ParameterSchema>;
  sample_parameters?: Record<string, any>;
  estimated_result_format: string;
}

/**
 * MCP parameter schema
 */
export interface ParameterSchema {
  type: "string" | "number" | "boolean";
  description: string;
  enum?: string[];
  default?: string;
}

/**
 * Service for managing dynamic query functions
 */
export class QueryFunctionService {
  private queryCache: Map<string, QueryInfo> = new Map();
  private allQueriesCache: QueryInfo[] | null = null;
  private cacheTimestamp: number = 0;
  private readonly CACHE_TTL = 5 * 60 * 1000; // 5 minutes

  /**
   * Get all available queries with metadata
   */
  async getAllQueries(): Promise<QueryInfo[]> {
    if (this.allQueriesCache && Date.now() - this.cacheTimestamp < this.CACHE_TTL) {
      return this.allQueriesCache;
    }

    await doDBOpen();
    try {
      const queryRows = await doDBQuery(
        'SELECT name, sqlText, metadata, filters FROM queries WHERE name NOT LIKE "%unsuppressed%" ORDER BY name'
      );

      this.allQueriesCache = queryRows.map((row: QueryRow) => this.extractQueryMetadata(row));
      this.cacheTimestamp = Date.now();

      // Update individual cache entries
      this.allQueriesCache.forEach(query => {
        this.queryCache.set(query.name, query);
      });

      return this.allQueriesCache;
    } finally {
      await doDBClose();
    }
  }

  /**
   * Get specific query information
   */
  async getQuery(queryName: string): Promise<QueryInfo | null> {
    // Block access to unsuppressed queries
    if (queryName.includes('unsuppressed')) {
      return null;
    }

    // Check cache first
    if (this.queryCache.has(queryName)) {
      return this.queryCache.get(queryName)!;
    }

    await doDBOpen();
    try {
      const queryRows = await doDBQuery(
        'SELECT name, sqlText, metadata, filters FROM queries WHERE name = ? AND name NOT LIKE "%unsuppressed%"',
        [queryName]
      );

      if (queryRows.length === 0) {
        return null;
      }

      const queryInfo = this.extractQueryMetadata(queryRows[0]);
      this.queryCache.set(queryName, queryInfo);
      return queryInfo;
    } finally {
      await doDBClose();
    }
  }

  /**
   * Get detailed query information including parameter schemas
   */
  async getDetailedQueryInfo(queryName: string): Promise<DetailedQueryInfo | null> {
    // Block access to unsuppressed queries
    if (queryName.includes('unsuppressed')) {
      return null;
    }

    await doDBOpen();
    try {
      const queryRows = await doDBQuery(
        'SELECT name, sqlText, metadata, filters, uploadType FROM queries WHERE name = ? AND name NOT LIKE "%unsuppressed%"',
        [queryName]
      );

      if (queryRows.length === 0) {
        return null;
      }

      const queryRow = queryRows[0];
      const basicInfo = this.extractQueryMetadata(queryRow);
      
      return {
        ...basicInfo,
        sql_preview: this.createSqlPreview(queryRow.sqlText),
        parameter_schema: await this.generateParameterSchema(queryRow.filters),
        sample_parameters: this.generateSampleParameters(queryRow.filters),
        estimated_result_format: this.inferResultFormat(queryRow.sqlText)
      };
    } finally {
      await doDBClose();
    }
  }

  /**
   * Execute a query with parameters
   */
  async executeQuery(queryName: string, parameters: Record<string, any> = {}): Promise<any> {
    // Block access to unsuppressed queries
    if (queryName.includes('unsuppressed')) {
      throw new Error(`Query "${queryName}" is not accessible`);
    }

    await doDBOpen();
    try {
      const queryRows = await doDBQuery(
        'SELECT name, sqlText, metadata, filters, uploadType FROM queries WHERE name = ? AND name NOT LIKE "%unsuppressed%"',
        [queryName]
      );

      if (queryRows.length === 0) {
        throw new Error(`Query "${queryName}" not found`);
      }

      const queryRow = queryRows[0];
      
      // Validate parameters if filters exist
      if (queryRow.filters) {
        await this.validateParameters(queryRow, parameters);
      }

      // Execute using existing chartsApi logic
      const result = await getDefaultDataset(queryRow, parameters);
      
      return {
        value: this.extractPrimaryValue(result),
        url: this.generateChartUrl(queryName, parameters),
        data: result,
        query_name: queryName,
        parameters_used: parameters
      };
    } finally {
      await doDBClose();
    }
  }

  /**
   * Get available filter values for a specific query and filter
   */
  async getFilterValues(queryName: string, filterKey: string): Promise<string[]> {
    // Block access to unsuppressed queries
    if (queryName.includes('unsuppressed')) {
      return [];
    }

    await doDBOpen();
    try {
      const queryRows = await doDBQuery(
        'SELECT filters, uploadType FROM queries WHERE name = ? AND name NOT LIKE "%unsuppressed%"',
        [queryName]
      );

      if (queryRows.length === 0 || !queryRows[0].filters) {
        return [];
      }

      const filters = JSON.parse(queryRows[0].filters) as QueryFilters;
      const filterSpec = filters.filters[filterKey];
      
      if (!filterSpec) {
        return [];
      }

      const table = filters.table;
      const columnName = filterSpec.column;
      
      const resultRows = await doDBQuery(
        `SELECT DISTINCT \`${columnName}\` as value FROM ${table} ORDER BY value`
      );

      const uploadType = queryRows[0].uploadType ? await getUploadType(queryRows[0].uploadType) : undefined;
      
      let values = resultRows
        .map((row: { value: string }) => `${row.value}`)
        .filter((value: string) => {
          if (filterSpec.exclude && filterSpec.exclude.includes(value)) {
            return false;
          }
          return !value.includes("NaN");
        })
        .map((value: string) => {
          return transformValueIntToExt({
            columnName,
            value,
            uploadType,
            xf: filterSpec.xf
          });
        });

      // Remove duplicates
      values = Array.from(new Set(values));

      // Add extra filter values if defined
      if (filters.extra_filter_values?.[filterKey]) {
        values.push(...filters.extra_filter_values[filterKey]);
      }

      // Sort values
      values.sort((a, b) => {
        if (filterSpec.sort === 'number') {
          const aNum = parseFloat(a);
          const bNum = parseFloat(b);
          if (!isNaN(aNum) && !isNaN(bNum)) {
            return aNum - bNum;
          }
        }
        return a.localeCompare(b);
      });

      return values;
    } finally {
      await doDBClose();
    }
  }

  /**
   * Extract metadata from a query row
   */
  private extractQueryMetadata(queryRow: QueryRow): QueryInfo {
    const name = queryRow.name;
    const metadata = queryRow.metadata ? JSON.parse(queryRow.metadata) : {};
    const title = metadata.title;
    
    return {
      name,
      title,
      description: this.generateDescription(name, title),
      category: this.inferCategory(name),
      chart_type: this.extractChartType(name),
      has_filters: !!queryRow.filters,
      filter_schema: queryRow.filters ? JSON.parse(queryRow.filters) : undefined,
      tags: this.generateTags(name),
      name_components: this.parseNameComponents(name)
    };
  }

  /**
   * Generate a description from name and title
   */
  private generateDescription(name: string, title?: string): string {
    if (title) {
      return title;
    }

    // Parse name patterns for semantic meaning
    const patterns = {
      'act76_': 'Act 76 (Child Care Financial Assistance Program) data',
      'child_': 'Child-related statistics',
      'family_': 'Family-related statistics',
      'poverty_': 'Poverty-related data',
      'health_': 'Health-related statistics',
      'education_': 'Education data',
      '_ccfap': ' related to Child Care Financial Assistance Program',
      ':bar': ' as bar chart data',
      ':line': ' as time series data',
      ':column': ' as column chart data'
    };

    let description = `Data query: ${name}`;
    
    for (const [pattern, meaning] of Object.entries(patterns)) {
      if (name.includes(pattern)) {
        description += ` (${meaning})`;
      }
    }

    return description;
  }

  /**
   * Infer category from query name
   */
  private inferCategory(name: string): string {
    const categories = {
      'act76_': 'Child Care Assistance',
      'child_': 'Child Welfare',
      'family_': 'Family Services',
      'poverty_': 'Economic Indicators',
      'health_': 'Health Statistics',
      'education_': 'Education Data',
      'housing_': 'Housing Data',
      'ccfap': 'Child Care Assistance'
    };

    for (const [pattern, category] of Object.entries(categories)) {
      if (name.includes(pattern)) {
        return category;
      }
    }

    return 'General Statistics';
  }

  /**
   * Extract chart type from query name
   */
  private extractChartType(name: string): string | undefined {
    const match = name.match(/:([^:]+)$/);
    return match ? match[1] : undefined;
  }

  /**
   * Generate tags from query name
   */
  private generateTags(name: string): string[] {
    const tags: string[] = [];
    
    if (name.includes('act76')) tags.push('act76');
    if (name.includes('child')) tags.push('children');
    if (name.includes('family')) tags.push('families');
    if (name.includes('ccfap')) tags.push('childcare');
    if (name.includes('poverty')) tags.push('poverty');
    if (name.includes('health')) tags.push('health');
    if (name.includes('education')) tags.push('education');
    
    const chartType = this.extractChartType(name);
    if (chartType) tags.push(chartType);
    
    return tags;
  }

  /**
   * Parse name components
   */
  private parseNameComponents(name: string): QueryInfo['name_components'] {
    const parts = name.split(/[_:]/);
    
    return {
      dataset: parts[0] || undefined,
      metric: parts[1] || undefined,
      geography: parts.find(p => ['county', 'ahsd', 'district'].includes(p)) || undefined,
      chart_type: this.extractChartType(name)
    };
  }

  /**
   * Create SQL preview
   */
  private createSqlPreview(sqlText: string): string {
    return sqlText.substring(0, 200) + (sqlText.length > 200 ? '...' : '');
  }

  /**
   * Generate parameter schema from filters
   */
  private async generateParameterSchema(filtersJson?: string): Promise<Record<string, ParameterSchema> | undefined> {
    if (!filtersJson) {
      return undefined;
    }

    const filters = JSON.parse(filtersJson) as QueryFilters;
    const schema: Record<string, ParameterSchema> = {};

    for (const [key, spec] of Object.entries(filters.filters)) {
      schema[key] = {
        type: "string",
        description: `Filter by ${spec.column}`,
        default: spec.default
      };

      // Add enum values if we can determine them
      if (spec.column && filters.table) {
        try {
          // For now, we'll leave enum empty and let getFilterValues handle it
          // This avoids making extra DB calls during schema generation
        } catch (error) {
          // Ignore errors in schema generation
        }
      }
    }

    return schema;
  }

  /**
   * Generate sample parameters
   */
  private generateSampleParameters(filtersJson?: string): Record<string, any> | undefined {
    if (!filtersJson) {
      return undefined;
    }

    const filters = JSON.parse(filtersJson) as QueryFilters;
    const samples: Record<string, any> = {};

    for (const [key, spec] of Object.entries(filters.filters)) {
      if (spec.default) {
        samples[key] = spec.default;
      } else {
        samples[key] = "-- All --"; // Common default pattern
      }
    }

    return samples;
  }

  /**
   * Infer result format from SQL
   */
  private inferResultFormat(sqlText: string): string {
    if (sqlText.toLowerCase().includes('select') && 
        sqlText.toLowerCase().includes('cat') && 
        sqlText.toLowerCase().includes('label') && 
        sqlText.toLowerCase().includes('value')) {
      return "Standard chart format: {categories: string[], series: [{name: string, data: number[]}]}";
    }
    return "Query result format";
  }

  /**
   * Validate parameters against filter schema
   */
  private async validateParameters(queryRow: QueryRow, parameters: Record<string, any>): Promise<void> {
    if (!queryRow.filters) {
      return;
    }

    const filters = JSON.parse(queryRow.filters) as QueryFilters;
    
    for (const [key, spec] of Object.entries(filters.filters)) {
      const value = parameters[key];
      
      // Skip validation for optional parameters
      if (value === undefined || value === null) {
        continue;
      }

      // Basic type validation
      if (typeof value !== 'string' && typeof value !== 'number') {
        throw new Error(`Parameter ${key} must be a string or number`);
      }
    }
  }

  /**
   * Extract primary value from result data
   */
  private extractPrimaryValue(result: any): string | number {
    if (result && result.series && result.series.length > 0) {
      const firstSeries = result.series[0];
      if (firstSeries.data && firstSeries.data.length > 0) {
        return firstSeries.data[0];
      }
    }
    return "No data";
  }

  /**
   * Generate chart URL
   */
  private generateChartUrl(queryName: string, parameters: Record<string, any>): string {
    const baseUrl = process.env.VKD_ENVIRONMENT === 'qa' 
      ? 'https://ui.qa.vtkidsdata.org' 
      : 'https://ui.vtkidsdata.org';
    
    const chartType = this.extractChartType(queryName) || 'chart';
    const params = new URLSearchParams(parameters as Record<string, string>).toString();
    
    return `${baseUrl}/${chartType}/${queryName}${params ? '?' + params : ''}`;
  }

  /**
   * Clear cache (useful for testing)
   */
  clearCache(): void {
    this.queryCache.clear();
    this.allQueriesCache = null;
    this.cacheTimestamp = 0;
  }
}