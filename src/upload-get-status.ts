
import { APIGatewayProxyEventV2, APIGatewayProxyStructuredResultV2 } from "aws-lambda";
import { UploadStatus, getUploadStatusKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { CORSConfigDefault } from "./cors-config";

const {VKD_ENVIRONMENT } = process.env;

const pt = makePowerTools({ prefix: `upload-get-status-${VKD_ENVIRONMENT}` });

// Helper function to get CORS headers
function getCORSHeaders(origin: string | undefined): Record<string, string> {
  const allowedOrigin = CORSConfigDefault.getOrigin(origin, CORSConfigDefault);
  return {
    "Access-Control-Allow-Origin": allowedOrigin === 'FORBIDDEN' ? '*' : allowedOrigin,
    "Access-Control-Allow-Credentials": allowedOrigin !== 'FORBIDDEN' ? 'true' : 'false',
    "Content-Type": "application/json",
    "Access-Control-Allow-Methods": "GET",
  };
}

export async function lambdaHandler(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyStructuredResultV2> {
  const origin = event.headers?.origin;
  const corsHeaders = getCORSHeaders(origin);
  
  const { id } = event.pathParameters!;
  if (id == null) {
    return {
      statusCode: 400,
      headers: corsHeaders,
      body: JSON.stringify({ message: `id is required` }),
    };
  }

  try {
    const uploadStatus = await UploadStatus.get(getUploadStatusKey(id));

    if (uploadStatus.Item == null) {
      return {
        statusCode: 404,
        headers: corsHeaders,
        body: JSON.stringify({ message: `Upload status not found for id: ${id}` }),
      };
    }

    return {
      statusCode: 200,
      headers: corsHeaders,
      body: JSON.stringify({
        status: uploadStatus.Item.status,
        numRecords: uploadStatus.Item.numRecords,
        percent: uploadStatus.Item.percent,
        errors: uploadStatus.Item.errors,
        lastUpdated: uploadStatus.Item.lastUpdated,
      }),
    };
  } catch (error) {
    console.error('Error fetching upload status:', error);
    return {
      statusCode: 500,
      headers: corsHeaders,
      body: JSON.stringify({ message: 'Internal server error' }),
    };
  }
}

export const handler = prepareAPIGateway(lambdaHandler);

// if (!module.parent) {
//   (async () => {
//     console.log(await lambdaHandler({ pathParameters: { uploadId: "b9752e4c-cd99-472f-9b70-9f4a15b96a62" } } as any));
//   })();
// }