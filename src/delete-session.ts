import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { getSession } from './authorizer';
import { getSessionKey, Session } from './db-utils';
import { makePowerTools, prepareAPIGateway } from './lambda-utils';

const { NAMESPACE, LOG_LEVEL, REDIRECT_URI } = process.env;

const pt = makePowerTools({ prefix: `delete-session-${NAMESPACE}` });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log({ message: `${pt.serviceName} starting`, event });
  const state = event.queryStringParameters?.state;

  const session = await getSession(event);
  const body: Record<string, string> = {};
  if (session) {
    const resp = await Session.delete(getSessionKey(session.session_id));
    if (resp.$metadata.httpStatusCode !== 200) {
      body.message = 'session termination failed, status=' + resp.$metadata.httpStatusCode;
    } else {
      body.message = 'session terminated'
    }
  } else {
    body.message = 'no session'
  }

  return {
    body: JSON.stringify(body),
    statusCode: 302,
    headers: {
      "Location": state || REDIRECT_URI!,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST",
    },
  }
}

export const main = prepareAPIGateway(lambdaHandler);
