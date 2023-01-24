import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import middy from '@middy/core';
import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from 'aws-lambda';
// import AWS, { CognitoIdentityCredentials } from 'aws-sdk';
import { httpResponse } from './cors';
const { IDENTITY_POOL_ID, IDENTITY_PROVIDER, ENV_NAME, TABLE_NAME, AWS_REGION } = process.env;
// import getCognitoCreds from './cognito.js';
import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import { fromCognitoIdentityPool as FromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";
import { VKDAuthorizerContext } from './authorizer';
import { CognitoIdentityServiceProvider } from 'aws-sdk';

export const serviceName = `get-credentials-${ENV_NAME}`;
export const logger = new Logger({
  logLevel: 'INFO',
  serviceName: serviceName
});
export const tracer = new Tracer({ serviceName: serviceName });

const ddbClient = new DynamoDBClient({ region: AWS_REGION });

export interface Creds {
  identityId: string,
  accessKeyId: string,
  secretAccessKey: string,
  sessionToken?: string,
  expiration?: Date
}

async function getCognitoCreds(identityPoolId: string, identityProvider: string, idToken: string, region: string): Promise<Creds> {
  const creds = FromCognitoIdentityPool({
    client: new CognitoIdentityClient({
      region,
    }),
    identityPoolId,
    logins: {
      [identityProvider]: idToken,
    },
  });

  return creds();
}

const COGNITO_CLIENT_ID = '60c446jr2ogigpg0nb5l593l93';

var cognitoidentityserviceprovider = new CognitoIdentityServiceProvider();
cognitoidentityserviceprovider.initiateAuth({
  AuthFlow: 'REFRESH_TOKEN',
  ClientId: COGNITO_CLIENT_ID,
  AuthParameters: {
    REFRESH_TOKEN: 'eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAifQ.IM0bU9S_rAUJhOZLgLiNpwl_swZRu8OP5391GttfmIJOBJb6EObnDGcLOJgEZ9yDv9-s_GRLztSVdDzMK4Pz2sRN7aIZI1M6wO0hSma6wZExmeO9syauqverARTGTYFoeACedsboNW9faJpp0K4yNU4wK7zYWFHcM2Y9MfVfRAISyKJn5Nv75TqZT1HGceZd3BPJq2Ejv1whMYZeKhCjXqUP337fZk1nhC9s_zPcF_F6ScigLGjKjCx-AqZe-C-Si8Lf8JyMzeoT3GJRdwG3YqHjmAY8dS_Y4ipkSU8qDg1EaVVMJscfaRPlY6lD6S5EsdmwyJ2os0WBJNC-xSgf9A.ZSz7BHL-OVb1ZLUM.8xJkIHIE8xIUm79A5K3ESnoRQqIbpLctMV6JNJ2nY6tfQJ-vE_1Gd1Dp3Zk4UYSYrZjtfAkoF1LSRq03zBtQ9fC8vIgGOUlGg9eqbe6JFmaDoI09Wct_MLrzBKfOFDimKblZLmZ_83vTjftDptYdTqysE3y3xtDMVCzpiZ0jlUakUaII8vTJepn0Nu7VE48A0frO4Gp5sAGITU3Ijb5OCxy_28-SDmok932AQOymVjGCaYItiognIvz3AVDUx0Lxdp7VBZjB6PQPoYJWTo9v8msXJupq20JOs9P7lgaYA4BDng7_xrWiTNcv7zGZWG6kcQcdiNN8f2bq2NVnyZWV2KbyUS5TWbCQ4L92q2MJWZr0GOVBTSB1KJI7pBsnUVPXPvkqno5CcJWkx_X-C9Bc-wTO-poyPbOqQ84cfWPdc7Oy-3TR_4IVDNNpXt9ZsiiKUkehYbFbMkroAXht9v5_3YX4hTvGMJpKCfLIh0jM_m2_hM9J5XR-YXG4yyIkmgPPR_AdvkLzXT8BrOFDca1pa5ib3tw6_gXsmPskYTGWh_7hBzELKZN2j8w44vikKnNMW5dUT6AKYDOekz4MtuuZIAir_0SHTQf63BR7s4kuosIUm_TqEtPkwqLL277XQk2c1QbURpseWmiZmnETmnLDxeS4MZ1YiswKBw0jw-ydqKzKCxgRjk1lXIV5oimTc-sn6pyWaRgWjlW5OnpaMAacs9qlW0IeWXKV_LSiv3L008jkrFo34dI4gihHVmHP7abHHH_ZTZH5jEgjjlNTfIHjatidqC-aPowxB_bXZvBFujUjgKVfMBTPyYQTZtvZ3DSx8uDJ9R65zAYJB3lP63HJ6XnMvVdwCFXYYnE-t7qPDBqeg1s0rM5tzYSJ2_sWbL1StilpI3SwG6KmQPEE4J4TtuVwcXC4xBSIuKdXaPNHqVMRLN6k9UTrWcQWL9YGAHrtd9poxS-JgCq9_OCWYYzjqQI6qBMP5B7cwRhSEIpd28TXFiZ6d6PQ-rLHFa9cNQUxpBbZ_qSxSTXa0qgXdCi8uestGeIYOXwF9MCkHSy5Bh2UqwA0IBiY_vgm09J7tO7iyUcyEet8s6z6UkF3-V-YW49L3Adu4ekhC7VAtA022dgMYK_JKMEuIkZTjuXSsg9TCpXUO8Iwdcy9eBhxTWPl2B3gJNq2lnnuPYc_zbZeJlljk-_YUnWp645gmdDjxWniEgTqwJGS3HlntsMnWn_ahCXPtXdaJIfE_qYzWsadwPfaO-8k3X8sAw6pQd5IPlgDMm8Jmen0juhPQq0oYB5R5erJenFRd5MTFMFzfrWjWEF5XayqUdXQefTbmKqtMLD8qImLJuqANNyI7mAtp6enN1DUBEM25wzd7kqHQfeITYGxbf7i_Bl9CWTQMmUpjeezSsuvNxNMx-Q2ynyr_siiyiKpP7fKkZ5TN9SZ.OrWBz4sAPTJd5aWDXq5Gfg'
  }
})

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<VKDAuthorizerContext>,
): Promise<APIGatewayProxyResultV2> {
  console.log({ message: 'get creds starting', event });
  console.log('request context try 3', JSON.stringify(event.requestContext));
  
  // I don't know why I have to hack it like this...
  const idToken = (event.requestContext as any).authorizer.id_token;
  console.log({ message: 'idToken', idToken });

  if (IDENTITY_POOL_ID == null || IDENTITY_PROVIDER == null || AWS_REGION == null || TABLE_NAME == null) {
    return {
      body: JSON.stringify({ message: 'Cognito callback needs IDENTITY_POOL_ID, IDENTITY_PROVIDER, AWS_REGION, TABLE_NAME' }),
      statusCode: 500,
    };
  }

  const creds = await getCognitoCreds(
    IDENTITY_POOL_ID,
    IDENTITY_PROVIDER,
    idToken,
    AWS_REGION
  );
  logger.info({message: 'creds', creds});

  return httpResponse(200, creds);
}

// if (!module.parent) {
//   (async () => {
//     console.log(await lambdaHandler({

//     } as APIGatewayProxyEventV2));
//   })();
// }

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger));
