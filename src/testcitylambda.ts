import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { census } from '/opt/nodejs/citysdk-utils';
// import * as mysql from 'mysql2/promise';
import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";

const region = 'us-east-1';

export async function queryDB(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  const smClient = new SecretsManagerClient({ region: region });

  // let connection: mysql.Connection;
  // Get secret connection info
  const secrets = (await smClient.send(new GetSecretValueCommand({
    SecretId: 'vkd/prod/dbcreds'
  }))).SecretString;

  if (secrets == null) {
    return {
      body: JSON.stringify({ message: 'DB connection info not found' }),
      statusCode: 500
    };
  } else {
    const info: {host: string, username: string, password: string} = JSON.parse(secrets);
    if (info.host == null || info.username == null || info.password == null) {
      return {
        body: JSON.stringify({ message: 'DB connection info missing information' }),
        statusCode: 500
      };
    } else {
      // connection = await mysql.createConnection({
      //   host: info.host,
      //   user: info.username,
      //   password: info.password
      // });
    }
  }

  // Now read some test data
  // const [rows, fields] = await connection.execute(`select * from dbvermontkidsdata.acs_dataset`);
  
  return {
    body: JSON.stringify({
      message: 'Successful lambda invocation',
      // result: result,
      // rows: rows
    }),
    statusCode: 200,
  };
}

export async function getCensus(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('starting main function');
 
  //get the ACS5 2017 population for all counties in the California
  const censusResult = await census({
      vintage: '2017',
      geoHierarchy: {
        state: "06",
        county: '*',
      },
      sourcePath: ['acs','acs5'],
      values: ['B00001_001E'],
    });

  console.log('event 👉', event);

  return {
    body: JSON.stringify({
      message: 'Successful lambda invocation',
      // result: result,
      result: censusResult
    }),
    statusCode: 200,
  };
}


// Only run if executed directly
if (!module.parent) {
  (queryDB({} as any)).then((res) => {
    console.log('called directly', res);
  })
}
