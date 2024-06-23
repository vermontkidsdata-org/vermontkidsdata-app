if (!module.parent) {
  process.env.REGION = 'us-east-1';
  process.env.VKD_ENVIRONMENT = 'qa';
}

import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBCommit, doDBOpen, doDBQuery } from './db-utils';
import { makePowerTools } from './lambda-utils';
import { getUploadType } from './uploadData';

// Set your service name. This comes out in service lens etc.
const pt = makePowerTools({ prefix: `post-dataset-${process.env.VKD_ENVIRONMENT}` });

export async function updateDataset(dataset: string, { name }: { name?: string }): Promise<APIGatewayProxyResultV2> {
  await doDBOpen();
  try {
    const uploadType = await getUploadType(dataset);
    if (typeof uploadType === 'string') {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: uploadType,
        }),
      };
    }

    const updates: string[] = [];
    const params: any[] = [];
    if (name != null) {
      updates.push('name = ?');
      params.push(name);
    }

    // If nothing there, don't do anything
    if (updates.length) {
      // Do it!
      const sql = 'update upload_types set ' + updates.join(', ') + ' where `type` = ?';
      params.push(dataset);

      pt.logger.info({ message: 'updateDataset', sql, params });
      await doDBQuery(sql, params);

      await doDBCommit();

      return {
        statusCode: 200,
        body: JSON.stringify(
          {
            message: `dataset info updated`,
          },
        ),
      }
    } else {
      return {
        statusCode: 200,
        body: JSON.stringify(
          {
            message: `no changes recorded`,
          },
        ),
      }
    }  
  } finally {
    await doDBClose();
  }
}

export async function lambdaHandler(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: pt.serviceName, event });

  const dataset = event.pathParameters?.dataset;
  const body = event.body;

  if (body == null || dataset == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'empty body or dataset passed',
      }),
    };
  }

  // Name is the thing we can update right now
  const { name } = JSON.parse(body);
  return await updateDataset(dataset, { name });
}
