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

// Cached DB Secret and connection
let secret: DBSecret | undefined = undefined;
let cachedConnection: mysql.Connection | undefined = undefined;
const smClient = new SecretsManagerClient({ region: 'us-east-1'});

export async function getDBSecret(): Promise<DBSecret> {
  console.log('getDBSecret, secret', secret)
  if (secret) return secret;
  else {
    console.log('getDBSecret, get SecretsManagerClient')
    const SecretId = `vkd/${getNamespace()}/dbcreds`;
    console.log({message: 'getDBSecret, SecretId', SecretId,})

    // Get secret connection info
    try {
      console.log({message: 'getDBSecret, trying'});

      const secrets = await smClient.send(new GetSecretValueCommand({
        SecretId
      }));
      console.log({message: 'getDBSecret, got secrets', secrets});

      const secretString = secrets.SecretString;
      console.log({message: 'getDBSecret, got secret string', secretString})
      if (secretString == null) {
        console.log({message:'get secret info not found', SecretId})
        throw new Error('DB connection info not found');
      } else {
        console.log({message:'get secret info', secrets})
        const info: DBSecret = JSON.parse(secretString);
        if (info.host == null || info.username == null || info.password == null || info.schema == null) {
          throw new Error(`Secret ${SecretId}: missing some DB information`);
        } else {
          return info;
        }
      }
    
    } catch (err) {
      console.error({message: 'exception getting secret!'});
      console.error({err});
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
  console.log({ msg: `doDBQuery query`, sql, values });
  const conn = cachedConnection;
  if (conn) {
    if (values == null) values = [];
    return new Promise<any>((resolve, reject) => {
      return conn.query(sql, values, (err, results /*, fields*/) => {
        // console.log({msg:`doDBQuery query ret`, err, results});
        if (err) {
          reject(err);
        } else {
          // console.log({msg:`doDBQuery query resolve`, rez: util.inspect(results)});
          // console.log({msg:`doDBQuery query col`, rez: results[0].COLUMN_NAME});
          resolve(results);
        }
      })
    });
  } else {
    throw new Error('no DB connection');
  }
}

export async function doDBOpen(): Promise<void> {
  console.log({cachedConnection})
  if (!cachedConnection) {
    const info = await getDBSecret();
    console.log({info});
    cachedConnection = mysql.createConnection({
      host: info.host,
      user: info.username,
      password: info.password
    });
    await doDBQuery(`use ${info.schema}`);
    // console.log({ message: 'doOpen: opened connection', schema: info.schema });
  }
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