import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";
import * as mysql from 'mysql';
const region = 'us-east-1';

interface ConnectInfo {
    host: string,
    username: string,
    password: string
}
let connectInfo: ConnectInfo;

async function initConnectInfo(): Promise<void> {
    if (connectInfo == null) {
        const smClient = new SecretsManagerClient({ region: region });
        const secrets = (await smClient.send(new GetSecretValueCommand({
            SecretId: 'vkd/prod/dbcreds'
        }))).SecretString;

        if (secrets == null) {
            throw new Error('DB connection info not found');
        } else {
            const info: { host: string, username: string, password: string } = JSON.parse(secrets);
            if (info.host == null || info.username == null || info.password == null) {
                throw new Error('DB connection info missing information');
            } else {
                connectInfo = info;
            }
        }
    }
}

export async function queryDB(sqlText: string, params?: any[]): Promise<any[]> {
    await initConnectInfo();

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
                connection.query(sqlText, params, (err: mysql.MysqlError|null, results: any[], fields: any) => {
                    connection.end((err: any) => { if (err) console.error(err)});

                    if (err) {
                        reject('error querying: ' + err);
                    } else {
                        resolve(results);
                    }
                });
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