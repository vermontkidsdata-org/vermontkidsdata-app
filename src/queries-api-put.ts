import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBCommit, doDBOpen, doDBQuery } from './db-utils';
import { makePowerTools } from './lambda-utils';

const {VKD_ENVIRONMENT } = process.env;

const pt = makePowerTools({ prefix: `queries-api-put-${VKD_ENVIRONMENT}` });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: 'event 👉', event });
  const id = event.pathParameters?.id;
  const body = event.body;

  if (body == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'empty body passed',
      }),
    };
  }

  const { name, sqlText, columnMap, metadata, uploadType } = JSON.parse(body);
  if (sqlText == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'PUT requires at least sqlText',
      }),
    };
  }

  // This is an update, we assume it already exists. Use the POST to create one.
  if (id != null) {
    await doDBOpen();
    try {
      const queryRows = await doDBQuery('SELECT id, name, sqlText, columnMap, metadata, uploadType FROM queries where id=?', [id]);
      if (queryRows.length === 1) {
        // If a name was passed, it must be the same. Don't want to allow changing
        if (name != null && `${name}` !== `${queryRows[0].name}`) {
          return {
            statusCode: 400,
            body: JSON.stringify({
              message: 'PUT cannot change name',
            }),
          };
        }

        if (uploadType && uploadType !== '') {
          await doDBQuery('update queries set sqlText=?, columnMap=?, metadata=?, uploadType=? where id=?',
            [sqlText, columnMap, metadata, id, uploadType]);
        } else {
          await doDBQuery('update queries set sqlText=?, columnMap=?, metadata=? where id=?',
            [sqlText, columnMap, metadata, id]);
        }
        doDBCommit();

        return {
          statusCode: 200,
          body: JSON.stringify({
            row: { name, sqlText, columnMap, metadata, id },
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
