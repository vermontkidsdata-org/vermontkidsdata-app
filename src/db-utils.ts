import { GetSecretValueCommand, SecretsManagerClient } from "@aws-sdk/client-secrets-manager";
import * as mysql from 'mysql';
const region = 'us-east-1';

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

// Cached DB Secret
let secret: DBSecret | undefined = undefined;

export async function getDBSecret(): Promise<DBSecret> {
  if (secret) return secret;
  else {
    const smClient = new SecretsManagerClient({ region: getRegion() });
    const SecretId = `vkd/${getNamespace()}/dbcreds`;

    // Get secret connection info
    const secrets = (await smClient.send(new GetSecretValueCommand({
      SecretId
    }))).SecretString;

    if (secrets == null) {
      throw new Error('DB connection info not found');
    } else {
      const info: DBSecret = JSON.parse(secrets);
      if (info.host == null || info.username == null || info.password == null || info.schema == null) {
        throw new Error(`Secret ${SecretId}: missing some DB information`);
      } else {
        return info;
      }
    }
  }
}

export async function doDBClose(connection: mysql.Connection): Promise<void> {
  connection.commit();
}

export async function doDBInsert(connection: mysql.Connection, sql: string, values?: any[]): Promise<number> {
  if (values == null) values = [];
  return new Promise<any>((resolve, reject) => {
    // console.log(`query ${JSON.stringify(values)}`);
    return connection.query(sql, values, (err, results /*, fields*/) => {
      if (err) {
        reject(err);
      } else {
        resolve(results.insertId);
      }
    })
  });
}

export async function doDBQuery(connection: mysql.Connection, sql: string, values?: any[]): Promise<any[]> {
  if (values == null) values = [];
  return new Promise<any>((resolve, reject) => {
    // console.log(`query ${JSON.stringify(values)}`);
    return connection.query(sql, values, (err, results /*, fields*/) => {
      if (err) {
        reject(err);
      } else {
        resolve(results);
      }
    })
  });
}

export async function doDBOpen(): Promise<mysql.Connection> {
  const info = await getDBSecret();
  const conn = mysql.createConnection({
    host: info.host,
    user: info.username,
    password: info.password
  });
  await doDBQuery(conn, `use ${info.schema}`);
  console.log({message: 'doOpen: opened connection', schema: info.schema});
  return conn;
}

export async function queryDB(sqlText: string, params?: any[]): Promise<any[]> {
  const connectInfo = await getDBSecret();

  // Get secret connection info
  let connection = mysql.createConnection({
    host: connectInfo.host,
    user: connectInfo.username,
    password: connectInfo.password
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