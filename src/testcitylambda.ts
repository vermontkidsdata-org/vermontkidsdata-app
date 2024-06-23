import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";

// import * as mysql from 'mysql2/promise';
import { GetSecretValueCommand, SecretsManagerClient } from "@aws-sdk/client-secrets-manager";

const region = 'us-east-1';

function getNamespace(): string {
  if (process.env.VKD_ENVIRONMENT) return process.env.VKD_ENVIRONMENT;
  else throw new Error("process.env.VKD_ENVIRONMENT not passed");  
}

export async function queryDB(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  const smClient = new SecretsManagerClient({ region: region });

  // let connection: mysql.Connection;
  // Get secret connection info
  const secrets = (await smClient.send(new GetSecretValueCommand({
    SecretId: `vkd/${getNamespace()}/dbcreds`,
  }))).SecretString;

  if (secrets == null) {
    return {
      body: JSON.stringify({ message: 'DB connection info not found' }),
      statusCode: 500,
    };
  } else {
    const info: {host: string, username: string, password: string} = JSON.parse(secrets);
    if (info.host == null || info.username == null || info.password == null) {
      return {
        body: JSON.stringify({ message: 'DB connection info missing information' }),
        statusCode: 500,
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



// Only run if executed directly
// if (!module.parent) {
//   (async () => {
//     try {
//       console.log(await getCensus({ } as unknown as APIGatewayProxyEventV2));
//     } catch (e) {
//       console.error(e);
//     }
//   })();
//   // (queryDB({} as any)).then((res) => {
//   //   console.log('called directly', res);
//   // })
// }
