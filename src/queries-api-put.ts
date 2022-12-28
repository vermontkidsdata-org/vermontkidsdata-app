import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBOpen, doDBQuery } from './db-utils';

// Set your service name. This comes out in service lens etc.
const serviceName = `queries-api-put-${process.env.NAMESPACE}`;
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
  const body = event.body;

  if (body == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'empty body passed'
      })
    };
  }

  const { name, sqlText, columnMap, metadata } = JSON.parse(body);
  if (name == null || sqlText == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'PUT requires at least name and sqlText'
      })
    };
  }

  // This is an update, we assume it already exists. Use the POST to create one.
  if (id != null) {
    const connection = await doDBOpen();
    const queryRows = await doDBQuery(connection, 'SELECT id, name, sqlText, columnMap, metadata FROM queries where id=?', [id]);
    if (queryRows.length === 1) {
      await doDBQuery(connection, 'update queries set name=?, sqlText=?, columnMap=?, metadata=? where id=?',
        [name, sqlText, columnMap, metadata, id]);

      return {
        statusCode: 200,
        body: JSON.stringify({
          row: { name, sqlText, columnMap, metadata, id }
        })
      };
    }
    await doDBClose(connection);
  }

  return {
    statusCode: 404,
    body: JSON.stringify({
      message: 'query not found'
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
