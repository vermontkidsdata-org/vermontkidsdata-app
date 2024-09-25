import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, getAssistantKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";
import { HttpStatusCode } from "axios";

const SERVICE = 'ai-put-assistant';

const pt = makePowerTools({ prefix: SERVICE });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<any>
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: SERVICE, event });
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  const assistantId = event.pathParameters?.id;
  if (!assistantId) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing assistant id",
      })
    }
  }

  const assRow = await Assistant.get(getAssistantKey(assistantId));
  const assItem = assRow.Item;
  if (!assItem) {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: "Assistant not found",
      })
    }
  }

  // Only active ones can be published
  if (!assItem.active) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Assistant must be active to be updated",
      })
    }
  }

  // pt.logger.info({ message: 'assistant defn to update', assistantDef });

  return {
    statusCode: HttpStatusCode.NotImplemented,
    body: JSON.stringify({
      message: "Update assistant not yet implemented",
    })
  }
}

export const handler = prepareAPIGateway(lambdaHandler);

// if (!module.parent) {
//   (async () => {
//     const event = {
//       queryStringParameters: {
//         key: VKD_API_KEY,
//       },
//     } as any;
//     const result = await lambdaHandler(event);
//     console.log(result);
//   })();
// }