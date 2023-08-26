if (!module.parent) {
  process.env.S3_BUCKET_NAME = 'ctechnica-vkd-qa';
  process.env.STATUS_TABLE = 'qa-LocalDevBranch-UploadstatustableA9E2FF87-1KSF20M176GXI';
  process.env.REGION = 'us-east-1';
  process.env.NAMESPACE = 'qa';
}

import { APIGatewayProxyEventV2, APIGatewayProxyStructuredResultV2, S3Event } from 'aws-lambda';
import * as AWS from 'aws-sdk';
import { PutItemOutput } from 'aws-sdk/clients/dynamodb';
import * as csv from 'csv-parse';
import { v4 as uuidv4 } from 'uuid';
import { doDBClose, doDBCommit, doDBOpen, doDBQuery, getDBSecret } from "./db-utils";

interface UploadInfo {
  type: string;
  key: string;
}

const { S3_BUCKET_NAME: bucketName, REGION, STATUS_TABLE: statusTableName } = process.env;
const s3 = new AWS.S3({ region: REGION });
const dynamodb = new AWS.DynamoDB({ region: REGION });

type CsvProcessCallback = (type: UploadType, record: string[], lnum: number, identifier: string, uploadType: UploadType, dryRun: boolean, errors: Error[], clientData: any) => Promise<void>;

interface TypesConfigElement {
  processRowFunction: CsvProcessCallback; // Called on each row
  preFunction?: CsvProcessCallback; // Called before any rows
  postFunction?: CsvProcessCallback; // Called after all rows
}

const typesConfig: { [type: string]: TypesConfigElement } = {
  indicators: {
    processRowFunction: processIndicatorsRow,
  },
  assessments: {
    processRowFunction: processAssessmentRow,
  },
  general: {
    processRowFunction: processGeneralRow
  },
  dashboard: {
    processRowFunction: processGeneralRow,
    preFunction: truncateTable,
  },
}

interface ProcessGeneralRowClientData {
  uploadType: UploadType;
  uploadColumns: string[];
}

interface UploadType {
  id: number,
  type: string,
  table: string,

  // Calculated
  columns: Column[],
  indexColumns: string[],
  columnMap: Record<string, string>, // Mapping from real internal column name to external, first converted to internal
}

enum ColumnDataType {
  INTEGER, STRING, FLOAT, DOUBLE, ENUM
}

interface Column {
  columnName: string,
  dataType: ColumnDataType,
  isNullable: boolean
}

// Cache upload_types and columns for the table

const uploadTypes: Record<string, UploadType> = {}; // key by type
const columns: Record<string, Column[]> = {}; // key by table

function getDataType(data_type: string): ColumnDataType {
  if (data_type === 'int') return ColumnDataType.INTEGER;
  else if (data_type === 'varchar') return ColumnDataType.STRING;
  else if (data_type === 'float') return ColumnDataType.FLOAT;
  else if (data_type === 'double') return ColumnDataType.DOUBLE;
  else if (data_type === 'enum') return ColumnDataType.ENUM;
  else throw new Error(`unknown data type ${data_type}`);
}

async function getColumns(table: string): Promise<Column[]> {
  // console.log({ message: 'getColumns', table });
  if (columns[table] != null) {
    return columns[table];
  } else {
    const info = await getDBSecret();
    const colsRaw = await doDBQuery(
      'select `column_name`, `data_type`, `is_nullable` from `information_schema`.`columns` where `table_name`=? and table_schema=? order by `ordinal_position`',
      [table, info.schema]);
    if (colsRaw == null || colsRaw.length == 0) {
      throw new Error(`unknown table ${table}`);
    } else {
      const cols = colsRaw.map(colRaw => ({
        columnName: colRaw.COLUMN_NAME as string,
        dataType: getDataType(colRaw.DATA_TYPE),
        isNullable: colRaw.IS_NULLABLE === 'YES'
      }));
      // console.log({ colsRaw, cols });

      columns[table] = cols;
      return cols;
    }
  }
}

