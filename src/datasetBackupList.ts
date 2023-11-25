if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.NAMESPACE = 'qa';
}

import { Logger, injectLambdaContext } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { Tracer, captureLambdaHandler } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import { APIGatewayEvent, APIGatewayProxyResultV2 } from 'aws-lambda';
import { forEachDatasetVersion } from './db-utils';

// Set your service name. This comes out in service lens etc.
const serviceName = `get-dataset-backups-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: (process.env.LOG_LEVEL || 'INFO') as LogLevel,
  serviceName
});
const tracer = new Tracer({ serviceName });

export async function lambdaHandler(event: APIGatewayEvent): Promise<APIGatewayProxyResultV2> {
  const dataset = event.pathParameters?.dataset;
  if (!dataset) {
    logger.error("Missing dataset", { event });
    throw new Error("Missing dataset");
  }

  const versions: any[] = [];
  await forEachDatasetVersion(dataset, async (datasetVersion) => {
    versions.push({
      version: datasetVersion.version,
      identifier: datasetVersion.identifier,
      numrows: datasetVersion.numrows,
      status: datasetVersion.status,
    })
  });

  return {
    statusCode: 200,
    body: JSON.stringify({
      versions
    }),
  }
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  ;
