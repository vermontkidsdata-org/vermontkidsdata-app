import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantFunction, getAllAssistantFunctions, getAllAssistants, getAssistantKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";

const SERVICE = 'ai-post-assistant-clone';

const pt = makePowerTools({ prefix: SERVICE });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<any>
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: SERVICE, event });
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  const sandbox = JSON.parse(event.body ?? '{}').sandbox;

  const assistantId = event.pathParameters?.id;
  if (!assistantId) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing id or functionId",
      })
    }
  }

  const assRow = await Assistant.get(getAssistantKey(assistantId));
  if (!assRow?.Item) {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: "Assistant not found",
      })
    }
  } else {
    // See whether the proposed one already exists
    const existing = await getAllAssistants({sandbox});
    if (existing.length > 0) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Sandbox assistant already exists",
          sandbox,
        })
      }
    }

    const assItem = assRow.Item;
    assItem.sandbox = sandbox;

    const assFunctions = await getAllAssistantFunctions(assistantId);
    
    // Now create the clone
    const newAssistantId = Date.now().toString();
    await Assistant.put({
      ...assItem,
      id: newAssistantId,
      sandbox,
      active: true,
    });

    for (const assFn of assFunctions) {
      const fnKey = Date.now().toString();
      await AssistantFunction.put({
        ...assFn,
        functionId: fnKey,
        assistantId: newAssistantId,
      });
    }

    return {
      statusCode: 200,
      body: JSON.stringify({
        assistantId: newAssistantId
      })
    }
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