async function getUploadType(type: string): Promise<UploadType> {
  // console.log({ message: 'getUploadType', type, lookup: uploadTypes[type] });
  if (uploadTypes[type] == null) {
    const types = await doDBQuery('select * from `upload_types` where `type`=?', [type]);
    // console.log({ message: 'getUploadType ret', type: types[0] });
    if (types == null || types.length !== 1) {
      throw new Error(`no types found for type=${type}`);
    } else {
      const uploadTypeRaw: { id: number, type: string, table: string, index_columns: string, column_map?: string } = types[0];
      // Get the columns list
      const columns = await getColumns(uploadTypeRaw.table);
      const columnMap = (() => {
        if (!uploadTypeRaw.column_map) return undefined;
        const rawMap: Record<string, string> = JSON.parse(uploadTypeRaw.column_map);
        const cookedMap: Record<string, string> = {};

        for (const key of Object.keys(rawMap)) {
          cookedMap[key] = humanToInternalName(rawMap[key]);
        }
        return cookedMap;
      })();

      // console.log({ type, uploadTypeRaw, columns })
      const uploadType = {
        id: uploadTypeRaw.id,
        type: uploadTypeRaw.type,
        table: uploadTypeRaw.table,
        columns,
        columnMap,
        indexColumns: uploadTypeRaw.index_columns.split(',').map(c => c.trim()),
      } as UploadType;

      uploadTypes[type] = uploadType;
      return uploadType;
    }
  } else {
    return uploadTypes[type];
  }
}

function humanToInternalName(col: string): string {
  return col.toLowerCase().replace(/ /g, '_');
}

function matchColumns(record: string[], uploadType: UploadType): { matchedColumns: string[], unmatchedColumns: string[] } {
  const uploadTypeColumns: Column[] = uploadType.columns;
  const uploadTypeColumnNames = uploadTypeColumns.map(col => humanToInternalName(col.columnName));
  const matchedColumns: string[] = [];
  const unmatchedColumns: string[] = [];

  // Go thru each of the columns in the record and see if there's one that "matches"
  for (const col of record) {
    // "Match" is defined as "case insensitive comparison where spaces and underscores are equivalent".
    // But first we need to see if there's a column mapping, and substitute the incoming name.
    let lccolExternal = humanToInternalName(col);
    const mappedColumn = uploadType.columnMap ?
      Object.entries(uploadType.columnMap).find(e => e[1] === lccolExternal)?.[0] :
      undefined;

    const lccol = mappedColumn ?? lccolExternal;
    // console.log({ message: 'match check', uploadTypeColumnNames, lccol });
    const matchPos = uploadTypeColumnNames.indexOf(lccol);
    if (matchPos >= 0) {
      matchedColumns.push(uploadTypeColumns[matchPos].columnName);
    } else {
      unmatchedColumns.push(col);
    }
  }

  return { matchedColumns, unmatchedColumns };
}

async function truncateTable(type: UploadType, record: string[], lnum: number, identifier: string, uploadType: UploadType, dryRun: boolean, errors: Error[], clientData: ProcessGeneralRowClientData): Promise<void> {
  const sql = `truncate table ${type.table}`;
  if (dryRun) {
    console.log({ sql });
  } else {
    await doDBQuery(sql);
  }
}

