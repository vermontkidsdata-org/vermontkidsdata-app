import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBOpen, doDBQuery } from './db-utils';

// Set your service name. This comes out in service lens etc.
const serviceName = `queries-api-get-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: process.env.LOG_LEVEL || 'INFO',
  serviceName
});
const tracer = new Tracer({ serviceName });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  const id = event.pathParameters?.id;
  let row: any = undefined;
  if (id != null) {
    await doDBOpen();
    try {
      const queryRows = await doDBQuery('SELECT id, name, sqlText, columnMap, metadata FROM queries where id=?', [id]);
      if (queryRows.length > 0) {
        row = queryRows[0];
      }
    } finally {
      await doDBClose();
    }
  }

  if (row == null) {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: 'query not found'
      })
    };
  } else {
    return {
      statusCode: 200,
      body: JSON.stringify({
        row
      })
    };
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
