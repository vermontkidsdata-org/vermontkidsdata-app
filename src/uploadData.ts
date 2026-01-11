if (!module.parent) {
  process.env.S3_BUCKET_NAME = 'ctechnica-vkd-qa';
  process.env.SERVICE_TABLE = 'qa-LocalDevBranch-UploadstatustableA9E2FF87-1KSF20M176GXI';
  process.env.REGION = 'us-east-1';
  process.env.VKD_ENVIRONMENT = 'qa';
}

import { GetObjectCommand, GetObjectTaggingCommand, S3Client } from '@aws-sdk/client-s3';
import { SQSClient, SendMessageCommand } from '@aws-sdk/client-sqs';
import { UpdateCommandOutput } from '@aws-sdk/lib-dynamodb';
import { SQSEvent } from 'aws-lambda';
import * as csv from 'csv-parse';
import { v4 as uuidv4 } from 'uuid';
import { DatasetVersion, DatasetVersionData, Document, NameMapData, STATUS_DATASET_VERSION_QUEUED, UploadStatus, doDBClose, doDBCommit, doDBOpen, doDBQuery, getDBSecret } from "./db-utils";
import { UploadTypeFilters } from './chartsApi';

// {"dataset":"general:residentialcare","version":"2023-11-24T14:07:43.874Z","identifier":"20231124-1"}
export interface DatasetBackupMessage {
  dataset: string,
  version: string,
  identifier: string,
}

// The fixed columns for each type
const dashboardFixedColumns: Record<string, string[]> = {
  'dashboard:categories': ['Category'].map(c => humanToInternalName(c)),
  'dashboard:indicators': ['wp_id', 'slug', 'Chart_url', 'link', 'title'].map(c => humanToInternalName(c)),
  'dashboard:subcategories': ['Category'].map(c => humanToInternalName(c)),
  'dashboard:topics': ['name'].map(c => humanToInternalName(c)),
};

const dashboardCreateTableDDL: Record<string, string> = {
  'dashboard:categories': `
  CREATE TABLE \`dashboard_categories\` (
    \`id\` int NOT NULL AUTO_INCREMENT,
    \`Category\` varchar(256) NOT NULL,
    PRIMARY KEY (\`id\`),
    UNIQUE KEY \`Category_UNIQUE\` (\`Category\`)
  ) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=latin1
  `,

  'dashboard:indicators': `
  CREATE TABLE \`dashboard_indicators\` (
    \`id\` int NOT NULL AUTO_INCREMENT,
    \`wp_id\` int NOT NULL,
    \`slug\` varchar(256) NOT NULL,
    \`Chart_url\` varchar(256) DEFAULT NULL,
    \`link\` varchar(256) DEFAULT NULL,
    \`title\` varchar(256) DEFAULT NULL,
    PRIMARY KEY (\`id\`),
    UNIQUE KEY \`slug_UNIQUE\` (\`slug\`)
  ) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=latin1
  `,

  'dashboard:subcategories': `
  CREATE TABLE \`dashboard_subcategories\` (
    \`id\` int NOT NULL AUTO_INCREMENT,
    \`Category\` varchar(256) NOT NULL,
    PRIMARY KEY (\`id\`),
    UNIQUE KEY \`Category_UNIQUE\` (\`Category\`)
  ) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=latin1
  `,

  'dashboard:topics': `
  CREATE TABLE \`dashboard_topics\` (
    \`id\` int NOT NULL AUTO_INCREMENT,
    \`name\` varchar(255) NOT NULL,
    PRIMARY KEY (\`id\`),
    UNIQUE KEY \`name_UNIQUE\` (\`name\`)
  ) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
  `,
};

const { S3_BUCKET_NAME: bucketName, REGION, SERVICE_TABLE } = process.env;
const s3 = new S3Client({ region: REGION });
const sqs = new SQSClient({ region: REGION });

type CsvProcessCallback = (uploadType: UploadType, record: string[], lnum: number, identifier: string, dryRun: boolean, errors: Error[], clientData: any) => Promise<boolean>;
type PreFunctionCallback = (props: { uploadType: UploadType, record: string[], lnum: number, identifier: string, dryRun: boolean, doTruncateTable?: boolean, errors: Error[], clientData: any }) => Promise<boolean>;

interface TypesConfigElement {
  getContent: boolean;                  // True if we should get the content from S3
  processUploadFunction: ProcessUploadFunction; // The function that processes the upload
  processRowFunction?: CsvProcessCallback; // Called on each row (required if processUploadCSV)
  preFunction?: PreFunctionCallback; // Called before any rows
  postFunction?: CsvProcessCallback; // Called after all rows
}

const typesConfig: { [type: string]: TypesConfigElement } = {
  indicators: {
    getContent: true,
    processUploadFunction: processUploadCSV,
    processRowFunction: processIndicatorsRow,
  },
  assessments: {
    getContent: true,
    processUploadFunction: processUploadCSV,
    processRowFunction: processAssessmentRow,
  },
  general: {
    getContent: true,
    processUploadFunction: processUploadCSV,
    processRowFunction: processGeneralRow,
  },
  dashboard: {
    getContent: true,
    processUploadFunction: processUploadCSV,
    processRowFunction: processGeneralRow,
    preFunction: recreateDashboardTable,
  },
  document: {
    getContent: false,
    processUploadFunction: processUploadDocument,
  },
  unknown: {
    getContent: false,
    processUploadFunction: processUploadUnknown,
  }
}

