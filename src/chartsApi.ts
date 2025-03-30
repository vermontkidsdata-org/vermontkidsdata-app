import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { getResponse as getIndicatorsBySubcat } from './custom/indicators-by-subcat';
import { doDBClose, doDBOpen, doDBQuery } from "./db-utils";
import { makePowerTools } from './lambda-utils';
import { getUploadType, transformValueExtToInt, transformValueIntToExt } from './uploadData';
const { VKD_ENVIRONMENT } = process.env;

const pt = makePowerTools({ prefix: `charts-api-${VKD_ENVIRONMENT}` });

export interface QueryRow {
  id: number,
  name: string,
  sqlText: string,
  columnMap?: string,
  metadata?: string,
  uploadType?: string,
  filters?: string,
}

async function getQueryRow(queryId: string): Promise<QueryRow | undefined> {
  await doDBOpen();
  try {
    // Get the query to run from the parameters
    const queryRows = await doDBQuery('SELECT sqlText, metadata, uploadType, filters FROM queries where name=?', [queryId]);
    // console.log(queryRows);
    if (queryRows.length == 0) {
      return undefined;
    } else {
      return queryRows[0];
    }
  } finally {
    await doDBClose();
  }
}

export async function getDefaultDataset(queryRow: QueryRow, variables?: Record<string, string>): Promise<any> {
  const metadata = queryRow?.metadata ? JSON.parse(queryRow.metadata || '{}') : undefined;

  await doDBOpen();
  try {
    const uploadType = queryRow.uploadType;
    pt.logger.info({ message: 'getDefaultDataset: running query', variables });
    const sqlText = queryRow.sqlText;

    console.log(sqlText);

    // First set the variables. We'll set them to MySQL variables of the same name.
    if (variables && Object.keys(variables).length > 0) {
      for (const [key, value] of Object.entries(variables)) {
        await doDBQuery(`SET @${key} = '${value}'`);
      }
    }

    // Now run the query. Should always return three columns, with the following names
    // - cat: The category(s)
    // - label: The label for the values
    // - value: The value for the values
    const resultRows = await doDBQuery(sqlText);
    // console.log('result', resultRows);

    interface QueryResult {
      cat: string,
      label: string,
      value: string
    }
    const categories: string[] = [];
    const series: { [label: string]: { [key: string]: string } } = {};
    const hover: { [label: string]: { [key: string]: string } } = {};
    resultRows.forEach((row: QueryResult) => {
      const cat = row.cat;
      const label = row.label;
      const value = row.value;
      if (series[label] == null) {
        series[label] = {};   // Keyed by category
      }
      if (hover[label] == null) {
        hover[label] = {};   // Keyed by category
      }
      if (!categories.includes(cat)) {
        categories.push(cat);
      }
      series[label][cat] = value;
      hover[label][cat] = 'dummy-hover';
    });

    // console.log('categories', categories);
    // console.log('series', series);
    const retSeries: { 
      name: string, 
      data: (number | null)[],
      hover: (number | null)[],
     }[] = Object.keys(series).map(label => {
      // console.log('label', label);
      return {
        name: label,
        data: categories.map(cat => {
          const val = parseFloat(series[label][cat]);
          return (val < 0 ? null : val);
        }),
        hover: categories.map(cat => {
          const val = parseFloat(hover[label][cat]);
          return (val < 0 ? null : val);
        }),
      };
    });
    // console.log('retSeries', retSeries);
    return {
      id: queryRow.name,
      metadata: {
        config: metadata,
        uploadType,
      },
      series: retSeries,
      categories: categories,
    }
  } finally {
    await doDBClose();
  }
}

export interface BarChartSeriesItem {
  name: string,
  data: (number | null)[],
}

export type BarChartCategoryItem = string | number;

export interface BarChartResult {
  metadata: {
    config: any,
    uploadType: string,
  },
  series: BarChartSeriesItem[],
  categories: BarChartCategoryItem[],
}

class BadRequestError extends Error {
  statusCode: number;
  constructor(statusCode: number, message: string) {
    super(message);
    this.statusCode = statusCode;
  }
}

export async function getChartData(queryId: string, functionArgs: Record<string, string>): Promise<BarChartResult> {
  const queryRow = await getQueryRow(queryId);
  const metadata = queryRow?.metadata ? JSON.parse(queryRow.metadata || '{}') : undefined;
  if (queryRow == null) {
    throw new BadRequestError(400, 'unknown chart');
  }

  return await (async (queryRow, metadata) => {
    if (metadata.custom === "dashboard:indicators:chart") {
      return await getIndicatorsBySubcat(queryRow);
    } else {
      return await getDefaultDataset(queryRow, functionArgs);
    }
  })(queryRow, metadata);
}

function isAlphanumericWithSpaces(value: string) {
  const regex = /^[a-zA-Z0-9\s]+$/;
  return regex.test(value);
}

// Metadata example
// {"yAxis": {"type": "number"}, "params": [{"key": "county_filter", "title": "County"}, {"key": "program_filter", "title": "Program"}, {"key": "stars_filter", "title": "Tier Level"}]}',
//'{"table": "data_ccfap_stars", "extra_filter_values": {"county_filter": ["-- All --"], "program_filter": ["-- All --"], "stars_filter": ["-- All --", "4 or 5 Star"]}, "filters": {"county_filter": {"column": "County"}, "program_filter": {"column": "Provider Program Type"}, "stars_filter": {"column": "Current Tier Level"}}}

interface FiltersDef {
  [key: string]: {
    column: string,
    sort?: 'number' | 'mmyyyy',    // If 'number', then sort by number but non-numbers come first; default is alphanumeric
    xf?: string, // Transform the value from internal to external, e.g. datetime-to-mmyyyy
    exclude?: string[], // Values to exclude from the response
  }
}

