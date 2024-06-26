import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { makePowerTools, prepareAPIGateway } from './lambda-utils';

const { VKD_ENVIRONMENT} = process.env;

const pt = makePowerTools({ prefix: `oauth-callback-${VKD_ENVIRONMENT}` });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'success',
    }),
  };
}

export const handler = prepareAPIGateway(lambdaHandler);