interface ProcessGeneralRowClientData {
  uploadType: UploadType;
  uploadColumns: string[];
  mangleMap?: {
    nameMaps: NameMapData[];
  }
}

export interface UploadType {
  id: number,
  type: string,
  table: string,
  download_query?: string,

  // Calculated
  columns: Column[],
  indexColumns: string[],
  filters: UploadTypeFilters,
  columnMap: Record<string, string>, // Mapping from real internal column name to external, first converted to internal
  preserve: string[] | undefined,
  valueMaps?: UploadTypeValueMap,
  calc?: UploadTypeCalcSpec,
}

enum ColumnDataType {
  INTEGER, STRING, FLOAT, DOUBLE, ENUM, DATETIME
}

interface Column {
  columnName: string,
  dataType: ColumnDataType,
  isNullable: boolean
}

// Don't cache anything anymore...
// const uploadTypes: Record<string, UploadType> = {}; // key by type
// const columns: Record<string, Column[]> = {}; // key by table

function getDataType(data_type: string): ColumnDataType {
  if (data_type === 'int') return ColumnDataType.INTEGER;
  else if (data_type === 'varchar') return ColumnDataType.STRING;
  else if (data_type === 'float') return ColumnDataType.FLOAT;
  else if (data_type === 'double') return ColumnDataType.DOUBLE;
  else if (data_type === 'enum') return ColumnDataType.ENUM;
  else if (data_type === 'datetime') return ColumnDataType.DATETIME;
  else throw new Error(`unknown data type ${data_type}`);
}

async function getColumns(table: string): Promise<Column[]> {
  // console.log({ message: 'getColumns', table });
  // if (columns[table] != null) {
  //   return columns[table];
  // } else {
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
      isNullable: colRaw.IS_NULLABLE === 'YES',
    }));
    console.log({ message: 'getColumns for UploadType', colsRaw, cols });

    // columns[table] = cols;
    return cols;
  }
  // }
}

export interface TransformFunctionSpec {
  intToExt: (v: string) => string,
  extToInt: (v: string) => string,
};

const transformFunctions: Record<string, TransformFunctionSpec> = {
  // datetime-to-mmyyyy, where datetime looks like "Fri Apr 07 2023 00:00:00 GMT+0000 (Coordinated Universal Time)"
  'datetime-to-mmyyyy': {
    intToExt: (v: string) => {
      const date = new Date(v);
      return `${date.getMonth() + 1}/${date.getFullYear()}`;
    },
    extToInt: (v: string) => {
      const [m, y] = v.split('/');
      return `${y}-${`${m}`.padStart(2, '0')}`;
    },
  },
  mmyyyyswap: {
    intToExt: (v: string) => {
      const [m, y] = v.split('/');
      return `${y}/${m}`;
    },
    extToInt: (v: string) => {
      const [y, m] = v.split('/');
      return `${m}/${y}`;
    },
  },
  'fpl-decimal-to-percent': {
    intToExt: (v: string) => {
      // Convert decimal FPL values to percentage (e.g., "3" -> "300%")
      const numValue = parseFloat(v);
      if (isNaN(numValue)) {
        return v; // Return as-is if not a number
      }
      return `${Math.round(numValue * 100)}%`;
    },
    extToInt: (v: string) => {
      // Convert percentage back to decimal (e.g., "300%" -> "3")
      const percentMatch = v.match(/^(\d+(?:\.\d+)?)%$/);
      if (percentMatch) {
        return `${parseFloat(percentMatch[1]) / 100}`;
      }
      return v; // Return as-is if not a percentage
    },
  },
  'month-number-to-name': {
    intToExt: (v: string) => {
      // Convert month number to month name (e.g., "1" -> "January")
      const monthNumber = parseInt(v);
      if (isNaN(monthNumber) || monthNumber < 1 || monthNumber > 12) {
        return v; // Return as-is if not a valid month number
      }
      const monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return monthNames[monthNumber - 1];
    },
    extToInt: (v: string) => {
      // Convert month name back to number (e.g., "January" -> "1")
      const monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      const monthIndex = monthNames.indexOf(v);
      if (monthIndex !== -1) {
        return `${monthIndex + 1}`;
      }
      return v; // Return as-is if not a valid month name
    },
  }
}

export interface UploadTypeValueMap {
  [columnName: string]: {
    // General mapping function to run. This is run last on the int->ext conversion
    // and first on the ext->int conversion.
    xf?: string, // Transform function

    // Specific values to map
    values?: [{
      int: string,
      ext?: string,
    }],
  }
}

export type UploadTypeCalcSpec = {
  column: string, // "month",
  value: (number | string)[],  // ["substr", 8, 2]
}[];

export interface UploadTypeColumnMap {
  // I'm not sure what these are used for - seems to be about column headers. Example:
  // {
  //   value_w: "School Value"
  //   value_w_st: "State Value"
  //   value_w_susd: "Supervisory Union Value"
  // },
  map?: Record<string, string>,

  // list of columns to preserve
  preserve?: string[], // ["wp_id", "Chart_url", "link", "title"]

  // Value mappings. These are column values to map between internal and external values.
  // For example, "Registered" might be "Registered FCCH" internally.
  valueMaps?: UploadTypeValueMap,

  // Calculated values. These are values that are calculated from other columns. For example,
  // "month" might be calculated from "date" as the month number. These are not expected to
  // be in the uploaded CSV.
  calc?: UploadTypeCalcSpec,
}

