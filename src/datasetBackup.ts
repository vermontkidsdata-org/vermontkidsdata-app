if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.NAMESPACE = 'qa';
}

import { injectLambdaContext } from '@aws-lambda-powertools/logger/middleware';
import { captureLambdaHandler } from '@aws-lambda-powertools/tracer/middleware';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import middy from '@middy/core';
import { SQSEvent } from 'aws-lambda';
import { DatasetVersion, STATUS_DATASET_VERSION_SUCCESS, getDatasetVersionKey } from './db-utils';
import { getCSVData, isErrorResponse } from './download';
import { makePowerTools } from './lambda-utils';
import { DatasetBackupMessage } from './uploadData';

// Set your service name. This comes out in service lens etc.
const pt = makePowerTools({ prefix: `download-${process.env.NAMESPACE}` });

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

      pt.logger.info("Backup done", { dataset: body.dataset, identifier: body.identifier });
    }
  }
}

export const main = middy(lambdaHandler)
  .use(captureLambdaHandler(pt.tracer))
  .use(injectLambdaContext(pt.logger))
  ;