async function processGeneralRow(type: UploadType, record: string[], lnum: number, identifier: string, uploadType: UploadType, dryRun: boolean, errors: Error[], clientData: ProcessGeneralRowClientData): Promise<void> {
  // console.log({ message: 'processGeneralRow start', type, record, lnum });
  if (lnum === 1) {
    // Assume this has the column names. Check against the value ones for this type. But first we need to look it up...
    // const uploadType = await getUploadType(type);

    // Get rid of possible BOM. Stupid Excel.
    if (record[0].startsWith("\ufeff")) {
      console.log('It has a BOM! Stupid Excel. Stripping it...');
      record[0] = record[0].substring(1);
    }

    // Check the columns. We might we more lenient at some point, but right now they have to
    // match exactly. Note we should get one less, no id column.
    if (record.length !== uploadType.columns.length - 1) {
      throw new Error(`wrong number of columns for type ${type.type}; expected ${JSON.stringify(Object.values(uploadType.columns).map(v => v.columnName))} got ${JSON.stringify(record)}`);
    }

    const tableColumns = uploadType.columns.map(c => c.columnName);

    const { matchedColumns, unmatchedColumns } = matchColumns(record, uploadType);
    console.log({ record, cols: uploadType.columns, unmatchedColumns, matchedColumns });

    if (unmatchedColumns.length > 0) {
      console.error({ message: 'unknown column name(s) in first row', tableColumns, record, t: uploadType.table, unmatchedColumns });
      throw new Error(`unknown column name(s) ${JSON.stringify(unmatchedColumns)}`);
    }

    clientData.uploadType = uploadType;
    clientData.uploadColumns = matchedColumns;

    // console.log({ message: 'processGeneralRow: first', clientData });
  } else {
    // Assume the type is following format: general:specific where specific is looked up table_name means we're inserting into data_table_name
    console.log({ message: 'processGeneralRow: not first row', lnum, record, identifier, clientData });

    // Check number of columns is right
    if (record.length !== clientData.uploadColumns.length) {
      throw new Error(`wrong number of columns in row ${lnum}: expected ${clientData.uploadColumns.length} got ${record.length}`);
    }

    const updates = clientData.uploadColumns.filter(c => !clientData.uploadType.indexColumns.includes(c)).map(c => `\`${c}\`=?`);
    if (updates.length === 0) {
      updates.push('`id`=`id`');
    }

    const sql = `insert into \`${clientData.uploadType.table}\` (` +
      clientData.uploadColumns.map(c => `\`${c}\``).join(',') +
      `) values (` +
      record.map(v => '?').join(',') +
      `) on duplicate key update ` +
      updates.join(',');

    const values = ((uploadColumns, indexColumns) => {
      console.log({ indexColumns, uploadColumns });

      const inserts: string[] = [];
      const updates: string[] = [];

      for (let i = 0; i < record.length; i++) {
        // First set the insert values, then the update ones
        inserts.push(record[i]);

        if (!indexColumns.includes(uploadColumns[i])) {
          updates.push(record[i]);
        }
      }
      return [...inserts, ...updates];
    })(clientData.uploadColumns, clientData.uploadType.indexColumns);

    if (dryRun) {
      console.log({ sql, values });
    } else {
      await doDBQuery(sql, values);
    }
  }
}

async function processIndicatorsRow(type: UploadType, record: string[], lnum: number, identifier: string, uploadType: UploadType, dryRun: boolean, errors: Error[], clientData: any): Promise<void> {
  if (lnum === 1) {
    // First row, the column headers are important because they give the topics (or sub-topics).
    // But this is only from column F on. The other columns should be fixed, so we will validate
    // them.
    clientData

  } else {

  }
}

async function processAssessmentRow(type: UploadType, record: string[], lnum: number, identifier: string, uploadType: UploadType, dryRun: boolean, errors: Error[], clientData: any): Promise<void> {
  if (lnum > 1) {
    if (record.length != 9) throw new Error(`lines expected to have 9 columns`);

    if ((lnum % 1000) == 0) console.log(lnum);
    const values = {
      sy: parseInt(record[0]),
      org_id: record[1],
      test_name: record[2],
      indicator_label: record[3],
      assess_group: record[4],
      assess_label: record[5],
      value_w: (record[6] == '' || record[6] == 'NULL') ? null : parseFloat(record[6]),
      value_w_st: (record[7] == '' || record[7] == 'NULL') ? null : parseFloat(record[7]),
      value_w_susd: (record[8] == '' || record[8] == 'NULL') ? null : parseFloat(record[8])
    };
    await doDBQuery(
      `insert into data_assessments (sy, org_id, test_name, indicator_label, assess_group, assess_label, value_w, value_w_st, value_w_susd) 
            values (?, ?, ?, ?, ?, ?, ?, ?, ?) \
            on duplicate key update \
            sy=?, org_id=?, test_name=?, indicator_label=?, assess_group=?, assess_label=?, value_w=?, value_w_st=?, value_w_susd=?`,
      [
        values.sy, values.org_id, values.test_name, values.indicator_label, values.assess_group, values.assess_label, values.value_w, values.value_w_st, values.value_w_susd,
        values.sy, values.org_id, values.test_name, values.indicator_label, values.assess_group, values.assess_label, values.value_w, values.value_w_st, values.value_w_susd
      ]
    );
  }
}