export async function getUploadType(type: string): Promise<UploadType> {
  // console.log({ message: 'getUploadType', type, lookup: uploadTypes[type] });
  // if (uploadTypes[type] == null) {
  const types = await doDBQuery('select * from `upload_types` where `type`=?', [type]);
  // console.log({ message: 'getUploadType ret', type: types[0] });
  if (types == null || types.length !== 1) {
    throw new Error(`no types found for type=${type}`);
  } else {
    const uploadTypeRaw: { id: number, type: string, table: string, index_columns: string, column_map?: string, filters?: string, download_query?: string } = types[0];
    // Get the columns list
    const columns = await getColumns(uploadTypeRaw.table);
    const { columnMap, preserve, valueMaps, calc } = (() => {
      let cookedMap: Record<string, string> | undefined = undefined;
      let preserve: Array<string> | undefined = undefined;
      let valueMaps: UploadTypeValueMap | undefined = undefined;
      let calc: UploadTypeCalcSpec | undefined = undefined;

      if (uploadTypeRaw.column_map) {
        const column_map = JSON.parse(uploadTypeRaw.column_map) as UploadTypeColumnMap;
        if (column_map.map) {
          const rawMap = column_map.map;
          cookedMap = {};

          for (const key of Object.keys(rawMap)) {
            cookedMap[key] = humanToInternalName(rawMap[key]);
          }
        }

        if (column_map.preserve) {
          preserve = column_map.preserve;
        }

        if (column_map.valueMaps) {
          valueMaps = column_map.valueMaps;
        }

        if (column_map.calc) {
          calc = column_map.calc;
        }
      }

      return { columnMap: cookedMap, preserve, valueMaps, calc };
    })();

    // console.log({ type, uploadTypeRaw, columns })
    const uploadType = {
      id: uploadTypeRaw.id,
      type: uploadTypeRaw.type,
      table: uploadTypeRaw.table,
      columns,
      columnMap,
      preserve,
      indexColumns: uploadTypeRaw.index_columns.split(',').map(c => c.trim()),
      filters: uploadTypeRaw.filters ? JSON.parse(uploadTypeRaw.filters) : {},
      valueMaps,
      calc,
      download_query: uploadTypeRaw.download_query,
    } as UploadType;

    // uploadTypes[type] = uploadType;
    return uploadType;
  }
  // } else {
  //   return uploadTypes[type];
  // }
}

export function transformValueIntToExt(props: { columnName: string, value: string, uploadType?: UploadType, xf?: string }): string {
  const { columnName, value, uploadType } = props;
  const valueMaps = uploadType?.valueMaps;
  const valueMap = valueMaps?.[columnName];
  let realValue: string = value;

  console.log({ message: 'transformValueIntToExt', columnName, value, valueMap, xf: props.xf, timestamp: new Date().toISOString() });

  if (valueMap) {
    const found = valueMap.values?.find(e => e.int === realValue);
    if (found) {
      realValue = found.ext ?? realValue;
    }

    if (valueMap.xf) {
      const xf = transformFunctions[valueMap.xf];
      if (xf) {
        realValue = xf.intToExt(realValue);
      }
    }
  }

  if (props.xf) {
    const xf = transformFunctions[props.xf];
    if (xf) {
      realValue = xf.intToExt(realValue);
    }
  }

  return realValue;
}

export function transformValueExtToInt(props: { columnName: string, value: string, uploadType?: UploadType, xf?: string }): string {
  const { columnName, value, uploadType } = props;
  const valueMaps = uploadType?.valueMaps;
  const valueMap = valueMaps?.[columnName];
  let realValue: string = value;

  if (props.xf) {
    const xf = transformFunctions[props.xf];
    if (xf) {
      realValue = xf.extToInt(realValue);
    }
  }

  if (valueMap) {
    if (valueMap.xf) {
      const xf = transformFunctions[valueMap.xf];
      if (xf) {
        realValue = xf.extToInt(realValue);
      }
    }

    const found = valueMap.values?.find(e => e.ext === realValue);
    if (found) {
      realValue = found.int;
    }
  }

  return realValue;
}

