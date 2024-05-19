import { Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { GetSecretValueCommand, SecretsManagerClient } from "@aws-sdk/client-secrets-manager";
import { DynamoDBDocumentClient, QueryCommandOutput } from '@aws-sdk/lib-dynamodb';
import { Entity, Table } from 'dynamodb-toolbox';
import * as mysql from 'mysql';

const ALL_UPLOAD_STATUS = 'ALL_UPLOAD_STATUS';
const ALL_SESSIONS = 'ALL_SESSIONS';
const ALL_DATASET_VERSIONS = 'ALL_DATASET_VERSIONS';
const ALL_NAME_MAPS = 'ALL_NAME_MAPS';

const { NAMESPACE, LOG_LEVEL } = process.env;

// Set your service name. This comes out in service lens etc.
const serviceName = `queries-api-getList-${NAMESPACE}`;
const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});

function getRegion(): string {
  return process.env.REGION || 'us-east-1';
}

function getNamespace(): string {
  if (process.env.NAMESPACE) return process.env.NAMESPACE;
  else throw new Error("process.env.NAMESPACE not passed");
}

export interface DBSecret {
  host: string;
  username: string;
  password: string;
  schema: string;
}

// Cached DB Secret and connection
const secret: DBSecret | undefined = undefined;
let cachedConnection: mysql.Connection | undefined = undefined;
const smClient = new SecretsManagerClient({ region: 'us-east-1' });

export function getCachedConnection(): mysql.Connection | undefined {
  return cachedConnection;
}

export async function getDBSecret(): Promise<DBSecret> {
  logger.debug({ message: 'getDBSecret, secret', secret })
  if (secret) return secret;
  else {
    const SecretId = process.env.DB_SECRET_NAME;
    
    logger.debug({ message: 'getDBSecret, get SecretsManagerClient' });
    logger.debug({ message: 'getDBSecret, SecretId', SecretId })

    // Get secret connection info
    try {
      logger.debug({ message: 'getDBSecret, trying' });

      const secrets = await smClient.send(new GetSecretValueCommand({
        SecretId,
      }));
      logger.debug({ message: 'getDBSecret, got secrets', secrets });

      const secretString = secrets.SecretString;
      logger.debug({ message: 'getDBSecret, got secret string', secretString })
      if (secretString == null) {
        logger.debug({ message: 'get secret info not found', SecretId })
        throw new Error('DB connection info not found');
      } else {
        logger.debug({ message: 'get secret info', secrets })
        const info: DBSecret = JSON.parse(secretString);
        if (info.host == null || info.username == null || info.password == null || info.schema == null) {
          throw new Error(`Secret ${SecretId}: missing some DB information`);
        } else {
          return info;
        }
      }

    } catch (err) {
      console.error({ message: 'exception getting secret!' });
      console.error({ err });
      throw err;
    }

  }
}

export async function doDBCommit(): Promise<void> {
  if (cachedConnection) {
    cachedConnection.commit();
  } else {
    throw new Error('no db connection to commit');
  }
}

export async function doDBClose(): Promise<void> {
  if (cachedConnection) {
    cachedConnection.end();
    cachedConnection = undefined;
  }
}

export async function doDBInsert(sql: string, values?: any[]): Promise<number> {
  const conn = cachedConnection;
  if (conn) {
    if (values == null) values = [];
    return new Promise<any>((resolve, reject) => {
      return conn.query(sql, values, (err, results /*, fields*/) => {
        if (err) {
          reject(err);
        } else {
          resolve(results.insertId);
        }
      })
    });
  } else {
    throw new Error('no DB connection');
  }
}

export async function doDBQuery(sql: string, values?: any[]): Promise<any[]> {
  logger.info({ message: `doDBQuery query`, sql, values });
  const conn = cachedConnection;
  if (conn) {
    if (values == null) values = [];
    return new Promise<any>((resolve, reject) => {
      return conn.query(sql, values, (err, results /*, fields*/) => {
        // logger.debug({message:`doDBQuery query ret`, err, results});
        if (err) {
          reject(err);
        } else {
          // logger.debug({message:`doDBQuery query resolve`, rez: util.inspect(results)});
          // logger.debug({message:`doDBQuery query col`, rez: results[0].COLUMN_NAME});
          resolve(results);
        }
      })
    });
  } else {
    throw new Error('no DB connection');
  }
}

export async function doDBOpen(): Promise<void> {
  logger.debug({ message: 'doDBOpen start', cachedConnection })
  if (!cachedConnection) {
    const info = await getDBSecret();
    logger.debug({ message: 'got secret', info });
    cachedConnection = mysql.createConnection({
      host: info.host,
      user: info.username,
      password: info.password,
    });
    await doDBQuery(`use ${info.schema}`);
    // logger.debug({message: 'doOpen: opened connection', schema: info.schema });
  }
}

