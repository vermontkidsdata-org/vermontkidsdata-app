import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from 'aws-lambda';
// import AWS, { CognitoIdentityCredentials } from 'aws-sdk';
import { httpResponse } from './cors';
const { IDENTITY_POOL_ID, IDENTITY_PROVIDER, ENV_NAME, TABLE_NAME, AWS_REGION } = process.env;
// import getCognitoCreds from './cognito.js';
import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import { fromCognitoIdentityPool as FromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";
import { VKDAuthorizerContext } from './authorizer';
import { CORSConfigDefault } from './cors-config';

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

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<VKDAuthorizerContext>,
): Promise<APIGatewayProxyResultV2> {
  console.log({ message: 'get creds starting', event });
  console.log('request context try 3', JSON.stringify(event.requestContext));

  // I don't know why I have to hack it like this...
  const idToken = (event.requestContext as any).authorizer.id_token;
  console.log({ message: 'idToken', idToken });

  if (IDENTITY_POOL_ID == null || IDENTITY_PROVIDER == null || AWS_REGION == null || TABLE_NAME == null) {
    return httpResponse(500, {
      message: 'Cognito callback needs IDENTITY_POOL_ID, IDENTITY_PROVIDER, AWS_REGION, TABLE_NAME'
    });
  }

  const creds = await getCognitoCreds(
    IDENTITY_POOL_ID,
    IDENTITY_PROVIDER,
    idToken,
    AWS_REGION
  );
  logger.info({ message: 'creds', creds });

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
  .use(injectLambdaContext(logger))
  .use(
    cors(CORSConfigDefault)
  )
  ;