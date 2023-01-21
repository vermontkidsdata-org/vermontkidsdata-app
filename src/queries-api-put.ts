import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { CORSConfigDefault } from './cors-config';
import { doDBClose, doDBCommit, doDBOpen, doDBQuery } from './db-utils';

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
  logger.info({message: 'event 👉', event});
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
  if (sqlText == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'PUT requires at least sqlText'
      })
    };
  }

  // This is an update, we assume it already exists. Use the POST to create one.
  if (id != null) {
    await doDBOpen();
    try {
      const queryRows = await doDBQuery('SELECT id, name, sqlText, columnMap, metadata FROM queries where id=?', [id]);
      if (queryRows.length === 1) {
        // If a name was passed, it must be the same. Don't want to allow changing
        if (name != null && `${name}` !== `${queryRows[0].name}`) {
          return {
            statusCode: 400,
            body: JSON.stringify({
              message: 'PUT cannot change name'
            })
          };
        }

        await doDBQuery('update queries set sqlText=?, columnMap=?, metadata=? where id=?',
          [sqlText, columnMap, metadata, id]);
        doDBCommit();

        return {
          statusCode: 200,
          body: JSON.stringify({
            row: { name, sqlText, columnMap, metadata, id }
          })
        };
      }
    } finally {
      await doDBClose();
    }
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
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault)
  );