async function updateStatus(id: string, status: string, percent: number, numRecords: number, errors: Error[]): Promise<PutItemOutput> {
  return dynamodb.putItem({
    TableName: statusTableName!,
    Item: {
      id: { S: id },
      status: { S: status },
      numRecords: { N: numRecords.toString() },
      percent: { N: percent.toString() },
      errors: { S: JSON.stringify(errors.map(e => e.message)) },
      lastUpdated: { S: new Date().toISOString() }
    }
  }).promise();
}

export async function status(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyStructuredResultV2> {
  const ret = await dynamodb.getItem({
    TableName: statusTableName!,
    Key: {
      id: { S: event.pathParameters!.uploadId }
    }
  }).promise();

  if (ret.Item == null) {
    return {
      statusCode: 500
    };
  } else {
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Access-Control-Allow-Methods": "GET",
      },
      body: JSON.stringify({
        status: ret.Item.status.S,
        numRecords: ret.Item.numRecords.N,
        percent: ret.Item.percent.N,
        errors: ret.Item.errors.S,
        lastUpdated: ret.Item.lastUpdated.S
      })
    };
  }
}

export async function processUpload(props: {
  bodyContents: string,
  typeConfig: TypesConfigElement,
  identifier: string,
  uploadType: UploadType,
  dryRun: boolean,
}): Promise<{
  errors: Error[],
  saveTotal: number,
  statusUpdatePct: number,
}> {
  const errors: Error[] = []
  let saveTotal = 0;
  let statusUpdatePct = 0;
  let lastStatusUpdatePct = 0;
  try {
    // Client data - handlers can put anything they want in there
    const clientData: any = {};

    await processCSV(props.bodyContents, props.uploadType, async (record, index, total) => {
      console.log({ message: 'row', index, record });

      if (index === 1 && props.typeConfig.preFunction) {
        console.log({ message: 'executing pre-function' });

        await props.typeConfig.preFunction(props.uploadType, record, index, props.identifier, props.uploadType, props.dryRun, errors, clientData);
      }
      await props.typeConfig.processRowFunction(props.uploadType, record, index, props.identifier, props.uploadType, props.dryRun, errors, clientData);
      if (index === total && props.typeConfig.postFunction) {
        console.log({ message: 'executing post-function' });

        await props.typeConfig.postFunction(props.uploadType, record, index, props.identifier, props.uploadType, props.dryRun, errors, clientData);
      }

      // Update status every 10%
      statusUpdatePct = Math.round(100 * index / total);
      if (Math.floor(lastStatusUpdatePct / 10) != Math.floor(statusUpdatePct / 10)) {
        lastStatusUpdatePct = statusUpdatePct;
        await updateStatus(props.identifier, 'In progress', statusUpdatePct, total, []);
      }
      saveTotal = total;
    });
  } catch (e) {
    console.error(e);
    errors.push(e as Error);
  }

  return { errors, saveTotal, statusUpdatePct };
}