function humanToInternalName(col: string): string {
  return col.trim().toLowerCase().replace(/ +/g, '_');
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
    const lccolExternal = humanToInternalName(col);
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

// async function mapColumnNamesToInternal(names: string[], createForUnknown: boolean, nameMaps: NameMapData[]): Promise<{ key: string, name: string }[]> {
//   const colsRet: { key: string, name: string }[] = [];

//   for (const name of names) {
//     const foundEntry = nameMaps.find(e => e.name === name);
//     if (foundEntry == null) {
//       if (createForUnknown) {
//         const key = uuidv4();
//         await NameMap.update({ key, name });
//         nameMaps.push({ key, name });
//         colsRet.push({ key, name });
//       }
//     } else {
//       colsRet.push(foundEntry);
//     }
//   }

//   return colsRet;
// }

async function recreateDashboardTable(props: { uploadType: UploadType, record: string[], lnum: number, identifier: string, dryRun: boolean, errors: Error[], doTruncateTable?: boolean, clientData: ProcessGeneralRowClientData }): Promise<boolean> {
  const { uploadType, record, lnum, identifier, dryRun, errors, doTruncateTable, clientData } = props;

  // // Tell the general uploader to mangle the column names
  // clientData.mangleMap = {
  //   nameMaps: await getAllNameMaps()
  // };

  // Check the first row to see if it looks right.
  const allColumnNames = record.map(col => humanToInternalName(col));
  console.log({ message: 'recreateDashboardTable, checking for column names', allColumnNames, uploadType });
  for (const indexCol of uploadType.indexColumns) {
    console.log('checking for index column', indexCol, allColumnNames);
    if (!allColumnNames.includes(humanToInternalName(indexCol))) {
      errors.push(new Error(`missing index column ${indexCol}`));
      return true;
    }
  }

  if (dashboardCreateTableDDL[uploadType.type] == null) {
    console.error({ message: 'no DDL for type', uploadType });
  }

  // Now we just drop and recreate the table
  const table = uploadType.table;
  console.log({ message: 'recreateDashboardTable: dropping table', table });
  await doDBQuery(`DROP TABLE IF EXISTS \`${table}\``);

  // Now create the table
  console.log({ message: 'recreateDashboardTable: re-creating table', table });
  await doDBQuery(dashboardCreateTableDDL[uploadType.type]);

  // Go thru headers and see if there's anything we need to create
  const createCols = record.filter(c => !dashboardFixedColumns[uploadType.type].includes(humanToInternalName(c)));
  console.log({ message: 'recreateDashboardTable: columns to add', createCols });
  if (createCols.length) {
    await doDBQuery(`ALTER TABLE \`${table}\` ` + createCols.map(col => `ADD \`${col}\` INT`).join(', '));
  }

  return false;
}

export async function truncateTable(uploadType: UploadType, record: string[], lnum: number, identifier: string, dryRun: boolean, errors: Error[], clientData: ProcessGeneralRowClientData): Promise<void> {
  const sql = `truncate table ${uploadType.table}`;
  if (dryRun) {
    console.log({ sql });
  } else {
    await doDBQuery(sql);
  }
}

async function processDashboardRow(uploadType: UploadType, record: string[], lnum: number, identifier: string, dryRun: boolean, errors: Error[], clientData: ProcessGeneralRowClientData): Promise<void> {
}

function fixGeneralValue(v: string): string {
  // If it looks like a number, strip any commas; if it looks like an mm/dd/yyyy date, convert to yyyy-mm-dd
  if (v.match(/^-?[\d,.]+$/)) {
    return v.replace(/,/g, '');
  } else if (v.match(/^\d{1,2}\/\d{1,2}\/\d{4}$/)) {
    const [m, d, y] = v.split('/');
    return `${y}-${m.padStart(2, '0')}-${d.padStart(2, '0')}`;
  } else {
    return v;
  }
}

function getValue(keys: string[], values: string[], readColumn: string): string {
  const index = keys.indexOf(readColumn);
  if (index < 0) {
    throw new Error(`unknown column ${readColumn}`);
  } else {
    return fixGeneralValue(values[index]);
  }
}

function calcValue(col: string, keys: string[], values: string[], uploadType: UploadType): string {
  const calcColumns = uploadType.calc ?? [];
  const calcSpec = calcColumns.find(c => c.column === col);
  console.log({ message: 'calcValue', col, keys, values, calcSpec });
  if (calcSpec) {
    const [fn, ...args] = calcSpec.value;
    if (fn === 'substr') {
      const [readColumnRaw, startRaw, lenRaw] = args;
      const readColumn = `${readColumnRaw}`;
      const len = parseInt(`${lenRaw}`);
      const start = parseInt(`${startRaw}`);
      return getValue(keys, values, readColumn).substring(start, start + len);
    } else if (fn === 'yearof') {
      const [readColumnRaw] = args;
      const readColumn = `${readColumnRaw}`;
      const date = new Date(getValue(keys, values, readColumn));
      return `${date.getFullYear()}`;
    } else if (fn === 'monthof') {
      const [readColumnRaw] = args;
      const readColumn = `${readColumnRaw}`;
      const date = new Date(getValue(keys, values, readColumn));
      return `${date.getMonth() + 1}`;
    } else {
      throw new Error(`unknown calc function ${fn}`);
    }
  } else {
    // Just return the value
    return values[keys.indexOf(col)];
  }
}

async function processGeneralRow(uploadType: UploadType, record: string[], lnum: number, identifier: string, dryRun: boolean, errors: Error[], clientData: ProcessGeneralRowClientData): Promise<boolean> {
  // console.log({ message: 'processGeneralRow start', type, record, lnum });
  if (lnum === 1) {
    // Assume this has the column names. Check against the value ones for this type. But first we need to look it up...
    // const uploadType = await getUploadType(type);

    // Get rid of possible BOM. Stupid Excel.
    if (record[0].startsWith("\ufeff")) {
      console.log('It has a BOM! Stupid Excel. Stripping it...');
      record[0] = record[0].substring(1);
    }

    const calcColumns = uploadType.calc ?? [];
    const uploadColumns = uploadType.columns.filter(c => !calcColumns.some(cc => cc.column == c.columnName));

    // Check the columns. We might we more lenient at some point, but right now they have to
    // match exactly. Note we should get one less, no id column. Also don't count calulated
    // columns.
    if (record.length !== uploadColumns.length - 1) {
      throw new Error(`wrong number of columns for type ${uploadType.type}; expected ${JSON.stringify(Object.values(uploadType.columns).map(v => v.columnName))} got ${JSON.stringify(record)}; calc columns ${JSON.stringify(calcColumns)}`);
    }

    const tableColumns = uploadType.columns.map(c => c.columnName);

    const { matchedColumns, unmatchedColumns } = matchColumns(record, uploadType);
    // console.log({ record, cols: uploadType.columns, unmatchedColumns, matchedColumns });

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

    // Add the calc columns
    const uploadColumns = clientData.uploadColumns;
    const calcColumns = uploadType.calc ?? [];
    const calcValues = calcColumns.map(calcColumn => calcValue(calcColumn.column, uploadColumns, record, uploadType));

    // Get the basic updates
    const updates = clientData.uploadColumns.filter(c => !clientData.uploadType.indexColumns.includes(c)).map(c => `\`${c}\`=?`);

    // Add in the calc columns
    for (let i = 0; i < calcColumns.length; i++) {
      updates.push(`\`${calcColumns[i].column}\`=?`);
    }

    if (updates.length === 0) {
      updates.push('`id`=`id`');
    }

    // Mangle column names if necessary
    // const insertCols = clientData.mangleMap ?
    //   await mapColumnNamesToInternal(clientData.uploadColumns, true, clientData.mangleMap.nameMaps) :
    //   clientData.uploadColumns;
    const sql = `insert into \`${clientData.uploadType.table}\` (` +
      [...uploadColumns, ...(calcColumns.map(c => c.column))].map(c => `\`${c}\``).join(',') +
      `) values (` +
      [...record.map(v => '?'), ...(calcColumns.map(c => '?'))].join(',') +
      `) on duplicate key update ` +
      updates.join(',');

    const values = ((uploadColumns, indexColumns) => {
      console.log({ indexColumns, uploadColumns });

      const inserts: string[] = [];
      const updates: string[] = [];

      for (let i = 0; i < record.length; i++) {
        // First set the insert values, then the update ones
        const finalValue = fixGeneralValue(record[i]);
        inserts.push(finalValue);

        if (!indexColumns.includes(uploadColumns[i])) {
          updates.push(finalValue);
        }
      }

      // Add extra inserts and updates for calculated columns
      inserts.push(...calcValues);
      updates.push(...calcValues);

      return [...inserts, ...updates];
    })(clientData.uploadColumns, clientData.uploadType.indexColumns);

    if (dryRun) {
      console.log({ sql, values });
    } else {
      await doDBQuery(sql, values);
    }
  }

  return false;
}

async function processIndicatorsRow(type: UploadType, record: string[], lnum: number, identifier: string, dryRun: boolean, errors: Error[], clientData: any): Promise<boolean> {
  if (lnum === 1) {
    // First row, the column headers are important because they give the topics (or sub-topics).
    // But this is only from column F on. The other columns should be fixed, so we will validate
    // them.
    clientData

  } else {

  }
  return false;
}

async function processAssessmentRow(type: UploadType, record: string[], lnum: number, identifier: string, dryRun: boolean, errors: Error[], clientData: any): Promise<boolean> {
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
      value_w_susd: (record[8] == '' || record[8] == 'NULL') ? null : parseFloat(record[8]),
    };
    await doDBQuery(
      `insert into data_assessments (sy, org_id, test_name, indicator_label, assess_group, assess_label, value_w, value_w_st, value_w_susd) 
            values (?, ?, ?, ?, ?, ?, ?, ?, ?) \
            on duplicate key update \
            sy=?, org_id=?, test_name=?, indicator_label=?, assess_group=?, assess_label=?, value_w=?, value_w_st=?, value_w_susd=?`,
      [
        values.sy, values.org_id, values.test_name, values.indicator_label, values.assess_group, values.assess_label, values.value_w, values.value_w_st, values.value_w_susd,
        values.sy, values.org_id, values.test_name, values.indicator_label, values.assess_group, values.assess_label, values.value_w, values.value_w_st, values.value_w_susd,
      ],
    );
  }

  return false;
}

