// process.env.NAMESPACE = 'qa';

import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2WithLambdaAuthorizer, APIGatewayProxyResultV2 } from 'aws-lambda';
import { VKDAuthorizerContext } from './authorizer';
import { CORSConfigDefault } from './cors-config';
import { doDBClose, doDBOpen, doDBQuery } from './db-utils';

// Set your service name. This comes out in service lens etc.
const serviceName = `queries-api-getList-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: process.env.LOG_LEVEL || 'INFO',
  serviceName
});
const tracer = new Tracer({ serviceName });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithLambdaAuthorizer<VKDAuthorizerContext>,
): Promise<APIGatewayProxyResultV2> {
  logger.info({ message: 'get-list', serviceName, event, authorizerContext: event.requestContext?.authorizer });

  await doDBOpen();
  try {
    // Get the query to run from the parameters
    const queryRows = await doDBQuery('SELECT id, name, sqlText, columnMap, metadata, uploadType FROM queries');

    return {
      statusCode: 200,
      body: JSON.stringify({
        rows: queryRows
      })
    };
  } finally {
    await doDBClose();
  }
}

export const handler = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault)
  );

if (!module.parent) {
  (async () => {
    console.log(await lambdaHandler({  
    } as unknown as APIGatewayProxyEventV2WithLambdaAuthorizer<VKDAuthorizerContext>))
  })().catch(err => {
    console.log(`exception`, err);
  });
} else {
  console.log("we're NOT in the local deploy, probably in Lambda");
}
