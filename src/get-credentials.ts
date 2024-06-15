import { APIGatewayEventRequestContextV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from 'aws-lambda';
// import AWS, { CognitoIdentityCredentials } from 'aws-sdk';
import { httpResponse } from './cors';
const { IDENTITY_POOL_ID, IDENTITY_PROVIDER, ENV_NAME, SERVICE_TABLE, AWS_REGION, LOG_LEVEL } = process.env;
// import getCognitoCreds from './cognito.js';
import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import { fromCognitoIdentityPool as FromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";
import { makePowerTools, prepareAPIGateway } from './lambda-utils';

const pt = makePowerTools({ prefix: `get-credentials-${process.env.NAMESPACE}` });

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
  event: APIGatewayProxyEventV2WithRequestContext<APIGatewayEventRequestContextV2>,
): Promise<APIGatewayProxyResultV2> {
  console.log({ message: 'get creds starting', event });
  console.log('request context try 3', JSON.stringify(event.requestContext));

  // I don't know why I have to hack it like this...
  const idToken = (event.requestContext as any).authorizer.id_token;
  console.log({ message: 'idToken', idToken });

  if (IDENTITY_POOL_ID == null || IDENTITY_PROVIDER == null || AWS_REGION == null || SERVICE_TABLE == null) {
    return httpResponse(500, {
      message: 'Cognito callback needs IDENTITY_POOL_ID, IDENTITY_PROVIDER, AWS_REGION, SERVICE_TABLE',
    });
  }

  const creds = await getCognitoCreds(
    IDENTITY_POOL_ID,
    IDENTITY_PROVIDER,
    idToken,
    AWS_REGION,
  );
  pt.logger.info({ message: 'creds', creds });

  return httpResponse(200, creds);
}

// if (!module.parent) {
//   (async () => {
//     console.log(await lambdaHandler({

//     } as APIGatewayProxyEventV2));
//   })();
// }

export const main = prepareAPIGateway(lambdaHandler);