
import { APIGatewayProxyEventV2, APIGatewayProxyStructuredResultV2 } from "aws-lambda";
import { UploadStatus, getUploadStatusKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const {NAMESPACE, } = process.env;

const pt = makePowerTools({ prefix: `upload-get-status-${NAMESPACE}` });

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

export const handler = prepareAPIGateway(lambdaHandler);

// if (!module.parent) {
//   (async () => {
//     console.log(await lambdaHandler({ pathParameters: { uploadId: "b9752e4c-cd99-472f-9b70-9f4a15b96a62" } } as any));
//   })();
// }