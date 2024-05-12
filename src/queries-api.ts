import { injectLambdaContext } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { CORSConfigDefault } from './cors-config';
import * as queriestApiDelete from './queries-api-delete';
import * as queriestApiGet from './queries-api-get';
import * as queriestApiGetList from './queries-api-getList';
import * as queriestApiPost from './queries-api-post';
import * as queriestApiPut from './queries-api-put';

export const handlerGet = middy(queriestApiGet.lambdaHandler)
  .use(captureLambdaHandler(queriestApiGet.tracer))
  .use(injectLambdaContext(queriestApiGet.logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault),
  );

export const handlerGetList = middy(queriestApiGetList.lambdaHandler)
  .use(captureLambdaHandler(queriestApiGetList.tracer))
  .use(injectLambdaContext(queriestApiGetList.logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault),
  );

export const handlerPost = middy(queriestApiPost.lambdaHandler)
  .use(captureLambdaHandler(queriestApiPost.tracer))
  .use(injectLambdaContext(queriestApiPost.logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault),
  );

export const handlerDelete = middy(queriestApiDelete.lambdaHandler)
  .use(captureLambdaHandler(queriestApiDelete.tracer))
  .use(injectLambdaContext(queriestApiDelete.logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault),
  );

export const handlerPut = middy(queriestApiPut.lambdaHandler)
  .use(captureLambdaHandler(queriestApiPut.tracer))
  .use(injectLambdaContext(queriestApiPut.logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault),
  );
