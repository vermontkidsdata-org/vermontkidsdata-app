import { APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantFunction, AssistantFunctionData, getAllAssistantFunctions, getAllAssistants, getAssistantFunctionKey, getAssistantKey, getAssistantKeyAttribute } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";

const SERVICE = 'ai-put-assistant-function';

const pt = makePowerTools({ prefix: SERVICE });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<any>
): Promise<APIGatewayProxyResultV2> {
  console.log({message: SERVICE, event });
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  const assistantId = event.pathParameters?.id;
  const functionId = event.pathParameters?.functionId;
  if (!assistantId || !functionId) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing id or functionId",
      })
    }
  }

  const assFunction = await AssistantFunction.get(getAssistantFunctionKey(assistantId, functionId));
  if (!assFunction?.Item) {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: "Function not found",
      })
    }
  } else {
    const item = JSON.parse(event.body || '{}') as AssistantFunctionData;
    await AssistantFunction.update({
      ...item,
      assistantId,
      functionId,
    });
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Function updated",
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