enum LockAction {
  Lock,
  Unlock
}

async function updateStatus(id: string, status: string, percent: number, numRecords: number, errors: Error[], lockAction?: LockAction): Promise<UpdateCommandOutput> {
  const data = {
    id,
    status,
    numRecords,
    percent,
    errors: errors?.map(e => e.message) ?? [],
    lastUpdated: new Date().toISOString(),
  };

  if (lockAction === LockAction.Lock) {
    return UploadStatus.update({
      ...data,
      locked: true,
    }, {
      conditions: [{
        attr: 'locked',
        exists: false,
      }],
    });
  } else {
    return UploadStatus.update({
      ...data,
      ...(lockAction === LockAction.Unlock ? { $remove: 'locked' } : {}),
    });
  }
}

type ProcessUploadFunction = (props: {
  bodyContents: string | S3Ref | undefined,
  identifier: string,
  uploadType: string,
  dryRun?: boolean,
  doTruncateTable?: boolean,
  updateUploadStatus?: boolean,
  tags: { [key: string]: string },
}) => Promise<{
  errors: Error[],
  saveTotal: number,
  statusUpdatePct: number,
}>;

// validate that bodycontents is an S3Ref
function isS3Ref(bodyContents: string | S3Ref | undefined): bodyContents is S3Ref {
  return (bodyContents as S3Ref).Bucket !== undefined && (bodyContents as S3Ref).Key !== undefined;
}

