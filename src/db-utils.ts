import { Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/types';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { GetSecretValueCommand, SecretsManagerClient } from "@aws-sdk/client-secrets-manager";
import { DynamoDBDocumentClient, QueryCommandOutput } from '@aws-sdk/lib-dynamodb';
import { Entity, EntityItem, Table } from 'dynamodb-toolbox';
import * as mysql from 'mysql';

const ALL_UPLOAD_STATUS = 'ALL_UPLOAD_STATUS';
const ALL_SESSIONS = 'ALL_SESSIONS';
const ALL_DATASET_VERSIONS = 'ALL_DATASET_VERSIONS';
const ALL_NAME_MAPS = 'ALL_NAME_MAPS';
const ALL_ASSISTANTS = 'ALL_ASSISTANTS';
const ALL_ASSISTANT_FUNCTIONS = 'ALL_ASSISTANT_FUNCTIONS';
const ALL_PUBLISHED_ASSISTANTS = 'ALL_PUBLISHED_ASSISTANTS';
const ALL_DOCUMENTS = 'ALL_DOCUMENTS';

const ENTITY_UPLOAD_STATUS = 'UploadStatus';
const ENTITY_NAME_MAP = 'NameMap';
const ENTITY_SESSION = 'Session';
const ENTITY_DATASET_VERSION = 'DatasetVersion';
const ENTITY_COMPLETION = 'Completion';
const ENTITY_ASSISTANT = 'Assistant';
const ENTITY_ASSISTANT_FUNCTION = 'AssistantFunction';
const ENTITY_ASSISTANT_DOCUMENT = 'AssistantDocument';
const ENTITY_ASSISTANT_MAP = 'AssistantMap';
const ENTITY_PUBLISHED_ASSISTANT = 'PublishedAssistant';
const ENTITY_DOCUMENT = 'Document';

export const ASSISTANT_TYPE_VKD = 'vkd';

export const ALL_WITH_COMMENTS = 'ALL_WITH_COMMENTS';

const { VKD_ENVIRONMENT, LOG_LEVEL } = process.env;

// Set your service name. This comes out in service lens etc.
const serviceName = `queries-api-getList-${VKD_ENVIRONMENT}`;
const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});

function getRegion(): string {
  return process.env.REGION || 'us-east-1';
}

export function getNamespace(): string {
  if (process.env.VKD_ENVIRONMENT) return process.env.VKD_ENVIRONMENT;
  else throw new Error("process.env.VKD_ENVIRONMENT not passed");
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
  name: process.env.SERVICE_TABLE || 'ServiceTable',

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
    GSI3: {
      partitionKey: 'GSI3PK',
      sortKey: 'GSI3SK',
    },
  },

  DocumentClient: DynamoDBDocumentClient.from(new DynamoDBClient({ region: getRegion() }), {
    marshallOptions: {
      removeUndefinedValues: true,
    },
  }),
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
  name: ENTITY_UPLOAD_STATUS,
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
  name: ENTITY_NAME_MAP,
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
  name: ENTITY_SESSION,
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
  name: ENTITY_DATASET_VERSION,
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

export function getSortKeyAttribute(sortKey: number): string {
  return `SORT#${sortKey}`;
}

export function getReactionKeyAttribute(reaction: string): string {
  return `REACTION#${reaction}`;
}

export function getTypeKeyAttribute(type: string): string {
  return `TYPE#${type}`;
}

