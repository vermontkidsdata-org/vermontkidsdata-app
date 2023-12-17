import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { getSession } from './authorizer';
import { CORSConfigDefault } from './cors-config';

const { NAMESPACE, LOG_LEVEL } = process.env;

export const serviceName = `get-session-${NAMESPACE}`;
export const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName: serviceName
});
export const tracer = new Tracer({ serviceName: serviceName });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  logger.info({ message: `${serviceName} starting`, event });
  const session = await getSession(event);
  logger.info({ message: `session`, session });
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: `session`,
        active: session != null,
        expires_in: session ? Math.floor(session.TTL - Date.now()/1000) : undefined,
      },
    )
  }
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  .use(
    cors(CORSConfigDefault)
  )
  ;