if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.VKD_ENVIRONMENT = 'qa';
}

import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBOpen, doDBQuery } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from './lambda-utils';
import { getUploadType, UploadType } from './uploadData';

const pt = makePowerTools({ prefix: `download-${process.env.VKD_ENVIRONMENT}` });

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

export async function getCSVData(uploadTypeData: UploadType, limit: number, columnFilters?: Record<string, string>): Promise<
  { body: string, numrows: number } |
  { errorMessage: string, errorStatus: number }
> {
  const uploadType = uploadTypeData.type;
  const lookupUploadType = uploadType.includes(":") ? uploadType.substring(0, uploadType.indexOf(':')) : uploadType;
  const entry = typesConfig[lookupUploadType];

  if (entry == null) {
    return { errorMessage: `unknown upload type ${uploadType}`, errorStatus: 400 };
  }

  await doDBOpen();

  // Allow for a custom query
  const params: string[] = [];
  const sqlText = (() => {
    if (uploadTypeData.download_query != null && uploadTypeData.download_query != '') {
      return uploadTypeData.download_query;
    } else {
      const table_name = entry.getTableNameForFunction(uploadType);

      let tSql = `select * from ${table_name} where `;
      if (columnFilters != null && Object.keys(columnFilters).length > 0) {
        tSql += Object.entries(columnFilters).map(([key, val]) => `LOWER(TRIM(\`${key}\`)) = LOWER(TRIM(?))`).join(' and ');
        params.push(...Object.values(columnFilters));
      } else {
        tSql += '1=1';
      }

      return tSql +
        (uploadTypeData.indexColumns.length > 0 ?
          ` order by \`${uploadTypeData.indexColumns}\`` :
          '') +
        ` limit ${limit > 0 ? limit : 1}`;
    }
  })();

  console.log({ uploadType, uploadTypeData, sqlText });

  const resp = await doDBQuery(sqlText, params);
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

export function isErrorResponse(resp: any): resp is { errorMessage: string, errorStatus: number } {
  return resp.errorMessage != null;
}

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
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
      await doDBOpen();

      const uploadTypeData = await getUploadType(uploadType);
      const columnFilters: Record<string, string> = {};
      if (uploadTypeData.filters) {
        const qs = event.queryStringParameters;
  
        for (const filterItem of Object.entries(uploadTypeData.filters.filters)) {
          pt.logger.info('filterItem', {filterItem});
          const qsKey = filterItem[0];
          const colname = filterItem[1].column;
          const paramval = qs?.[qsKey];
          if (paramval != null) {
            columnFilters[colname] = paramval;
          }
        }
      }

      pt.logger.info('columnFilters', {columnFilters});

      // We have a callback function to call. Query the table.
      const resp = await getCSVData(uploadTypeData, limit, columnFilters);
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

// if (!module.parent) {
//   (async () => {
//     console.log(await lambdaHandler({
//       pathParameters: {
//         uploadType: 'dashboard:indicators',
//       },
//     } as unknown as APIGatewayProxyEvent))
//   })().catch(err => {
//     console.log(`exception`, err);
//   });
//   process.exit(1);
// }

export const main = prepareAPIGateway(lambdaHandler);