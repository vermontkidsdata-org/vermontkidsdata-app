import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBCommit, doDBOpen, doDBQuery } from './db-utils';
import { makePowerTools } from './lambda-utils';

const {VKD_ENVIRONMENT } = process.env;

const pt = makePowerTools({ prefix: `queries-api-delete-${VKD_ENVIRONMENT}` });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({message: 'event 👉', event});
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
            message: 'query deleted',
          }),
        };
      }
    } finally {
      await doDBClose();
    }
  }

  return {
    statusCode: 404,
    body: JSON.stringify({
      message: 'query not found',
    }),
  };
}
