if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.NAMESPACE = 'qa';
}

import { Logger, injectLambdaContext } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { Tracer, captureLambdaHandler } from '@aws-lambda-powertools/tracer';
import { GetObjectCommand, S3Client } from '@aws-sdk/client-s3';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayEvent, APIGatewayProxyResultV2 } from 'aws-lambda';
import { CORSConfigDefault } from './cors-config';
import { DatasetVersion, getDatasetVersionKey } from './db-utils';
import { processUpload } from './uploadData';

// Set your service name. This comes out in service lens etc.
const serviceName = `get-dataset-backups-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: (process.env.LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});
const tracer = new Tracer({ serviceName });

const { REGION, S3_BUCKET_NAME } = process.env;
const s3 = new S3Client({ region: REGION });

export async function lambdaHandler(event: APIGatewayEvent): Promise<APIGatewayProxyResultV2> {
  if (!S3_BUCKET_NAME) {
    throw new Error("S3_BUCKET_NAME not set");
  }

  const dataset = event.pathParameters?.dataset;
  const version = event.pathParameters?.version;
  if (!dataset || !version) {
    logger.error("Missing dataset and/or version", { event });
    throw new Error("Missing dataset and/or version");
  }

  const datasetVersion = await DatasetVersion.get(getDatasetVersionKey(dataset, version));
  if (!datasetVersion.Item) {
    logger.error("Unknown dataset version", { dataset, version });
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Dataset version not found",
      }),
    }
  }
  const { identifier } = datasetVersion.Item;

  const backup = await s3.send(new GetObjectCommand({
    Bucket: S3_BUCKET_NAME,
    Key: `backups/${dataset}/${identifier}.csv`,
  }));

  if (!backup.Body) {
    logger.error("No backup body", { dataset, version });
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Dataset version has no content",
      }),
    }
  }

  const body = await backup.Body.transformToString();

  // Now revert the dataset.
  await processUpload({
    bodyContents: body,
    uploadType: dataset,
    identifier,
    doTruncateTable: true,
  });

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Dataset reverted",
    }),
  };
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  .use(
    cors(CORSConfigDefault),
  );
