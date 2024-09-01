import { APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantFunction, AssistantFunctionData, getAllAssistantFunctions, getAllAssistants, getAssistantFunctionKey, getAssistantKey, getAssistantKeyAttribute } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";

const SERVICE = 'ai-post-assistant-publish';

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
        message: "Missing id or functionId",
      })
    }
  }

  const assRow = await Assistant.get(getAssistantKey(assistantId));
  if (!assRow?.Item) {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: "Function not found",
      })
    }
  } else {
    const assFunctions = await getAllAssistantFunctions(assistantId);
    const assistant = assRow.Item.definition;
    pt.logger.info({message: 'assistant before tools added', assistant, assFunctions });
    if (!assistant.tools) {
      assistant.tools = [];
    }
    assFunctions.forEach((assFunction) => {
      const { seriesParameter, categoryParameter, otherParameters, ...functionDef } = assFunction;
      const properties = {} as Record<string, {
        description: string,
        type: string,
        enum?: string[],
        _vkd?: {
          type: string,
        }
      }>;
      if (seriesParameter) {
        properties[seriesParameter.name] = {
          type: seriesParameter.type,
          description: seriesParameter.description,
          enum: seriesParameter.enum,
          _vkd: seriesParameter._vkd,
        };
      }
      (functionDef as any).parameters = {
        type: "object",
        properties,
      };
      assistant.tools.push(functionDef);
    });

    // Remove from function? Yes except for _vkd. We'll remove that right before
    // we actually publish it using the existing function.
    //
    // _vkd, entity, created, functionId, assistantId, 
    // seriesParameter, categoryParameter, otherParameters
    //    parameters: {
    //     type: "object",
    //     properties: { 
    //    -> name: description, type, enum
    return {
      statusCode: 200,
      body: JSON.stringify({
        assistant,
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