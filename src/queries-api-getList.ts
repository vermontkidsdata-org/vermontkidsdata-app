import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBOpen, doDBQuery } from './db-utils';

// Set your service name. This comes out in service lens etc.
const serviceName = `queries-api-getList-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: process.env.LOG_LEVEL || 'INFO',
  serviceName
});
const tracer = new Tracer({ serviceName });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  const connection = await doDBOpen();

  // Get the query to run from the parameters
  const queryRows = await doDBQuery(connection, 'SELECT id, name, sqlText, columnMap, metadata FROM queries');
  // await doDBClose(connection);

  return {
    statusCode: 200,
    body: JSON.stringify({
      rows: queryRows
    })
  };
}

export const handler = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  .use(
    cors({
      origin: "*",
    })
  );
