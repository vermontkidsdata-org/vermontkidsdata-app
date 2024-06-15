if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.NAMESPACE = 'qa';
}

import { GetObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { DatasetVersion, getDatasetVersionKey } from './db-utils';
import { makePowerTools, prepareAPIGateway } from './lambda-utils';

const pt = makePowerTools({ prefix: `get-dataset-backup-${process.env.NAMESPACE}` });

const { REGION, S3_BUCKET_NAME } = process.env;
const s3 = new S3Client({ region: REGION });

export async function lambdaHandler(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyResultV2> {
  if (!S3_BUCKET_NAME) {
    throw new Error("S3_BUCKET_NAME not set");
  }

  const dataset = event.pathParameters?.dataset;
  const version = event.pathParameters?.version;
  if (!dataset || !version) {
    pt.logger.error("Missing dataset and/or version", { event });
    throw new Error("Missing dataset and/or version");
  }

  const datasetVersion = await DatasetVersion.get(getDatasetVersionKey(dataset, version));
  if (!datasetVersion.Item) {
    pt.logger.error("Unknown dataset version", { dataset, version });
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Dataset version not found",
      }),
    }
  }

  const backup = await s3.send(new GetObjectCommand({
    Bucket: S3_BUCKET_NAME,
    Key: `backups/${dataset}/${datasetVersion.Item.identifier}.csv`,
  }));
  
  if (!backup.Body) {
    pt.logger.error("No backup body", { dataset, version });
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Dataset version has no content",
      }),
    }
  }

  const body =  await backup.Body.transformToString();
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/csv',
    },
    body,
  }
}

export const main = prepareAPIGateway(lambdaHandler);