export async function processUploadDocument(props: {
  bodyContents: string | S3Ref | undefined,
  identifier: string,
  uploadType: string,
  dryRun?: boolean,
  doTruncateTable?: boolean,
  updateUploadStatus?: boolean,
  tags: { [key: string]: string },
}): Promise<{
  errors: Error[],
  saveTotal: number,
  statusUpdatePct: number,
}> {
  const { uploadType: uploadTypeStr, bodyContents, dryRun, identifier, updateUploadStatus, tags } = props;
  if (!isS3Ref(bodyContents)) {
    await updateStatus(identifier, 'Error', 0, 0, [new Error('do not have S3Ref for document upload')]);
    throw new Error('no body contents');
  }

  await Document.put({
    identifier,
    bucket: bodyContents.Bucket,
    key: bodyContents.Key,
    tags,
  });

  return {
    errors: [], saveTotal: 1, statusUpdatePct: 100
  };
}

export async function processUploadUnknown(props: {
  bodyContents: string | S3Ref | undefined,
  identifier: string,
  uploadType: string,
  dryRun?: boolean,
  doTruncateTable?: boolean,
  updateUploadStatus?: boolean,
  tags: { [key: string]: string },
}): Promise<{
  errors: Error[],
  saveTotal: number,
  statusUpdatePct: number,
}> {
  const { identifier } = props;
  
  // For unknown types, we'll mark the upload as failed with a descriptive error
  const error = new Error(`Upload failed: Unknown file type. Please ensure the file has proper type tags set. Valid types are: ${Object.keys(typesConfig).filter(k => k !== 'unknown').join(', ')}`);
  
  await updateStatus(identifier, 'Error', 0, 0, [error]);
  
  return {
    errors: [error],
    saveTotal: 0,
    statusUpdatePct: 100
  };
}

export async function processUploadCSVRow({
  record,
  lnum,
  total,
  preFunction,
  postFunction,
  uploadTypeStr,
  identifier,
  dryRun,
  errors,
  clientData,
  doTruncateTable,
  updateUploadStatus,
  processRowFunction
}: {
  record: string[],
  lnum: number,
  total: number,
  preFunction?: PreFunctionCallback,
  postFunction?: CsvProcessCallback,
  uploadTypeStr: string,
  identifier: string,
  dryRun: boolean,
  errors: Error[],
  clientData: any,
  doTruncateTable?: boolean,
  updateUploadStatus?: boolean,
  processRowFunction?: any
}) {
  console.log({ message: 'row', index: lnum, record });

  let statusUpdatePct = 0;
  let lastStatusUpdatePct = 0;

  // Get it the first time
  let uploadType = clientData.uploadType as UploadType ?? await getUploadType(uploadTypeStr);

  if (lnum === 1 && preFunction) {
    console.log({ message: 'executing pre-function' });

    const quit = await preFunction({ uploadType, record, lnum, identifier, dryRun, errors, clientData, doTruncateTable });
    if (quit) {
      return quit;
    }

    // The preFunction may have changed the upload type, we need to re-evaluate it
    clientData.uploadType = await getUploadType(uploadTypeStr);

    // Start by truncating the table if requested. We only do this if the preFunction returns OK.
    if (doTruncateTable) {
      await truncateTable(uploadType, [], 0, identifier, dryRun, errors, clientData);
    }
  }
  
  if (processRowFunction) {
    await processRowFunction(uploadType, record, lnum, identifier, dryRun, errors, clientData);
  }
  
  if (lnum === total && postFunction) {
    console.log({ message: 'executing post-function' });

    await postFunction(uploadType, record, lnum, identifier, dryRun, errors, clientData);
  }

  // Update status every 10%
  statusUpdatePct = Math.round(100 * lnum / total);
  if (Math.floor(lastStatusUpdatePct / 10) != Math.floor(statusUpdatePct / 10)) {
    lastStatusUpdatePct = statusUpdatePct;
    if (updateUploadStatus) {
      await updateStatus(identifier, 'In progress', statusUpdatePct, total, []);
    }
  }

  return false;
}

/**
 * Really process an upload, from whatever source.
 * @param props 
 * @returns Errors, total number of records saved, and the last update percentage
 */
