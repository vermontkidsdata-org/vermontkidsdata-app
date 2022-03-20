import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import * as AWS from 'aws-sdk';
import * as csv from 'csv-parse';
import * as mysql from 'mysql';
import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";
import * as util from 'util';
import { v4 as uuidv4 } from 'uuid';
import { PutItemOutput } from 'aws-sdk/clients/dynamodb';
import e = require('express');

const { REGION } = process.env;

async function doOpen(): Promise<mysql.Connection> {
    const smClient = new SecretsManagerClient({ region: REGION });

    // Get secret connection info
    const secrets = (await smClient.send(new GetSecretValueCommand({
      SecretId: 'vkd/prod/dbcreds'
    }))).SecretString;
  
    if (secrets == null) {
        throw new Error('DB connection info not found');
    } else {
      const info: {host: string, username: string, password: string} = JSON.parse(secrets);
      if (info.host == null || info.username == null || info.password == null) {
          throw new Error('DB connection info missing information');
      } else {
        return mysql.createConnection({
          host: info.host,
          user: info.username,
          password: info.password
        });
      }
    }
}

async function query(connection: mysql.Connection, sql: string, values?: any[]): Promise<any> {
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

interface ColumnMap {
  [key: string]: string
}

interface QueryRow {
  id: number,
  name: string,
  sqlText: string,
  columnMap?: string
};

async function getQuery(queryId: string): Promise<{connection: mysql.Connection, rows: QueryRow[]}> {
  console.log('opening connection');
  const connection = await doOpen();
  console.log('connection open');
  await query(connection, 'use dbvkd');

  // Get the query to run from the parameters
  const queryRows = await query(connection, 'SELECT sqlText, columnMap FROM queries where name=?', [queryId]);
  console.log(queryRows);
  if (queryRows.length == 0) {
    throw new Error('unknown query');
  } else {
    return {
      connection: connection,
      rows: queryRows
    }
  }
}

async function doQuery(queryId: string): Promise<{ rows: any[], columnMap?: ColumnMap }> {
  const info = await getQuery(queryId);

  // Now run the query. Should always return three columns, with the following names
  // - cat: The category(s)
  // - label: The label for the values
  // - value: The value for the values
  const resultRows = await query(info.connection, info.rows[0].sqlText);
  console.log('result', resultRows);

  console.log('closing connection');
  info.connection.end();
  console.log('connection closed');
  console.log('row0', info.rows[0])
  const columnMap = info.rows[0].columnMap != null ? JSON.parse(info.rows[0].columnMap) : undefined;
  return { rows: resultRows, columnMap: columnMap};
}

// (async() => {
//   const event: APIGatewayProxyEventV2 = {
//     pathParameters: { 
//       queryId: '58'
//     }
//   } as unknown as APIGatewayProxyEventV2;
//   await table(event);
// })();

export async function table(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  if (event.pathParameters == null || event.pathParameters.queryId == null) {
    return {
      statusCode: 400
    };
  } else {
    const queryId = event.pathParameters.queryId;
    try {

        // We assume we're getting back an array of values with the value keys being the key into the columnMap
        // columnMap => {'infant': 'Infant', 'toddler': 'Toddler', 'preschool': 'Preschool'}
        const resultRows = await doQuery(queryId);

        // Example results:
        // Table:
        // const foo = {
        //   columns: [
        //     { id: 'type', label: 'Type' },
        //     { id: 'infant', label: 'Infant' },
        //     { id: 'toddler', label: 'Toddler' },
        //     { id: 'preschool', label: 'Preschool' }
        //   ],
        //   rows: [
        //     [ 'center',	1942,	1666,	8564 ],
        //     [ 'licensed',	45, 49, 136 ],
        //     [ 'registered', 537, 541, 1039 ]
        //   ]
        // }
        // Bar chart:
        // const foo = {
        //   "id": "58",
        //   "series": [
        //       { "name": "Infant", "data": [ 2935, 3066, 2524 ] },
        //       { "name": "Toddler", "data": [ 2597, 2699, 2256 ] },
        //       { "name": "Preschool", "data": [ 12290, 12185, 9739 ] },
        //   ],
        //   "categories": [
        //       '2018-2019', '2019-2020', '2020-2021'
        //   ]
        // }

        interface QueryResult {
          cat: string, 
          label: string, 
          value: string
        };

        const columns: { id: string, label: string}[] = [];
        const rows: any[][] = [];

        for (let i = 0; i < resultRows.rows.length; i++) {
          // We'll take the column labels from the first row
          // First column in row is row label; rest are the columns
          const row = resultRows.rows[i];
          console.log(`row`, row);
          if (i === 0) {
            // Build up the columns
            const keys = Object.keys(row);
            console.log('keys', keys, 'cmap', resultRows.columnMap);
            for (let j = 0; j < keys.length; j++) {
              const key = keys[j];
              const label = resultRows.columnMap && resultRows.columnMap[key] != null
                ? resultRows.columnMap[key]
                : key;
              columns.push({
                id: key,
                label: label
              });
            }
          }

          // All rows, return the data
          rows.push(columns.map(col => row[col.id]));
        }
        const body = {
          id: queryId,
          columns,
          rows
        };
        console.log('body', JSON.stringify(body, null, 2));
        return {
          statusCode: 200,
          headers: {
            "Access-Control-Allow-Origin":"*",
            "Content-Type": "application/json",
            "Access-Control-Allow-Methods" : "GET",
          },
          body: JSON.stringify(body)
        };

    } catch (e) {
        console.log(e);
        return {
            statusCode: 500,
            body: (e as Error).message
        };
    }
    // let series = [{ name: 'All Students', data: [50,52] },
    //   { name: 'Free and Reduced Lunch', data: [35,38] },
    //   { name: 'Special Education', data: [13,17] },
    //   { name: 'Historically Marginalized', data: [36,39] }
    // ];
    // let categories = [ 'Jan', 'Feb' ];

    // return {
    //   body: JSON.stringify({
    //     "id": queryId,
    //     "series": series,
    //     "categories": categories
    //     }
    //   ),
    //   headers: {
    //     'Access-Control-Allow-Origin': '*'
    //   },
    //   statusCode: 200
    // };
  }
}