export async function queryDB(sqlText: string, params?: any[]): Promise<any[]> {
  const connectInfo = await getDBSecret();

  // Get secret connection info
  const connection = mysql.createConnection({
    host: connectInfo.host,
    user: connectInfo.username,
    password: connectInfo.password,
  });

  return new Promise<any[]>((resolve, reject) => {
    connection.connect((err?: Error) => {
      if (err) {
        reject('error connecting: ' + err);
      } else {
        connection.query(`use ${connectInfo.schema}`, (err: mysql.MysqlError | null, results: any[], fields: any) => {
          if (err) {
            connection.end((err: any) => { if (err) console.error(err) });
            reject('error setting db: ' + err);
          } else {
            connection.query(sqlText, params, (err: mysql.MysqlError | null, results: any[], fields: any) => {
              connection.end((err: any) => { if (err) console.error(err) });

              if (err) {
                reject('error querying: ' + err);
              } else {
                resolve(results);
              }
            });
          }
        })
      }
    })
  })
}

export const serviceTable = new Table({
  name: process.env.SERVICE_TABLE!,

  partitionKey: 'PK',
  sortKey: 'SK',

  indexes: {
    GSI1: {
      partitionKey: 'GSI1PK',
      sortKey: 'GSI1SK',
    },
    GSI2: {
      partitionKey: 'GSI2PK',
      sortKey: 'GSI2SK',
    },
  },

  DocumentClient: DynamoDBDocumentClient.from(new DynamoDBClient({ region: getRegion() })),
});

export function getUploadStatusKeyAttribute(id: string): string {
  return `UPLOADSTATUS#${id}`;
}

export function getUploadStatusKey(id: string): { PK: string, SK: string } {
  return {
    PK: getUploadStatusKeyAttribute(id),
    SK: getUploadStatusKeyAttribute(id),
  };
}

export function getSessionKeyAttribute(id: string): string {
  return `SESSION#${id}`;
}

export function getSessionKey(id: string): { PK: string, SK: string } {
  return {
    PK: getSessionKeyAttribute(id),
    SK: getSessionKeyAttribute(id),
  };
}

export interface UploadStatusData {
  id: string,
  status?: string,
  numRecords?: number,
  percent?: number,
  errors?: string[],
  locked?: boolean,
  lastUpdated?: string,
}

export const UploadStatus = new Entity({
  name: 'UploadStatus',
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { id: string }) => getUploadStatusKeyAttribute(data.id) },
    SK: { sortKey: true, hidden: true, default: (data: { id: string }) => getUploadStatusKeyAttribute(data.id) },
    GSI1PK: { hidden: true, default: (data: { id: string }) => ALL_UPLOAD_STATUS },
    GSI1SK: { hidden: true, default: (data: { id: string }) => getUploadStatusKeyAttribute(data.id) },

    id: { type: 'string', required: true },
    status: { type: 'string' },
    numRecords: { type: 'number' },
    percent: { type: 'number' },
    errors: { type: 'list' },
    locked: { type: 'boolean' },
    lastUpdated: { type: 'string' },
  },
  table: serviceTable,
});

export function getNameMapKeyAttribute(name: string): string {
  return `NAMEMAPKEY#${name}`;
}

export interface NameMapData {
  key: string,
  name: string,
}

export const NameMap = new Entity({
  name: 'NameMap',
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { key: string }) => getNameMapKeyAttribute(data.key) },
    SK: { sortKey: true, hidden: true, default: () => '$' },
    GSI1PK: { hidden: true, default: () => ALL_NAME_MAPS },
    GSI1SK: { hidden: true, default: (data: { key: string }) => getNameMapKeyAttribute(data.key) },

    key: { type: 'string', required: true },
    name: { type: 'string', required: true },
  },
  table: serviceTable,
});

export interface SessionData {
  session_id: string,
  domain: string,
  access_token: string,
  id_token: string,
  refresh_token: string,
  timestamp: string,
  TTL: number,
}

export const Session = new Entity({
  name: 'Session',
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { session_id: string }) => getSessionKeyAttribute(data.session_id) },
    SK: { sortKey: true, hidden: true, default: (data: { session_id: string }) => getSessionKeyAttribute(data.session_id) },
    GSI1PK: { hidden: true, default: (data: { id: string }) => ALL_SESSIONS },
    GSI1SK: { hidden: true, default: (data: { session_id: string }) => getSessionKeyAttribute(data.session_id) },

    session_id: { type: 'string', required: true },
    domain: { type: 'string', required: true },
    access_token: { type: 'string', required: true },
    id_token: { type: 'string', required: true },
    refresh_token: { type: 'string', required: true },
    timestamp: { type: 'string', required: true, default: () => new Date().toISOString() },
    TTL: { type: 'number', required: true },
  },
  table: serviceTable,
});