export async function processUploadCSV(props: {
  bodyContents: string | S3Ref | undefined,
  identifier: string,
  uploadType: string,
  dryRun?: boolean,
  doTruncateTable?: boolean, // overrides
  updateUploadStatus?: boolean,
}): Promise<{
  errors: Error[],
  saveTotal: number,
  statusUpdatePct: number,
}> {
  const { uploadType: uploadTypeStr, bodyContents, dryRun, identifier, updateUploadStatus, doTruncateTable } = props;

  // This requires bodyContents to be passed
  if (typeof bodyContents !== 'string') {
    await updateStatus(identifier, 'Error', 0, 0, [new Error('body contents must be a string for CSV')]);
    throw new Error('no body contents');
  }

  console.log('opening connection');
  await doDBOpen();
  console.log('connection open');

  // We will re-evaluate this after the preFunction
  let uploadType = await getUploadType(uploadTypeStr);

  // Assume the type has two pieces separated by a colon
  // - the typesConfig value
  // - the rest of it, depends on the typesConfig value
  const { typePrefix, typeConfig } = await getTypeConfig(uploadTypeStr, identifier);
  const { processRowFunction, preFunction, postFunction } = typeConfig;

  // If we get here we need a processRowFunction defined
  if (!processRowFunction) {
    await updateStatus(identifier, 'Error', 0, 0, [new Error(`type prefix ${typePrefix} requires processRowFunction`)]);
    throw new Error(`type prefix ${typePrefix} requires processRowFunction`);
  }

  const errors: Error[] = []
  let saveTotal = 0;
  let statusUpdatePct = 0;
  let lastStatusUpdatePct = 0;
  try {
    // Client data - handlers can put anything they want in there
    const clientData: any = {};

    // Parse CSV first to get total count
    const records: string[][] = await parseCSV(bodyContents);
    saveTotal = records.length;

    await processCSV(bodyContents, uploadType, (record, lnum, total) => {
      // Update progress tracking
      statusUpdatePct = Math.round(100 * lnum / total);
      
      return processUploadCSVRow({
        record,
        lnum,
        total,
        preFunction,
        postFunction,
        uploadTypeStr,
        identifier,
        dryRun: dryRun ?? false,
        errors,
        clientData,
        doTruncateTable,
        updateUploadStatus,
        processRowFunction
      });
    });

    // Update the last upload timestamp
    const now = new Date();
    const timestamp = now.toISOString();

    await doDBQuery(
      'update upload_types set `last_upload`=? where `type`=?',
      [
        timestamp,
        uploadTypeStr,
      ],
    );

    await doDBCommit();
    
    // Set final status - 100% complete if no errors, otherwise error status
    statusUpdatePct = 100;
    if (updateUploadStatus) {
      await updateStatus(identifier, (errors.length == 0 ? 'Complete' : 'Error'), statusUpdatePct, saveTotal, errors, LockAction.Unlock);
    }
  } catch (e) {
    console.error(e);
    errors.push(e as Error);
    
    // Set error status if we caught an exception
    if (updateUploadStatus) {
      await updateStatus(identifier, 'Error', statusUpdatePct, saveTotal, errors, LockAction.Unlock);
    }
  } finally {
    await doDBClose();
  }

  return { errors, saveTotal, statusUpdatePct };
}

const UNKNOWN = 'unknown';

interface S3Ref {
  Bucket: string,
  Key: string,
}

interface UploadInfo {
  tags: { [key: string]: string },
  bodyContents: string | S3Ref | undefined,
  contentType: string | undefined,
}

async function getTypeConfig(type: string, identifier: string): Promise<{
  typePrefix: string,
  typeConfig: TypesConfigElement
}> {
  const typePrefix = type.includes(':') ? type.substring(0, type.indexOf(':')) : type;
  const typeConfig = typesConfig[typePrefix];
  if (!typeConfig) {
    await updateStatus(identifier, 'Error', 0, 0, [new Error(`unknown type prefix ${typePrefix}`)]);
    throw new Error(`unknown type prefix ${typePrefix}`);
  }

  return { typePrefix, typeConfig };
}

async function getUploadFile(props: {
  bucket: string,
  key: string,
}): Promise<UploadInfo> {
  const { bucket, key } = props;

  const params = {
    Bucket: bucket,
    Key: key,
  };
  console.log('params', params);

  const tags: { [key: string]: string } = {};
  let bodyContents: string | S3Ref | undefined = undefined;
  let contentType: string | undefined = undefined;
  for (let i = 0; i < 5; i++) {
    try {
      const { TagSet } = await s3.send(new GetObjectTaggingCommand(params));
      console.log('TAGS:', TagSet);
      if (TagSet != null) {
        TagSet.forEach(tag => {
          const tagKey = tag.Key?.toLowerCase() ?? UNKNOWN;
          // Ignore the 'ai-processed' tag - this tag is used to mark files that have been processed by AI
          // but should not affect the upload processing logic
          if (tagKey !== 'ai-processed') {
            tags[tagKey] = tag.Value?.toLowerCase() ?? UNKNOWN;
          }
        });
      }

      // Look up the type tag as an uploadType prefix; only get the content if we're supposed to
      const { typeConfig } = await getTypeConfig(tags.type ?? UNKNOWN, tags.identifier ?? UNKNOWN);

      if (typeConfig.getContent) {
        await s3.send(new GetObjectCommand(params));
        const { ContentType, Body } = await s3.send(new GetObjectCommand(params));
        console.log('CONTENT TYPE:', ContentType);
        contentType = ContentType;
        bodyContents = await Body?.transformToString();
      } else {
        bodyContents = params;
      }

      break;
    } catch (e) {
      console.error(e);
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }

  return { tags, bodyContents, contentType };
}

export interface S3EventBody {
  Records: S3EventRecord[]
}

export interface S3EventRecord {
  eventVersion: string
  eventSource: string
  awsRegion: string
  eventTime: string
  eventName: string
  userIdentity: UserIdentity
  requestParameters: RequestParameters
  responseElements: ResponseElements
  s3: S3
}

export interface UserIdentity {
  principalId: string
}

export interface RequestParameters {
  sourceIPAddress: string
}

export interface ResponseElements {
  "x-amz-request-id": string
  "x-amz-id-2": string
}

export interface S3 {
  s3SchemaVersion: string
  configurationId: string
  bucket: Bucket
  object: Object
}

export interface Bucket {
  name: string
  ownerIdentity: OwnerIdentity
  arn: string
}

export interface OwnerIdentity {
  principalId: string
}

export interface Object {
  key: string
  eTag: string
}

export async function main(
  event: SQSEvent,
): Promise<string> {
  console.log(`S3_BUCKET_NAME=${bucketName}, REGION=${REGION}, event 👉`, event);

  const body = JSON.parse(event.Records[0].body) as S3EventBody;
  const record = body.Records[0];
  console.log({ message: `record`, record });
  const bucket = record.s3.bucket.name;
  const key = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));

  // Try it a few times, might be a delay in the file being available in S3. After that,
  // I'm not sure why it should fail, but we'll log it as the status anyway.
  const { bodyContents, contentType, tags } = await getUploadFile({ bucket, key });

  // Get the identifier. Just create a UUID if one not provided like it should be.
  const identifier = tags.identifier || uuidv4();

  if (tags.type == null) {
    await updateStatus(tags.identifier ?? UNKNOWN, 'Error', 0, 0, [new Error(`missing type from upload`)]);
    return UNKNOWN;
  }

  // Everything else, we'll just write a generic error status
  try {
    console.log(`set in progress ${identifier}`);
    await updateStatus(identifier, 'In progress', 0, 0, [], LockAction.Lock);

    // Get the upload type. We'll need it later for multiple purposes
    const uploadType = tags.type;
    const { typeConfig } = await getTypeConfig(uploadType, identifier);
    const { errors, saveTotal, statusUpdatePct } = await typeConfig.processUploadFunction({
      bodyContents,
      uploadType,
      identifier,
      dryRun: false,
      updateUploadStatus: true,
      tags,
    });

    await updateStatus(identifier, (errors.length == 0 ? 'Complete' : 'Error'), statusUpdatePct, saveTotal, errors, LockAction.Unlock);

    // When an upload completes, write a record to the upload backup queue so a backup can be made
    const queueUrl = process.env.DATASET_BACKUP_QUEUE_URL;
    if (queueUrl) {
      const datasetVersionData: DatasetVersionData = {
        dataset: uploadType,
        version: new Date().toISOString(),
        status: STATUS_DATASET_VERSION_QUEUED,
        identifier,
      } as DatasetVersionData;

      await DatasetVersion.update(datasetVersionData);

      const queueResp = await sqs.send(new SendMessageCommand({
        QueueUrl: queueUrl,
        MessageBody: JSON.stringify({
          dataset: datasetVersionData.dataset,
          version: datasetVersionData.version,
          identifier,
        }),
      }));

      console.log({ message: 'backup queue response', queueResp });
    }

  } catch (e) {
    const error = e as Error;
    console.error(error);
    await updateStatus(tags.identifier ?? UNKNOWN, 'Error', 0, 0, [error], LockAction.Unlock);
  }

  return contentType || UNKNOWN;
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

