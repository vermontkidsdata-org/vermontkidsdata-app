import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, getAllAssistants, getAssistantKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";

const SERVICE = 'ai-post-assistant-enable';

const pt = makePowerTools({ prefix: SERVICE });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<any>
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: SERVICE, event });
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  const enable = JSON.parse(event.body ?? '{}').enable ?? true;

  const assistantId = event.pathParameters?.id;
  if (!assistantId) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing id or functionId",
      })
    }
  }

  // Check first if already in the requested state
  const assRow = await Assistant.get(getAssistantKey(assistantId));
  const assItem = assRow?.Item;
  if (!assItem) {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: "Assistant not found",
      })
    }
  }

  if (assItem.active === enable) {
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Already in requested state, no change",
      })
    }
  }

  // We can always disable
  if (!enable) {
    await Assistant.update({
      ...assItem,
      id: assistantId,
      active: false,
    });
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Assistant disabled",
      })
    }
  }

  // Before enabling, check to see if there's another assistant already enabled
  // in the same sandbox (or not in a sandbox).
  const existing = await getAllAssistants({ sandbox: assItem.sandbox });
  if (existing.length > 0) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Already an assistant enabled with same sandbox value",
        sandbox: assItem.sandbox,
      })
    }
  }

  // Enable the assistant
  await Assistant.update({
    ...assItem,
    id: assistantId,
    active: true,
  });
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Assistant enabled",
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