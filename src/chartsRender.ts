import {APIGatewayEventRequestContextV2, APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2} from 'aws-lambda';
import { Liquid } from 'liquidjs';
import * as s3 from '@aws-sdk/client-s3';

const engine = new Liquid();

const S3_PREFIX = "s3://";

export async function bar(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  if (event.pathParameters == null || event.pathParameters.chartId == null) {
    return {
      statusCode: 400
    }; 
  } else {
    const chartId = event.pathParameters.chartId;

    // Has the s3:// part also
    const templateBucket = process.env['templateBucket']!;
    if (!templateBucket.startsWith(S3_PREFIX)) {
      return { statusCode: 500 }
    }
    const bucketName = templateBucket.substring(S3_PREFIX.length);

    const tpl = engine.parse('Welcome to {{v}}, id={{id}}!');
    const rendered = await engine.render(tpl, {v: "Liquid", id: chartId});

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html'
      },
      body: rendered
    };
  }
}

if (process.mainModule != null) {
  (async () => {
    console.log('from CLI');
    const event = {
      pathParameters: {
        chartId: 1234
      }
    };
    process.env['templateBucket'] = 's3://pipelinedevstage-censusa-templatedistributionbuck-15mcyw9ttm9f9';
    console.log(await bar(event as any));
  })();
}