// Define a completion
export const Completion = new Entity({
  name: ENTITY_COMPLETION,
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { id: string }) => getConversationKeyAttribute(data.id) },
    SK: { sortKey: true, hidden: true, default: (data: { sortKey: number }) => getSortKeyAttribute(data.sortKey) },
    GSI1PK: { hidden: true, default: (data: { reaction: string }) => getReactionKeyAttribute(data.reaction) },
    GSI1SK: {
      hidden: true, default: (data: { id: string, sortKey: number }) =>
        getConversationKeyAttribute(data.id) + '#' + getSortKeyAttribute(data.sortKey),
    },
    GSI2PK: { hidden: true, default: (data: { comment?: string }) => data.comment ? ALL_WITH_COMMENTS : undefined },
    GSI2SK: {
      hidden: true, default: (data: { comment?: string, id: string, sortKey: number }) =>
        data.comment ? getConversationKeyAttribute(data.id) + '#' + getSortKeyAttribute(data.sortKey) : undefined,
    },
    GSI3PK: { hidden: true, default: (data: { type: string }) => `TYPE#${data.type}` },
    GSI3SK: {
      hidden: true, default: (data: { id: string, sortKey: number }) =>
        getConversationKeyAttribute(data.id) + '#' + getSortKeyAttribute(data.sortKey),
    },

    id: { type: 'string', required: true },
    sortKey: { type: 'number', required: true },
    type: { type: 'string', required: true },
    envName: { type: 'string', required: false }, // If a sandbox assistant

    status: { type: 'string', required: true },
    message: { type: 'string' },
    fileName: { type: 'string', required: false }, // If a file upload
    uploadedFilePath: { type: 'string', required: false }, // If a file upload
    uploadedFileName: { type: 'string', required: false }, // If a file upload
    uploadedFileMime: { type: 'string', required: false }, // If a file upload
    
    // User response to the completion
    reaction: { type: 'string' },
    comment: { type: 'string' },

    query: { type: 'string' },
    thread: { type: 'map' }, // Same for all messages in a conversation
    stream: { type: 'boolean' },
  },

  table: serviceTable,
});

export type CompletionData = EntityItem<typeof Completion>;

export function getCompletionPK(id: string, sortKey: number): { PK: string, SK: string } {
  return {
    PK: getConversationKeyAttribute(id),
    SK: getSortKeyAttribute(sortKey),
  };
}

export function getAssistantKeyAttribute(assistant: string): string {
  return `ASS#${assistant}`;
}

export function getNameKeyAttribute(name: string): string {
  return `NAME#${name.toLowerCase()}`;
}

export function getAssistantKey(assistant: string): { PK: string, SK: string } {
  return {
    PK: getAssistantKeyAttribute(assistant),
    SK: '$',
  };
}

export const Assistant = new Entity({
  name: ENTITY_ASSISTANT,
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { id: string }) => getAssistantKeyAttribute(data.id) },
    SK: { sortKey: true, hidden: true, default: () => '$' },
    GSI1PK: { hidden: true, default: () => ALL_ASSISTANTS },
    GSI1SK: {
      hidden: true, default: (data: { name: string }) => getNameKeyAttribute(data.name),
    },

    id: { type: 'string', required: true },
    type: { type: 'string', required: true, default: () => ASSISTANT_TYPE_VKD },

    sandbox: { type: 'string', required: false }, // Missing for the "main" assistant

    name: { type: 'string', required: true },
    definition: { type: 'map', required: true },
    active: { type: 'boolean', required: true, default: () => true },
  },
  table: serviceTable,
});

export type AssistantData = EntityItem<typeof Assistant>;

export function getPublishedAssistantKeyAttribute(type: string, envName: string): string {
  return `PUBASS#${type}#ENV#${envName}`;
}

export function getPublishedAssistantKey(type: string, envName: string): { PK: string, SK: string } {
  return {
    PK: getPublishedAssistantKeyAttribute(type, envName),
    SK: '$',
  };
}

export const PublishedAssistant = new Entity({
  name: ENTITY_PUBLISHED_ASSISTANT,
  attributes: {
    PK: {
      partitionKey: true, hidden: true,
      default: (data: { type: string, envName: string }) => getPublishedAssistantKeyAttribute(data.type, data.envName)
    },
    SK: { sortKey: true, hidden: true, default: () => '$' },
    GSI1PK: { hidden: true, default: () => ALL_PUBLISHED_ASSISTANTS },
    GSI1SK: {
      hidden: true, default: (data: { envName: string }) => getNameKeyAttribute(data.envName),
    },

    type: { type: 'string', required: true },
    envName: { type: 'string', required: true },

    definition: { type: 'map', required: true },
    assistantId: { type: 'string', required: true }, // Our assistant id it's published from
    openAIAssistantId: { type: 'string', required: true }, // The OpenAI assistant ID
  },
  table: serviceTable,
});

