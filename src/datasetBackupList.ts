if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.VKD_ENVIRONMENT = 'qa';
}

import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { forEachDatasetVersion } from './db-utils';
import { makePowerTools, prepareAPIGateway } from './lambda-utils';

const pt = makePowerTools({ prefix: `get-dataset-backups-${process.env.VKD_ENVIRONMENT}` });

export async function lambdaHandler(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyResultV2> {
  const dataset = event.pathParameters?.dataset;
  if (!dataset) {
    pt.logger.error("Missing dataset", { event });
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
      versions,
    }),
  }
}

export const main = prepareAPIGateway(lambdaHandler);
