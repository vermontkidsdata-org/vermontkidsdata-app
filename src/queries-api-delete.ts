import { Logger } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { Tracer } from '@aws-lambda-powertools/tracer';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBCommit, doDBOpen, doDBQuery } from './db-utils';

const {NAMESPACE, LOG_LEVEL} = process.env;

// Set your service name. This comes out in service lens etc.
const serviceName = `queries-api-delete-${NAMESPACE}`;
export const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName
});
export const tracer = new Tracer({ serviceName });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  logger.info({message: 'event 👉', event});
  const id = event.pathParameters?.id;

  // This is an delete, we assume it already exists. Use the POST to create one.
  if (id != null) {
    await doDBOpen();
    try {
      const queryRows = await doDBQuery('SELECT id, name FROM queries where id=?', [id]);
      if (queryRows.length === 1) {
        await doDBQuery('delete from queries where id=?',
          [id]);
        doDBCommit();
        
        return {
          statusCode: 200,
          body: JSON.stringify({
            message: 'query deleted'
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
