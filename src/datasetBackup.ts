if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.NAMESPACE = 'qa';
}

import { Logger, injectLambdaContext } from '@aws-lambda-powertools/logger';
import { LogLevel } from '@aws-lambda-powertools/logger/lib/types';
import { Tracer, captureLambdaHandler } from '@aws-lambda-powertools/tracer';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import middy from '@middy/core';
import { SQSEvent } from 'aws-lambda';
import { DatasetVersion, STATUS_DATASET_VERSION_SUCCESS, getDatasetVersionKey } from './db-utils';
import { getCSVData, isErrorResponse } from './download';
import { DatasetBackupMessage } from './uploadData';

// Set your service name. This comes out in service lens etc.
const serviceName = `download-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: (process.env.LOG_LEVEL || 'INFO') as LogLevel,
  serviceName
});
const tracer = new Tracer({ serviceName });

const { REGION, S3_BUCKET_NAME } = process.env;
const s3 = new S3Client({ region: REGION });

export async function lambdaHandler(event: SQSEvent): Promise<void> {
  if (!S3_BUCKET_NAME) {
    throw new Error("S3_BUCKET_NAME not set");
  }

  for (const record of event.Records) {
    // {"dataset":"general:residentialcare","version":"2023-11-24T14:07:43.874Z","identifier":"20231124-1"}
    console.log({ body: record.body, attributes: record.attributes, messageAttributes: record.messageAttributes });
    const body = JSON.parse(record.body) as DatasetBackupMessage;
    const resp = await getCSVData(body.dataset, Number.MAX_SAFE_INTEGER);
    if (isErrorResponse(resp)) {
      console.error("Error response from getCSVData", resp, body);
    } else {
      const csvData = resp.body;
      console.log("Got csvData", csvData);

      await s3.send(new PutObjectCommand({
        Bucket: S3_BUCKET_NAME,
        Key: `backups/${body.dataset}/${body.identifier}.csv`,
        Body: csvData,
      }));

      await DatasetVersion.update({
        ...(getDatasetVersionKey(body.dataset, body.version)),
        identifier: body.identifier,
        status: STATUS_DATASET_VERSION_SUCCESS,
        numrows: resp.numrows,
      });

      logger.info("Backup done", { dataset: body.dataset, identifier: body.identifier });
    }
  }
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  ;