export function getDatasetKeyPrefix(): string {
  return `DATASET#`;
}

export function getDatasetKeyAttribute(id: string): string {
  return `${getDatasetKeyPrefix()}${id}`;
}

export function getDatasetKey(id: string): { PK: string, SK: string } {
  return {
    PK: getDatasetKeyAttribute(id),
    SK: getDatasetKeyAttribute(id),
  };
}

export function getVersionKeyPrefix(): string {
  return `VERSION#`;
}

export function getVersionKeyAttribute(version: string): string {
  return `${getVersionKeyPrefix()}${version}`;
}

export const STATUS_DATASET_VERSION_QUEUED = 'QUEUED';
export const STATUS_DATASET_VERSION_RUNNING = 'RUNNING';
export const STATUS_DATASET_VERSION_SUCCESS = 'SUCCESS';

export const DatasetVersion = new Entity({
  name: 'DatasetVersion',
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { dataset: string }) => getDatasetKeyAttribute(data.dataset) },
    SK: { sortKey: true, hidden: true, default: (data: { version: string }) => getVersionKeyAttribute(data.version) },
    GSI1PK: { hidden: true, default: () => ALL_DATASET_VERSIONS },
    GSI1SK: {
      hidden: true, default: (data: { dataset: string, version: string }) =>
        getDatasetKeyAttribute(data.dataset) + '#' + getVersionKeyAttribute(data.version),
    },

    dataset: { type: 'string', required: true },
    version: { type: 'string', required: true },
    identifier: { type: 'string', required: true },
    status: { type: 'string', required: true }, // QUEUED, RUNNING, SUCCESS

    s3key: { type: 'string' },
    numrows: { type: 'number' },
  },
  table: serviceTable,
});

export function getDatasetVersionKey(dataset: string, version: string): { PK: string, SK: string } {
  return {
    PK: getDatasetKeyAttribute(dataset),
    SK: getVersionKeyAttribute(version),
  };
}

export interface DatasetVersionData {
  dataset: string,
  version: string,
  identifier: string,
  status: string,
  s3key?: string,
  numrows?: number,
}

export function getConversationKeyAttribute(id: string): string {
  return `CONV#${id}`;
}

// Define a completion
export const Completion = new Entity({
  name: 'Completion',
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { id: string }) => getConversationKeyAttribute(data.id) },
    SK: { sortKey: true, hidden: true, default: (data: { sortKey: number }) => `SORT#${data.sortKey}` },

    id: { type: 'string', required: true },
    sortKey: { type: 'number', required: true },

    status: { type: 'string', required: true },
    message: { type: 'string' },
    query: { type: 'string' },
    thread: { type: 'map' }, // Same for all messages in a conversation
  },

  table: serviceTable,
});

export function getCompletionPK(id: string, sortKey: number): {PK: string, SK: string} {
  return {
    PK: getConversationKeyAttribute(id),
    SK: `SORT#${sortKey}`,
  };
}

async function forEachThing<T extends Record<string, any>>(
  init: () => Promise<QueryCommandOutput>,
  callback: (thing: T) => Promise<void>,
): Promise<void[]> {
  const returnPromises: Promise<void>[] = [];

  const things: QueryCommandOutput & { next?: () => Promise<void> } =
    await init();

  for (; ;) {
    if (things.Items == null) {
      break;
    }

    for (const district of things.Items) {
      // logger.info({ message: 'each district', district });
      returnPromises.push(callback(district as T));
    }

    if (things.next) {
      await things.next();
    } else {
      break;
    }
  }

  return Promise.all(returnPromises);
}

export async function forEachDatasetVersion(
  districtUid: string,
  callback: (districtRequest: DatasetVersionData) => Promise<void>,
  index?: string,
): Promise<void[]> {
  return forEachThing<DatasetVersionData>(
    () =>
      DatasetVersion.query(getDatasetKeyAttribute(districtUid), {
        index,
        beginsWith: getVersionKeyPrefix(),
        reverse: true,
      }),
    (datasetVersion) => callback(datasetVersion),
  );
}

export async function getAllNameMaps(): Promise<NameMapData[]> {
  const nameMaps: NameMapData[] = [];

  await forEachThing<NameMapData>(
    () => NameMap.query(ALL_NAME_MAPS, {
      index: 'GSI1',
    }),
    async (nameMap) => {
      nameMaps.push(nameMap);
    },
  );

  return nameMaps;
}

// Now read some test data
// const [rows, fields] = await connection.execute(`select * from dbvermontkidsdata.acs_dataset`);
// if (!module.parent) {
//     (async () => {
//         const rows = await queryDB(`select * from dbvkd.acs_variables where variable like 'B09001%' order by variable`);
//         // rows.sort((a, b) => {
//         //     return a.variable.localeCompare(b.variable);
//         // })
//         console.log(rows);
//     })();
// }