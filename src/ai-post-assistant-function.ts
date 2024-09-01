import { APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantFunction, AssistantFunctionData, getAllAssistantFunctions, getAllAssistants, getAssistantFunctionKey, getAssistantKey, getAssistantKeyAttribute } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";
import { FunctionBody } from "./models/api";

const SERVICE = 'ai-post-assistant-function';

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
  if (!assistantId) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing assistantId",
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
  
  const functionBody = JSON.parse(event.body || '{}') as FunctionBody;

  // Don't let two functions have the same name
  const assFunctions = await getAllAssistantFunctions(assistantId);
  for (const assFunction of assFunctions) {
    if (assFunction.name === functionBody.name) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: `Function name already exists`,
          name: functionBody.name,
        })
      }
    }
  }

  const functionId = Date.now().toString();
  await AssistantFunction.put({
    ...functionBody,
    assistantId,
    functionId,
  });

  return {
    statusCode: 201,
    body: JSON.stringify({
      functionId,
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