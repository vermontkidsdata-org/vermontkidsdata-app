import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import { DynamoDBClient, GetItemCommand } from '@aws-sdk/client-dynamodb';
import middy from '@middy/core';
import { APIGatewayAuthorizerResult, APIGatewayRequestAuthorizerEvent, Context, PolicyDocument, Statement } from 'aws-lambda';
const { ENV_NAME, TABLE_NAME, AWS_REGION } = process.env;

export const serviceName = `bff-api-authorizer-${ENV_NAME}`;
export const logger = new Logger({
  logLevel: 'INFO',
  serviceName: serviceName
});
export const tracer = new Tracer({ serviceName: serviceName });
export interface VKDAuthorizerContext {
  access_token: string,
  id_token: string,
  domain: string,
  refresh_token: string,
  timestamp: string,
}

const ddbClient = new DynamoDBClient({ region: AWS_REGION });
const COOKIE_PREFIX = 'VKD_AUTH=';

export async function lambdaHandler(
  event: APIGatewayRequestAuthorizerEvent,
  context: Context // eslint-disable-line no-unused-vars, @typescript-eslint/no-unused-vars
): Promise<APIGatewayAuthorizerResult> {
  console.log({ message: 'Authorizer', event });

  // Create policy statement. Initialize effect to Deny, we'll update later if appropriate.
  const statement: Statement = {
    Action: 'execute-api:Invoke', // default action
    Effect: 'Deny',
    Resource: event.methodArn // Point to resource to which access is being authorized
  };

  // Create policy document with statement
  const policyDocument: PolicyDocument = {
    Version: '2012-10-17', // default version
    Statement: [statement]
  };

  // Create response
  const response: APIGatewayAuthorizerResult = {
    principalId: 'user', // Not sure that this value actually matters
    policyDocument,
    context: {}
  };
  
  // Cookie: VKD_AUTH=12345q13245; SOMETHING_ELSE=a039480w3984
  const authCookie = (event.headers?.Cookie || event.headers?.cookie || '').split(';').find(cookie => cookie.trim().startsWith(COOKIE_PREFIX));
  if (!authCookie) {
    console.log({ message: 'no VKD_AUTH cookie, denying' });
    // return Deny below
  } else {
    if (TABLE_NAME == null) {
      console.log({ message: 'Needs TABLE_NAME configured in CDK' });
      throw new Error('Needs TABLE_NAME');
    }

    // Pull off the session id from cookie value
    const session_id = authCookie.trim().substring(COOKIE_PREFIX.length).trim();
    console.log({ message: `Session id ${session_id} lookup in table ${TABLE_NAME}` });

    let session = await ddbClient.send(new GetItemCommand({
      TableName: TABLE_NAME,
      Key: {
        session_id: { S: session_id }
      }
    }));

    if (session.Item) {
      // If we are here, we have a valid session. So just return the pieces.
      statement.Effect = 'Allow';
      response.context = {
        access_token: session.Item.access_token.S,
        id_token: session.Item.id_token.S,
        domain: session.Item.domain.S,
        refresh_token: session.Item.refresh_token.S,
        timestamp: session.Item.timestamp.S,
      };

      logger.info({ message: 'authorizer allow response', response });
    } else {
      console.log({ message: `Session id ${session_id} not found in table ${TABLE_NAME}` });
      // return Deny below
    }
  }

  return response;
}

if (!module.parent) {
  (async () => {
  })();
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger));