export async function main(
  event: S3Event,
): Promise<string> {
  console.log(`S3_BUCKET_NAME=${bucketName}, REGION=${REGION}, event 👉`, event);

  const bucket = event.Records[0].s3.bucket.name;
  const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
  const params = {
    Bucket: bucket,
    Key: key,
  };
  console.log('params', params);
  try {
    const { ContentType, Body } = await s3.getObject(params).promise();
    const { TagSet } = await s3.getObjectTagging(params).promise();
    console.log('CONTENT TYPE:', ContentType);
    const bodyContents = Body?.toString('utf-8');

    //[ { Key: 'type', Value: 'assessments' } ]
    console.log('TAGS:', TagSet);
    const tags: { [key: string]: string } = {};
    if (TagSet != null) TagSet.forEach(tag => tags[tag.Key.toLowerCase()] = tag.Value.toLowerCase());
    console.log(`tags = ${tags}`);
    if (tags.type == null || bodyContents == null) {
      return 'unknown';
    }

    // Get the identifier. Just create a UUID if one not provided like it should be.
    const identifier = tags.identifier || uuidv4();
    console.log(`set in progress ${identifier}`);
    await updateStatus(identifier, 'In progress', 0, 0, []);

    console.log('opening connection');
    await doDBOpen();
    console.log('connection open');
    try {
      // Assume the type has two pieces separated by a colon
      // - the typesConfig value
      // - the rest of it, depends on the typesConfig value
      const typePrefix = tags.type.includes(':') ? tags.type.substring(0, tags.type.indexOf(':')) : tags.type;
      const typeConfig = typesConfig[typePrefix];

      console.log({ typePrefix, typeConfig });

      const { errors, saveTotal, statusUpdatePct } = await processUpload({
        bodyContents,
        typeConfig,
        uploadType: await getUploadType(tags.type),
        identifier,
        dryRun: false,
      });

      await updateStatus(identifier, (errors.length == 0 ? 'Complete' : 'Error'), statusUpdatePct, saveTotal, errors);
      await doDBCommit();
    } finally {
      await doDBClose();
    }

    return ContentType || 'unknown';
  } catch (err) {
    console.error(err);
    const message = `Error getting object ${key} from bucket ${bucket}. Make sure they exist and your bucket is in the same region as this function.`;
    console.log(message);
    throw new Error(message);
  }
}

async function parseCSV(recordsString: string): Promise<string[][]> {
  return new Promise<string[][]>((resolve, reject) => {
    csv.parse(recordsString, (err, tempRecords: string[][]) => {
      if (err) {
        reject(new Error(`csv.parse error: ${err.message}`));
      } else {
        console.log(`number of records processing csv: ${tempRecords.length}`)
        resolve(tempRecords);
      }
    });
  })
}

async function processCSV(recordsString: string, uploadType: UploadType, callback: (record: string[], index: number, total: number) => Promise<void>): Promise<void> {
  // First parse into array. Hopefully there are not too many!
  let records: string[][] = await parseCSV(recordsString);

  // Now process the records
  console.log(`number of records: ${records.length}`);
  for (let i = 0; i < records.length; i++) {
    await callback(records[i], i + 1, records.length);
  }
}

if (!module.parent) {
  (async () => {
    console.log('opening connection');
    try {
      await doDBOpen();
      console.log('connection open');
      const bodyContents = `SY,Org id,Test Name,Indicator Label,Assess Group,Assess Label,School Value,Supervisory Union Value,State Value
2021,VT001,SB English Language Arts Grade 03,Total Proficient and Above,All Students,All Students,,,0.425
2021,VT001,SB English Language Arts Grade 03,Total Proficient and Above,Disability,No Special Ed,,,0.485
`;
      const uploadType = await getUploadType('general:assessments');

      const { errors, saveTotal, statusUpdatePct } = await processUpload({
        bodyContents,
        typeConfig: typesConfig['general'],
        uploadType,
        identifier: '12345',
        dryRun: false,
      });
      console.log({ errors, saveTotal, statusUpdatePct });
    } catch (e) {
      console.error(e);
      await doDBClose();
    }
    // console.log(await main({
    //   Records: [{
    //     s3: {
    //       bucket: {
    //         name: process.env.S3_BUCKET_NAME
    //       },
    //       object: {
    //         key: 'data_ed.csv'
    //       }
    //     }
    //   }]
    // } as S3Event))
  })().catch(err => {
    console.log(`exception`, err);
  });
} else {
  console.log("we're NOT in the local deploy, probably in Lambda");
}
