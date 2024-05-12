import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { getSession } from './authorizer';
import { CORSConfigDefault } from './cors-config';
import { getSessionKey, Session } from './db-utils';

const { NAMESPACE, LOG_LEVEL, REDIRECT_URI } = process.env;

export const serviceName = `delete-session-${NAMESPACE}`;
export const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName: serviceName,
});
export const tracer = new Tracer({ serviceName: serviceName });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log({ message: `${serviceName} starting`, event });
  const state = event.queryStringParameters?.state;

  const session = await getSession(event);
  const body: Record<string, string> = {};
  if (session) {
    const resp = await Session.delete(getSessionKey(session.session_id));
    if (resp.$metadata.httpStatusCode !== 200) {
      body.message = 'session termination failed, status=' + resp.$metadata.httpStatusCode;
    } else {
      body.message = 'session terminated'
    }
  } else {
    body.message = 'no session'
  }

  return {
    body: JSON.stringify(body),
    statusCode: 302,
    headers: {
      "Location": state || REDIRECT_URI!,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST",
    },
  }
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  .use(
    cors(CORSConfigDefault),
  )
  ;