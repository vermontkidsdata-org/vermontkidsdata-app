import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import { APIGatewayAuthorizerResult, APIGatewayRequestAuthorizerEvent, Context, PolicyDocument, Statement } from 'aws-lambda';
import { getSessionKey, Session, SessionData } from './db-utils';
const { ENV_NAME, SERVICE_TABLE, LOG_LEVEL } = process.env;

export const serviceName = `bff-api-authorizer-${ENV_NAME}`;
export const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName: serviceName,
});
export const tracer = new Tracer({ serviceName: serviceName });
export interface VKDAuthorizerContext {
  access_token: string,
  id_token: string,
  domain: string,
  refresh_token: string,
  timestamp: string,
}

const COOKIE_PREFIX = 'VKD_AUTH=';

export async function getSession(event: {
  headers?: { [name: string]: string | undefined; } | null
}): Promise<SessionData | undefined> {
  // Cookie: VKD_AUTH=12345q13245; SOMETHING_ELSE=a039480w3984
  const authCookie = (event.headers?.Cookie || event.headers?.cookie || '').split(';').find(cookie => cookie.trim().startsWith(COOKIE_PREFIX));
  if (!authCookie) {
    logger.info({ message: 'no VKD_AUTH cookie, denying' });
    // return Deny below
  } else {
    if (SERVICE_TABLE == null) {
      logger.info({ message: 'Needs SERVICE_TABLE configured in CDK' });
      throw new Error('Needs SERVICE_TABLE');
    }

    // Pull off the session id from cookie value
    const session_id = authCookie.trim().substring(COOKIE_PREFIX.length).trim();
    logger.info({ message: `Session id ${session_id} lookup in table ${SERVICE_TABLE}` });

    const session = await Session.get(getSessionKey(session_id));
    const now = Date.now() / 1000;
    logger.info({ message: `Session lookup result`, session_id, session, now });
    if (session?.Item?.TTL && session?.Item?.TTL >= now) {
      return session.Item;
    }
  }

  return undefined;
}

export async function lambdaHandler(
  event: APIGatewayRequestAuthorizerEvent,
  context: Context, // eslint-disable-line no-unused-vars, @typescript-eslint/no-unused-vars
): Promise<APIGatewayAuthorizerResult> {
  console.log({ message: 'Authorizer', event });

  // Create policy statement. Initialize effect to Deny, we'll update later if appropriate.
  const statement: Statement = {
    Action: 'execute-api:Invoke', // default action
    Effect: 'Deny',
    Resource: event.methodArn, // Point to resource to which access is being authorized
  };

  // Create policy document with statement
  const policyDocument: PolicyDocument = {
    Version: '2012-10-17', // default version
    Statement: [statement],
  };

  // Create response
  const response: APIGatewayAuthorizerResult = {
    principalId: 'user', // Not sure that this value actually matters
    policyDocument,
    context: {},
  };

  const session = await getSession(event);
  if (session) {
    // If we are here, we have a valid session. So just return the pieces.
    statement.Effect = 'Allow';
    response.context = {
      access_token: session.access_token,
      id_token: session.id_token,
      domain: session.domain,
      refresh_token: session.refresh_token,
      timestamp: session.timestamp,
      TTL: session.TTL,
    };

    logger.info({ message: 'authorizer allow response', response });
  } else {
    console.log({ message: `Session not found in table ${SERVICE_TABLE}` });
    // return Deny below
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