export type PublishedAssistantData = EntityItem<typeof PublishedAssistant>;

export function getDocumentKeyAttributePrefix(): string {
  return `DOC#`;
}

export function getDocumentKeyAttribute(identifier: string): string {
  return `${getDocumentKeyAttributePrefix()}${identifier}`;
}

export function getDocumentKey(identifier: string): { PK: string, SK: string } {
  return {
    PK: getDocumentKeyAttribute(identifier),
    SK: '$',
  };
}

export const Document = new Entity({
  name: ENTITY_DOCUMENT,
  attributes: {
    PK: {
      partitionKey: true, hidden: true,
      default: (data: { identifier: string }) => getDocumentKeyAttribute(data.identifier)
    },
    SK: { sortKey: true, hidden: true, default: () => '$' },
    GSI1PK: { hidden: true, default: () => ALL_DOCUMENTS },
    GSI1SK: {
      hidden: true, default: (data: { id: string }) => getDocumentKeyAttribute(data.id),
    },

    identifier: { type: 'string', required: true },

    bucket: { type: 'string', required: true },
    key: { type: 'string', required: true },
    tags: { type: 'map', required: false },
    active: { type: 'boolean', required: true, default: () => true },
  },
  table: serviceTable,
});

export type DocumentData = EntityItem<typeof Document>;

export const AssistantDocument = new Entity({
  name: ENTITY_ASSISTANT_DOCUMENT,
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { assistantId: string }) => getAssistantKeyAttribute(data.assistantId) },
    SK: { sortKey: true, hidden: true, default: (data: { identifier: string }) => getDocumentKeyAttribute(data.identifier) },
    GSI2PK: { hidden: true, default: (data: { identifier: string }) => getDocumentKeyAttribute(data.identifier) },
    GSI2SK: {
      hidden: true, default: (data: { assistantId: string }) => getAssistantKeyAttribute(data.assistantId),
    },

    assistantId: { type: 'string', required: true },
    identifier: { type: 'string', required: true },
    bucket: { type: 'string', required: true },
    key: { type: 'string', required: true },
  },
  table: serviceTable,
});

export function getAssistantDocumentKey(assistantId: string, identifier: string): { PK: string, SK: string } {
  return {
    PK: getAssistantKeyAttribute(assistantId),
    SK: getDocumentKeyAttribute(identifier),
  };
}

export type AssistantDocumentData = EntityItem<typeof AssistantDocument>;

export function getFunctionKeyAttributePrefix(): string {
  return `FUNC#`;
}

export function getFunctionKeyAttribute(func: string): string {
  return `${getFunctionKeyAttributePrefix()}${func}`;
}

export interface ParamDefinition {
  name: string;
  type: string;
  description: string;
  enum?: string[];
  _vkd?: {
    type: string
  }
}

export function makeParamDef(name: string, type: string, description: string, enumValues: string[] | undefined, vkdType: string | undefined): ParamDefinition {
  return {
    name,
    type,
    description,
    enum: enumValues,
    ...(vkdType ? { _vkd: { type: vkdType } } : {}),
  };
}

export function getParamDefName(param: ParamDefinition): string {
  return param.name;
}

export function getParamDefValue(param: ParamDefinition): {
  type: string;
  description?: string;
  enum?: string[];
  _vkd?: {
    type: string
  }
} {
  return {
    type: param.type,
    description: param.description,
    enum: param.enum,
    _vkd: param._vkd,
  };
}

export const AssistantFunction = new Entity({
  name: ENTITY_ASSISTANT_FUNCTION,
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { assistantId: string }) => getAssistantKeyAttribute(data.assistantId) },
    SK: { sortKey: true, hidden: true, default: (data: { functionId: string }) => getFunctionKeyAttribute(data.functionId) },
    GSI1PK: { hidden: true, default: () => ALL_ASSISTANT_FUNCTIONS },
    GSI1SK: {
      hidden: true, default: (data: { func: string }) => getFunctionKeyAttribute(data.func),
    },

    assistantId: { type: 'string', required: true },
    functionId: { type: 'string', required: true },

    name: { type: 'string', required: true },
    description: { type: 'string' },
    _vkd: { type: 'map', required: false }, // VKDFunction
    seriesParameter: { type: 'map', required: false }, // ParamDefinition, not required because could be defaulted
    categoryParameter: { type: 'map', required: true }, // ParamDefinition
    otherParameters: { type: 'list', required: false }, // List of ParamDefinition
  },
  table: serviceTable,
});