export interface UploadTypeFilters {
  filters: FiltersDef,
}

interface QueryFilters {
  table: string,
  filters: FiltersDef,
  extra_filter_values: {
    [key: string]: string[]
  }
}

export type MetadataFiltersDef = {
  key: string,
  title?: string,
  xf?: string,
}[];

export interface QueryMetadata {
  yAxis: {
    type: string,
  },
  filters?: MetadataFiltersDef,
  custom?: string,
}

export async function lambdaHandlerBar(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  if (event.pathParameters == null || event.pathParameters.queryId == null) {
    return {
      statusCode: 400,
    };
  } else {
    const queryId = event.pathParameters.queryId;
    // console.log('opening connection');
    const queryRow = await getQueryRow(queryId);
    const metadata: QueryMetadata | undefined = queryRow?.metadata ? JSON.parse(queryRow.metadata || '{}') : undefined;
    if (queryRow == null) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'unknown chart' }),
      };
    }

    // Take params if configured
    const variables: Record<string, string> = {};
    if (metadata?.filters) {
      const qs = event.queryStringParameters;

      for (const filter of metadata.filters) {
        const paramval = qs?.[filter.key];
        if (paramval == null) {
          return {
            statusCode: 400,
            body: JSON.stringify({ message: `missing parameter ${filter.key}` }),
          };
        } else {
          variables[filter.key] = transformValueExtToInt({columnName: filter.key, value: paramval, xf: filter.xf});
        }
      }
    }

    try {
      const data = await (async (queryRow, metadata) => {
        if (metadata?.custom === "dashboard:indicators:chart") {
          return await getIndicatorsBySubcat(queryRow);
        } else {
          return await getDefaultDataset(queryRow, variables);
        }
      })(queryRow, metadata);

      return {
        statusCode: 200,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json",
          "Access-Control-Allow-Methods": "GET",
        },
        body: JSON.stringify(data),
      };
    } catch (e) {
      console.error(e);
      if (e instanceof BadRequestError) {
        return {
          statusCode: 400,
          body: JSON.stringify({ message: (e as Error).message }),
        };
      } else {
        return {
          statusCode: 500,
          body: (e as Error).message,
        };

      }
    } finally {
      await doDBClose();
    }
  }
}

export async function lambdaHandlerGetFilter(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  if (event.pathParameters == null || event.pathParameters.queryId == null) {
    return {
      statusCode: 400
    };
  }
  const queryId = event.pathParameters.queryId;

  const queryRow = await getQueryRow(queryId);
  const metadata = queryRow?.metadata ? JSON.parse(queryRow.metadata || '{}') : undefined;
  if (queryRow == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'unknown chart' }),
    };
  }

  if (queryRow.filters == null) {
    return {
      statusCode: 200,
      body: JSON.stringify({}),
    };
  }

  const filters = JSON.parse(queryRow.filters) as QueryFilters;
  const ret: Record<string, string[]> = {};

  await doDBOpen();
  const uploadType = queryRow.uploadType ? await getUploadType(queryRow.uploadType) : undefined;

  try {
    const table = filters.table;
    for (const [key, spec] of Object.entries(filters.filters)) {
      const columnName = spec.column;
      const resultRows = await doDBQuery(`select distinct \`${columnName}\` as value from ${table} order by value`);

      const seenItems: Record<string, boolean> = {};

      ret[key] = resultRows.
        map((row: { value: string }) => `${row.value}`).
        filter((value: string) => {
          if (spec.exclude && spec.exclude.includes(value)) {
            return false;
          }

          return true;
        }).
        // Two kinds of transformation: first, based on the column itself, second based on the xf field
        // in the query definition.
        map((value: string) => {
          return transformValueIntToExt({columnName, value, uploadType, xf: spec.xf});
        }).
        filter((value: string) => {
          if (seenItems[value] || value.includes("NaN")) {
            return false;
          }
          seenItems[value] = true;
          return true;
        })
      ;

      // Then add any extra values for this filter type
      if (filters.extra_filter_values?.[key]) {
        ret[key].push(...filters.extra_filter_values[key]);
      }

      pt.logger.info('sorting values', { values: ret[key], key, spec, seenItems });

      // Sort them all
      ret[key].sort((a, b) => {
        if (spec.sort === 'number') {
          if (isNaN(parseFloat(a))) {
            // Return the alphanumeric sort in this case
            return a.localeCompare(b);
          } else if (isNaN(parseFloat(b))) {
            // Return the alphanumeric sort in this case
            return a.localeCompare(b);
          } else {
            return parseFloat(a) - parseFloat(b);
          }
        } else if (spec.sort === 'mmyyyy') {
          // The date format is "mm/yyyy"
          if (!/^\d{1,2}\/\d{4}$/.test(a)) {
            return -1;
          } else if (!/^\d{1,2}\/\d{4}$/.test(b)) {
            return 1;
          }
          
          const [am, ay] = a.split('/');
          const [bm, by] = b.split('/');
          if (ay !== by) {
            return parseInt(ay) - parseInt(by);
          } else {
            return parseInt(am) - parseInt(bm);
          }
        } else {
          return a.localeCompare(b);
        }          
      });
    }
  } finally {
    await doDBClose();
  }

  return {
    statusCode: 200,
    body: JSON.stringify(ret),
  };
}

// Only run if executed directly
if (!module.parent) {
  (async () => {
    console.log('starting');
    const event: APIGatewayProxyEventV2 = {
      pathParameters: {
        queryId: 'dashboard:indicators:chart',
      },
    } as unknown as APIGatewayProxyEventV2;
    console.log(await lambdaHandlerBar(event));
  })();
}
