import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBCommit, doDBInsert, doDBOpen, doDBQuery } from './db-utils';
import { makePowerTools } from './lambda-utils';

const {VKD_ENVIRONMENT, } = process.env;

const pt = makePowerTools({ prefix: `queries-api-post-${VKD_ENVIRONMENT}` });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({message: 'event 👉', event});
  const body = event.body;

  if (body == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'empty body passed',
      }),
    };
  }

  const { name, sqlText, columnMap, metadata } = JSON.parse(body);
  if (name == null || sqlText == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'POST requires at least name and sqlText',
      }),
    };
  }

  await doDBOpen();
  try {
    // Don't allow if name already exists
    const queryRows = await doDBQuery('SELECT id, name FROM queries where name=?', [name]);
    if (queryRows.length > 0) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: 'POST requires unique name',
        }),
      };
    }

    const id = await doDBInsert('insert into queries (name, sqlText, columnMap, metadata) values (?,?,?,?)',
      [name, sqlText, columnMap, metadata]);
    await doDBCommit();

    return {
      statusCode: 200,
      body: JSON.stringify({
        id,
      }),
    };
  } finally {
    await doDBClose();
  }
}