export function getAssistantFunctionKey(assistantId: string, functionId: string): { PK: string, SK: string } {
  return {
    PK: getAssistantKeyAttribute(assistantId),
    SK: getFunctionKeyAttribute(functionId),
  };
}

export type AssistantFunctionData = EntityItem<typeof AssistantFunction>;

export function getNamespaceKeyAttribute(namespace: string): string {
  return `NS#${namespace}`;
}

export function getVariantKeyAttribute(variation: string): string {
  return `VAR#${variation}`;
}

export const AssistantMap = new Entity({
  name: ENTITY_ASSISTANT_MAP,
  attributes: {
    PK: { partitionKey: true, hidden: true, default: (data: { namespace: string }) => getNamespaceKeyAttribute(data.namespace) },
    SK: { sortKey: true, hidden: true, default: (data: { variant: string }) => getVariantKeyAttribute(data.variant) },

    namespace: { type: 'string', required: true },
    variant: { type: 'string', required: false },

    assistantId: { type: 'string', required: true },
    vectorStore: { type: 'string', required: true },
  },
  table: serviceTable,
});

export type AssistantMapData = EntityItem<typeof AssistantMap>;

export async function forEachThing<T extends Record<string, any>>(
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

export async function getAllDocuments(props: { includeInactive?: boolean}): Promise<DocumentData[]> {
  const { includeInactive } = props;
  const documents: DocumentData[] = [];

  await forEachThing<DocumentData>(
    () => Document.query(ALL_DOCUMENTS, {
      index: 'GSI1',
    }),
    async (document) => {
      if (includeInactive || document.active) {
        documents.push(document);
      }
    },
  );

  return documents;
}

export async function getAllAssistants(props: { sandbox?: string, includeInactive?: boolean, type?: string }): Promise<AssistantData[]> {
  const { sandbox, includeInactive, type } = props;

  const assistants: AssistantData[] = [];

  await forEachThing<AssistantData>(
    () => Assistant.query(ALL_ASSISTANTS, {
      index: 'GSI1',
    }),
    async (assistant) => {
      if ((!sandbox || assistant.sandbox === sandbox) && (includeInactive || assistant.active) &&
        (!type || assistant.type === type)) {
        assistants.push(assistant);
      }
    },
  );

  return assistants;
}

export async function getAllAssistantFunctions(assistantId: string): Promise<AssistantFunctionData[]> {
  const assistantFunctions: AssistantFunctionData[] = [];

  await forEachThing<AssistantFunctionData>(
    () => AssistantFunction.query(ALL_ASSISTANT_FUNCTIONS, {
      index: 'GSI1',
      beginsWith: getFunctionKeyAttributePrefix(),
    }),
    async (assistantFunction) => {
      if (assistantFunction.assistantId === assistantId) {
        assistantFunctions.push(assistantFunction);
      }
    },
  );

  return assistantFunctions;
}

export async function getAllAssistantDocuments(assistantId: string): Promise<AssistantDocumentData[]> {
  const assistantDocuments: AssistantDocumentData[] = [];

  await forEachThing<AssistantDocumentData>(
    () => AssistantDocument.query(getAssistantKeyAttribute(assistantId), {
      beginsWith: getDocumentKeyAttributePrefix()
    }),
    async (assistantDocument) => {
      assistantDocuments.push(assistantDocument);
    },
  );

  return assistantDocuments;
}

// Now read some test data
// const [rows, fields] = await connection.execute(`select * from dbvermontkidsdata.acs_dataset`);
// if (!module.parent) {
//     (async () => {
//       const assistants = await getAllAssistants(VKD_ENVIRONMENT);
//       console.log(assistants);
//     })();
// }