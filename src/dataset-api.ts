import { injectLambdaContext } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { CORSConfigDefault } from './cors-config';
import * as datasetApiPost from './dataset-api-post';

export const handlerPost = middy(datasetApiPost.lambdaHandler)
  .use(captureLambdaHandler(datasetApiPost.tracer))
  .use(injectLambdaContext(datasetApiPost.logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault)
  );
