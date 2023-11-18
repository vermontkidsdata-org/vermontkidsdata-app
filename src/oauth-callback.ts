import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import axios from 'axios';
import { randomUUID } from 'crypto';
import express from 'express';
import { Session } from './db-utils';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
const { LOG_LEVEL, IS_PRODUCTION, ENV_NAME, MY_URI, MY_DOMAIN, SERVICE_TABLE, REDIRECT_URI, COGNITO_CLIENT_ID, COGNITO_SECRET, AWS_REGION } = process.env;

export const serviceName = `oauth-callback-${ENV_NAME}`;
export const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName: serviceName
});
export const tracer = new Tracer({ serviceName: serviceName });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  const code = event.queryStringParameters?.code;
  const state = event.queryStringParameters?.state;
  const isProduction = IS_PRODUCTION === 'true';

  console.log({ message: 'oauth-callback starting', event, code, state });

  if (COGNITO_CLIENT_ID == null || COGNITO_SECRET == null || REDIRECT_URI == null || SERVICE_TABLE == null || MY_URI == null || MY_DOMAIN == null) {
    return {
      body: JSON.stringify({ message: 'Cognito callback needs COGNITO_CLIENT_ID, COGNITO_SECRET, SERVICE_TABLE and REDIRECT_URI' }),
      statusCode: 500,
    };
  }

  const queryString = Object.entries({
    redirect_uri: MY_URI,
    code: code,
    grant_type: 'authorization_code',
    client_id: COGNITO_CLIENT_ID,
    client_secret: COGNITO_SECRET
  })
    .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(v || '')}`)
    .join('&');

  console.log({ message: 'qs', queryString });
  // Call cognito
  let resp = await axios({
    method: 'post',
    url: 'https://vkd.auth.us-east-1.amazoncognito.com/oauth2/token',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    auth: {
      username: COGNITO_CLIENT_ID,
      password: COGNITO_SECRET
    },
    data: queryString
  });
  const { data } = resp;
  const { access_token, refresh_token, id_token } = data;
  console.log({ access_token, refresh_token });

  const cookie = randomUUID();

  await Session.put({
    session_id: cookie,
    domain: MY_DOMAIN,
    access_token,
    id_token,
    refresh_token,
  });

  return {
    body: JSON.stringify({ message: 'Successful session create' }),
    statusCode: 302,
    headers: {
      "Location": state || REDIRECT_URI,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST",
      "Set-Cookie": `VKD_AUTH=${cookie}; path=/; domain=${MY_DOMAIN}${isProduction ? '; SameSite=Lax' : '; SameSite=None'}; secure; HttpOnly; Max-Age=3540`
    }
  };
}

if (!module.parent) {
  (async () => {
    const app = express();

    app.get('/oauthcallback', async function (req, res, next) {
      try {
        const code = req.query.code?.toString()!;
        console.log({ message: 'calling main', code });
        const result = await lambdaHandler({
          queryStringParameters: {
            code
          }
        } as unknown as APIGatewayProxyEventV2);
        console.log({ message: 'done with main', result });
        res.json(result);
      } catch (e) {
        next(e);
      }
    });

    app.listen(3000);
  })();
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger));
