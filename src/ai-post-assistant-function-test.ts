import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantFunction, getAssistantFunctionKey, getAssistantKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";

const SERVICE = 'ai-post-assistant-function-test';

const pt = makePowerTools({ prefix: SERVICE });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<any>
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({message: SERVICE, event });
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
        message: "Missing assistantId/functionId",
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
  }
  
  const funcitem = await AssistantFunction.get(getAssistantFunctionKey(assistantId, functionId));

  // Pull the function parameters
  const body = JSON.parse(event.body || '{}');

  // Call the function
  
  return {
    statusCode: 201,
    body: JSON.stringify({
      functionId,
      funcitem,
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