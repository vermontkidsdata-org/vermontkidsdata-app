// process.env.NAMESPACE = 'qa';

import { Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { Tracer } from '@aws-lambda-powertools/tracer';
import { APIGatewayProxyEventV2WithLambdaAuthorizer, APIGatewayProxyResultV2 } from 'aws-lambda';
import { VKDAuthorizerContext } from './authorizer';
import { doDBClose, doDBOpen, doDBQuery } from './db-utils';

const {NAMESPACE, LOG_LEVEL} = process.env;

// Set your service name. This comes out in service lens etc.
const serviceName = `queries-api-getList-${NAMESPACE}`;
export const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});
export const tracer = new Tracer({ serviceName });

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
        rows: queryRows,
      }),
    };
  } finally {
    await doDBClose();
  }
}

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
