import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { getAllDocuments } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";
import { VKD_API_KEY } from "../lib/ai-assistant-construct";

const pt = makePowerTools({ prefix: 'ai-get-documents' });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  // See if we should include inactive ones, or non-default types
  const includeInactive = event.queryStringParameters?.includeInactive === 'true';

  const documents = await getAllDocuments({ includeInactive });
  return {
    statusCode: 200,
    body: JSON.stringify({
      documents,
    }),
  }
}

export const handler = prepareAPIGateway(lambdaHandler);

if (!module.parent) {
  (async () => {
    const event = {
      queryStringParameters: {
        key: VKD_API_KEY,
      },
    } as any;
    const result = await lambdaHandler(event);
    console.log(result);
  })();
}