import { APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantFunction, getAllAssistantFunctions, getAllAssistants, getAssistantFunctionKey, getAssistantKey, getAssistantKeyAttribute } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";

const pt = makePowerTools({ prefix: 'ai-get-asssistant-function' });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<any>,
): Promise<APIGatewayProxyResultV2> {
  console.log({message: "ai-get-assistant-function", event });
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  const id = event.pathParameters?.id;
  const functionId = event.pathParameters?.functionId;
  if (!id || !functionId) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing id or functionId",
      }),
    }
  }

  const assFunction = await AssistantFunction.get(getAssistantFunctionKey(id, functionId));
  if (!assFunction?.Item) {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: "Function not found",
      }),
    }
  } else {
    return {
      statusCode: 200,
      body: JSON.stringify({
        function: assFunction.Item,
      }),
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