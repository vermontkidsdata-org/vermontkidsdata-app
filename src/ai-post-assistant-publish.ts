import { APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantFunction, AssistantFunctionData, getAllAssistantFunctions, getAllAssistants, getAssistantFunctionKey, getAssistantKey, getAssistantKeyAttribute, getNamespace, PublishedAssistant } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { connectOpenAI, getOpenAI, validateAPIAuthorization } from "./ai-utils";
import { removeVkdProperties } from "./assistant-def";
import OpenAI from "openai";

const SERVICE = 'ai-post-assistant-publish';

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
  const ns = getNamespace();

  const envName = (ns + (sandbox ? `/${sandbox}` : '')).toLowerCase();

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
    const { entity, created, modified, ...assistantDef} = assRow.Item.definition;
    pt.logger.info({ message: 'assistant before tools added', assistant: assistantDef, assFunctions });
    if (!assistantDef.tools) {
      assistantDef.tools = [];
    }
    assFunctions.forEach((assFunction) => {
      const { 
        seriesParameter, categoryParameter, otherParameters, 
        entity, created, modified, functionId, assistantId,
        ...functionDef
      } = assFunction;

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
      const functionRoot = {
        type: "function",
        function: functionDef,
      };
      (functionDef as any).parameters = {
        type: "object",
        properties,
      };
      assistantDef.tools.push(functionRoot);
    });

    assistantDef.name = `Vermont Kids Data Assistant with Functions (${envName})`;
    
    pt.logger.info({ message: 'assistant to define in OpenAI', assistantDef });

    await connectOpenAI();
    const openai = getOpenAI();

    // Remove from function? Yes except for _vkd. We'll remove that right before
    // we actually publish it using the existing function.
    const createDef = removeVkdProperties(assistantDef);
    const resp = await openai.beta.assistants.create(createDef);

    await PublishedAssistant.put({
      name: envName,
      definition: assistantDef,
    });
      
    return {
      statusCode: 200,
      body: JSON.stringify({
        assistant: resp
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