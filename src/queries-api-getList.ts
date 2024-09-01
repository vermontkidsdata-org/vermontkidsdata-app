// process.env.VKD_ENVIRONMENT = 'qa';

import { APIGatewayEventRequestContextV2, APIGatewayProxyEventV2, APIGatewayProxyEventV2WithLambdaAuthorizer, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBOpen, doDBQuery } from './db-utils';
import { makePowerTools } from './lambda-utils';

const {VKD_ENVIRONMENT } = process.env;

const pt = makePowerTools({ prefix: `queries-api-getList-${VKD_ENVIRONMENT}` });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: 'get-list' });

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
    } as unknown as APIGatewayProxyEventV2WithLambdaAuthorizer<APIGatewayEventRequestContextV2>))
  })().catch(err => {
    console.log(`exception`, err);
  });
} else {
  console.log("we're NOT in the local deploy, probably in Lambda");
}
