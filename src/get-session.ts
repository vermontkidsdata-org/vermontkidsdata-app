import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { getSession } from './authorizer';
import { makePowerTools, prepareAPIGateway } from './lambda-utils';

const { NAMESPACE, LOG_LEVEL } = process.env;

const pt = makePowerTools({ prefix: `get-session-${NAMESPACE}` });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: `${pt.serviceName} starting`, event });
  const session = await getSession(event);
  pt.logger.info({ message: `session`, session });
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: `session`,
        active: session != null,
        expires_in: session ? Math.floor(session.TTL - Date.now()/1000) : undefined,
      },
    ),
  }
}

export const main = prepareAPIGateway(lambdaHandler);