async function processCSV(recordsString: string, uploadType: UploadType, callback: (record: string[], index: number, total: number) => Promise<boolean>): Promise<boolean> {
  // First parse into array. Hopefully there are not too many!
  const records: string[][] = await parseCSV(recordsString);

  // Now process the records
  console.log(`number of records: ${records.length}`);
  let quit = false;
  for (let i = 0; i < records.length; i++) {
    quit = await callback(records[i], i + 1, records.length);
    if (quit) {
      break;
    }
  }

  return quit;
}

if (!module.parent) {
  (async () => {
    console.log('opening connection');
    try {
      await doDBOpen();
      console.log('connection open');
      for (const t of [
        { t: 'dashboard:categories', c: 'Category,Topics,Goals,Geographies' },
        { t: 'dashboard:indicators', c: 'wp_id,slug,Chart_url,link,title,BN:Cost of living,BN:Housing,BN:Food security and nutrition,BN:Financial assistance,Housing:Housing,Demographic:Living arrangements,Demographics:Population,Econ:Cost of living,Econ:Financial assistance,Econ:Economic impact,Child Care:Access,Child development:Service access and utilization,Child development:Standardized tests and screening,Education:Standardized tests,Education:Student characteristics,Mental health:Access,Mental health:Prevalence,PH:Mental health,PH:Access and utilization,PH:Food security and nutrition,PH:Perinatal health,R:Food security and nutrition,R:Housing,R:Cost of living,R:Mental health,R:Other environmental factors,R:Social and emotional,UPK:Access and utilization,UPK:Standardized tests,Workforce:Paid Leave,Geo_state,Geo_AHS_District,Geo_County,Geo_SU_SD,Geo_HSA,Goal 1 (healthy start),Goal 2 (families and comm),Goal 3 (opportunties),Goal 4 (integrated/resource/data-drive)' },
        { t: 'dashboard:subcategories', c: 'Category,Basic Needs,Child Care,Child Development,Demographics,Economics,Education,Housing,Mental Health,Physical Health,Resilience,UPK,Workforce' },
        { t: 'dashboard:topics', c: 'name' },
      ]) {
        const uploadType = await getUploadType(t.t);
        if (typeof uploadType === 'string') {
          throw new Error(uploadType);
        }

        console.log(uploadType);
        // await recreateDashboardTable(uploadType, t.c.split(','), 1, 'foo', false, [], { uploadType, uploadColumns: [] });
      }
      //       const bodyContents = `SY,Org id,Test Name,Indicator Label,Assess Group,Assess Label,School Value,Supervisory Union Value,State Value
      // 2021,VT001,SB English Language Arts Grade 03,Total Proficient and Above,All Students,All Students,,,0.425
      // 2021,VT001,SB English Language Arts Grade 03,Total Proficient and Above,Disability,No Special Ed,,,0.485
      // `;
      //       const uploadType = await getUploadType('general:assessments');

      //       const { errors, saveTotal, statusUpdatePct } = await processUpload({
      //         bodyContents,
      //         typeConfig: typesConfig['general'],
      //         uploadType,
      //         identifier: '12345',
      //         dryRun: false,
      //       });
      //       console.log({ errors, saveTotal, statusUpdatePct });
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
