import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBOpen, doDBQuery } from './db-utils';
import { makePowerTools } from './lambda-utils';

const {VKD_ENVIRONMENT } = process.env;

const pt = makePowerTools({ prefix: `queries-api-get-${VKD_ENVIRONMENT}` });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({message: 'event 👉', event});
  const id = event.pathParameters?.id;
  let row: any = undefined;
  if (id != null) {
    await doDBOpen();
    try {
      const queryRows = await doDBQuery('SELECT id, name, sqlText, columnMap, metadata, uploadType FROM queries where id=?', [id]);
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
        message: 'query not found',
      }),
    };
  } else {
    return {
      statusCode: 200,
      body: JSON.stringify({
        row,
      }),
    };
  }
}
