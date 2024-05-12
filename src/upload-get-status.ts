
import { Logger, injectLambdaContext } from "@aws-lambda-powertools/logger";
import { LogLevel } from "@aws-lambda-powertools/logger/lib/types";
import { Tracer, captureLambdaHandler } from "@aws-lambda-powertools/tracer";
import middy from "@middy/core";
import cors from "@middy/http-cors";
import { APIGatewayProxyEventV2, APIGatewayProxyStructuredResultV2 } from "aws-lambda";
import { CORSConfigDefault } from "./cors-config";
import { UploadStatus, getUploadStatusKey } from "./db-utils";

const { NAMESPACE, LOG_LEVEL } = process.env;

const serviceName = `charts-api-${NAMESPACE}`;
export const logger = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});
export const tracer = new Tracer({ serviceName });

export async function lambdaHandler(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyStructuredResultV2> {
  const { uploadId } = event.pathParameters!;
  if (uploadId == null) {
    return {
      statusCode: 400,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Access-Control-Allow-Methods": "GET",
      },
      body: JSON.stringify({ message: `uploadId is required` }),
    };
  }

  const uploadStatus = await UploadStatus.get(getUploadStatusKey(uploadId));

  if (uploadStatus.Item == null) {
    return {
      statusCode: 500,
    };
  } else {
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Access-Control-Allow-Methods": "GET",
      },
      body: JSON.stringify({
        status: uploadStatus.Item.status,
        numRecords: uploadStatus.Item.numRecords,
        percent: uploadStatus.Item.percent,
        errors: uploadStatus.Item.errors,
        lastUpdated: uploadStatus.Item.lastUpdated,
      }),
    };
  }
}

export const handler = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  .use(
    // cors(new CORSConfig(process.env))
    cors(CORSConfigDefault),
  );

// if (!module.parent) {
//   (async () => {
//     console.log(await lambdaHandler({ pathParameters: { uploadId: "b9752e4c-cd99-472f-9b70-9f4a15b96a62" } } as any));
//   })();
// }