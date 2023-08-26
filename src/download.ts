if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.NAMESPACE = 'qa';
}

import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEvent, APIGatewayProxyResultV2 } from 'aws-lambda';
import { CORSConfigOpen } from './cors-config';
import { doDBClose, doDBOpen, doDBQuery } from "./db-utils";

// Set your service name. This comes out in service lens etc.
const serviceName = `download-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: process.env.LOG_LEVEL || 'INFO',
  serviceName
});
const tracer = new Tracer({ serviceName });

const { REGION } = process.env;

interface DBRow {
  [key: string]: string | number
};

type CsvProcessCallback = (type: string, record: DBRow, lnum: number, rows: string[][], errors: Error[], clientData: any) => Promise<void>;
type GetTableNameForFunction = (type: string) => string;

interface TypesConfigElement {
  processRowFunction: CsvProcessCallback;
  getTableNameForFunction: GetTableNameForFunction;
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

export async function lambdaHandler(
  event: APIGatewayProxyEvent,
): Promise<APIGatewayProxyResultV2> {
  console.log(`REGION=${REGION}, event 👉`, event);

  const MAX_LIMIT = 999999999999;
  const limitArg = event.queryStringParameters?.limit;
  const limit = limitArg != null ? parseInt(limitArg) : MAX_LIMIT;

  const response: { statusCode: number, body: string, headers: { [key: string]: string } } = {
    statusCode: 500,
    body: '',
    headers: {}
  };

  try {
    // GET /download/general:bed
    const uploadType = event.pathParameters?.uploadType;
    if (uploadType == null) {
      updateResponse(response, {
        message: 'missing upload type'
      }, 400);
    } else {
      const lookupUploadType = uploadType.includes(":") ? uploadType.substring(0, uploadType.indexOf(':')) : uploadType;
      const entry = typesConfig[lookupUploadType];

      if (entry == null) {
        updateResponse(response, {
          message: `invalid upload type ${uploadType}`
        }, 400);
      } else {
        const table_name = entry.getTableNameForFunction(uploadType);

        // We have a callback function to call. Query the table.
        await doDBOpen();

        const uploadTypeData: { type: string, table: string, index_columns: string, }[] = await doDBQuery('select * from `upload_types` where `type`=?', [uploadType]);
        
        if (uploadTypeData.length !== 1) {
          updateResponse(response, {
            message: `expected 1 row from upload_types for ${uploadType} got ${uploadTypeData.length}`
          });
        } else {
          const sqlText = `select * from ${table_name} ` +
            (uploadTypeData[0].index_columns.length > 0 ?
              ` order by ${uploadTypeData[0].index_columns}` :
              '') +
            ` limit ${limit > 0 ? limit : 1}`;

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
          response.body = rows.map(row => toCSV(row)).join('\n');
          response.statusCode = 200;
          response.headers['Content-Type'] = 'text/csv';
        }
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
        uploadType: 'dashboard:indicators'
      }
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
    cors(CORSConfigOpen)
  );
