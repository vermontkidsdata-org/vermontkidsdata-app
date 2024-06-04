import { Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { Tracer } from '@aws-lambda-powertools/tracer';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { getResponse as getIndicatorsBySubcat } from './custom/indicators-by-subcat';
import { doDBClose, doDBOpen, doDBQuery } from "./db-utils";
const { LOG_LEVEL, NAMESPACE } = process.env;

// Set your service name. This comes out in service lens etc.
const serviceName = `charts-api-${NAMESPACE}`;
export const loggerCharts = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});
export const tracerCharts = new Tracer({ serviceName });

export interface QueryRow {
  id: number,
  name: string,
  sqlText: string,
  columnMap?: string,
  metadata?: string,
  uploadType?: string,
}

async function getQueryRow(queryId: string): Promise<QueryRow | undefined> {
  await doDBOpen();
  try {
    // Get the query to run from the parameters
    const queryRows = await doDBQuery('SELECT sqlText, metadata, uploadType FROM queries where name=?', [queryId]);
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

export async function getDefaultDataset(queryRow: QueryRow): Promise<any> {
  const metadata = queryRow?.metadata ? JSON.parse(queryRow.metadata || '{}') : undefined;

  await doDBOpen();
  try {
    const uploadType = queryRow.uploadType;

    // Now run the query. Should always return three columns, with the following names
    // - cat: The category(s)
    // - label: The label for the values
    // - value: The value for the values
    const resultRows = await doDBQuery(queryRow.sqlText);
    // console.log('result', resultRows);

    interface QueryResult {
      cat: string,
      label: string,
      value: string
    }
    const categories: string[] = [];
    const series: { [label: string]: { [key: string]: string } } = {};
    resultRows.forEach((row: QueryResult) => {
      const cat = row.cat;
      const label = row.label;
      const value = row.value;
      if (series[label] == null) {
        series[label] = {};   // Keyed by category
      }
      if (!categories.includes(cat)) {
        categories.push(cat);
      }
      series[label][cat] = value;
    });

    // console.log('categories', categories);
    // console.log('series', series);
    const retSeries: { name: string, data: (number | null)[] }[] = Object.keys(series).map(label => {
      // console.log('label', label);
      return {
        name: label,
        data: categories.map(cat => {
          const val = parseFloat(series[label][cat]);
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

export interface BarChartResult {
  metadata: {
    config: any,
    uploadType: string,
  },
  series: {
    name: string,
    data: (number | null)[],
  }[],
  categories: (string | number)[],
}

class BadRequestError extends Error {
  statusCode: number;
  constructor(statusCode: number, message: string) {
    super(message);
    this.statusCode = statusCode;
  }
}

export async function getChartData(queryId: string): Promise<BarChartResult> {
  const queryRow = await getQueryRow(queryId);
  const metadata = queryRow?.metadata ? JSON.parse(queryRow.metadata || '{}') : undefined;
  if (queryRow == null) {
    throw new BadRequestError(400, 'unknown chart');
  }

  return await (async (queryRow, metadata) => {
    if (metadata.custom === "dashboard:indicators:chart") {
      return await getIndicatorsBySubcat(queryRow);
    } else {
      return await getDefaultDataset(queryRow);
    }
  })(queryRow, metadata);
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
    const metadata = queryRow?.metadata ? JSON.parse(queryRow.metadata || '{}') : undefined;
    if (queryRow == null) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'unknown chart' }),
      };
    }

    try {
      const data = await (async (queryRow, metadata) => {
        if (metadata.custom === "dashboard:indicators:chart") {
          return await getIndicatorsBySubcat(queryRow);
        } else {
          return await getDefaultDataset(queryRow);
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
