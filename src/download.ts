if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.NAMESPACE = 'qa';
}

import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEvent, APIGatewayProxyResultV2 } from 'aws-lambda';
import { CORSConfigOpen } from './cors-config';
import { doDBClose, doDBOpen, doDBQuery } from "./db-utils";

// Set your service name. This comes out in service lens etc.
const serviceName = `download-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: (process.env.LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});
const tracer = new Tracer({ serviceName });

const { REGION } = process.env;

interface DBRow {
  [key: string]: string | number
}

type CsvProcessCallback = (type: string, record: DBRow, lnum: number, rows: string[][], errors: Error[], clientData: any) => Promise<void>;
type GetTableNameForFunction = (type: string) => string;
type GetQueryForFunction = (type: string) => string;

interface TypesConfigElement {
  readonly?: boolean;
  processRowFunction: CsvProcessCallback;
  getTableNameForFunction: GetTableNameForFunction;
  getQueryForFunction?: GetQueryForFunction;
}

const typesConfig: { [type: string]: TypesConfigElement } = {
  assessments: {
    processRowFunction: processAssessmentRow,
    getTableNameForFunction: (type: string) => "data_assessments",
  },
  general: {
    processRowFunction: processGeneralRow,
    getTableNameForFunction: (type: string) => "data_" + type.substring('general'.length + 1),
  },
  dashboard: {
    processRowFunction: processGeneralRow,
    getTableNameForFunction: (type: string) => "dashboard_" + type.substring('dashboard'.length + 1),
  },
  // Query is like general, but read-only!
  query: {
    readonly: true,
    processRowFunction: processGeneralRow,
    getTableNameForFunction: (type: string) => "data_" + type.substring('general'.length + 1),
  },
}

async function processAssessmentRow(type: string, record: DBRow, lnum: number, rows: string[][], errors: Error[], clientData: any): Promise<void> {
}

interface ProcessGeneralRowClientData {
  keys: string[];
}

async function processGeneralRow(type: string, record: DBRow, lnum: number, rows: string[][], errors: Error[], clientData: ProcessGeneralRowClientData): Promise<void> {
  if (lnum === 1) {
    clientData.keys = Object.keys(record).filter(key => key !== 'id');
    rows.push(clientData.keys);
  }
  // console.log({ type, record, lnum });
  rows.push(clientData.keys.map(key => {
    const val = record[key];
    if (typeof val === 'number') return val.toString();
    else return val;
  }));
}

function updateResponse(response: any, body: any, statusCode?: number) {
  response.body = JSON.stringify(body);
  if (statusCode != null) {
    response.statusCode = statusCode;
  }
}

function toCSV(row: (string | number)[]): string {
  return row.map(el => `${el}`.includes(',') ? `"${el}"` : el).join(',');
}

export async function getCSVData(uploadType: string, limit: number): Promise<
  { body: string, numrows: number } |
  { errorMessage: string, errorStatus: number }
> {
  const lookupUploadType = uploadType.includes(":") ? uploadType.substring(0, uploadType.indexOf(':')) : uploadType;
  const entry = typesConfig[lookupUploadType];

  if (entry == null) {
    return { errorMessage: `unknown upload type ${uploadType}`, errorStatus: 400 };
  }

  await doDBOpen();

  const uploadTypeData: { type: string, table: string, index_columns: string, download_query?: string }[] = await doDBQuery('select * from `upload_types` where `type`=?', [uploadType]);

  if (uploadTypeData.length !== 1) {
    return { errorMessage: `expected 1 row from upload_types for ${uploadType} got ${uploadTypeData.length}`, errorStatus: 400 };
  } else {
    // Allow for a custom query
    const sqlText = (() => {
      if (uploadTypeData[0].download_query != null && uploadTypeData[0].download_query != '') {
        return uploadTypeData[0].download_query;
      } else {
        const table_name = entry.getTableNameForFunction(uploadType);

        return `select * from ${table_name} ` +
          (uploadTypeData[0].index_columns.length > 0 ?
            ` order by ${uploadTypeData[0].index_columns}` :
            '') +
          ` limit ${limit > 0 ? limit : 1}`;
      }
    })();

    console.log({ uploadType, uploadTypeData, sqlText });

    const resp = await doDBQuery(sqlText);
    let lnum = 1;
    const errors: Error[] = [];

    const rows: string[][] = [];

    // Client data - handlers can put anything they want in there
    const clientData: any = {};

    for (const row of resp) {
      entry.processRowFunction(uploadType, row, lnum, rows, errors, clientData);

      lnum++;
    }

    // Now append all the rows into a long CSV string
    return {
      body: rows.map(row => toCSV(row)).join('\n'),
      numrows: rows.length-1,
    }
  }
}

export function isErrorResponse(resp: any): resp is { errorMessage: string, errorStatus: number } {
  return resp.errorMessage != null;
}

export async function lambdaHandler(
  event: APIGatewayProxyEvent,
): Promise<APIGatewayProxyResultV2> {
  console.log(`REGION=${REGION}, event 👉`, event);

  const limitArg = event.queryStringParameters?.limit;
  const limit = limitArg != null ? parseInt(limitArg) : Number.MAX_SAFE_INTEGER;

  const response: { statusCode: number, body: string, headers: { [key: string]: string } } = {
    statusCode: 500,
    body: '',
    headers: {},
  };

  try {
    // GET /download/general:bed
    const uploadType = event.pathParameters?.uploadType;

    if (uploadType == null) {
      updateResponse(response, {
        message: 'missing upload type',
      }, 400);
    } else {
      // We have a callback function to call. Query the table.
      const resp = await getCSVData(uploadType, limit);
      if (isErrorResponse(resp)) {
        updateResponse(response, {
          message: resp.errorMessage,
        }, resp.errorStatus);
      } else {
        response.body = resp.body ?? 'unknown-csv';
        response.statusCode = 200;
        response.headers['Content-Type'] = 'text/csv';
      }
    }
  } finally {
    await doDBClose()
  }

  return response;
}

if (!module.parent) {
  (async () => {
    console.log(await lambdaHandler({
      pathParameters: {
        uploadType: 'dashboard:indicators',
      },
    } as unknown as APIGatewayProxyEvent))
  })().catch(err => {
    console.log(`exception`, err);
  });
  process.exit(1);
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigOpen),
  );
