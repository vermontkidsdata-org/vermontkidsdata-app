import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, getAssistantKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";
import { HttpStatusCode } from "axios";
import { removeVkdProperties } from "./assistant-def";

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

  // Only active ones can be updated
  if (!assItem.active) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Assistant must be active to be updated",
      })
    }
  }

  // Parse the request body to get the updated assistant definition
  if (!event.body) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing request body",
      })
    }
  }

  try {
    const requestBody = JSON.parse(event.body);
    const updatedDefinition = requestBody.definition;
    
    if (!updatedDefinition) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Missing assistant definition in request body",
        })
      }
    }

    // Update the assistant record
    const updatedAssistant = {
      ...assItem,
      definition: updatedDefinition,
      // Update the modified timestamp if it exists in the record
      ...(assItem.definition.modified && {
        definition: {
          ...updatedDefinition,
          modified: new Date().toISOString()
        }
      })
    };

    pt.logger.info({ message: 'Updating assistant', assistantId, updatedAssistant });
    
    // Save the updated assistant to the database
    await Assistant.put(updatedAssistant);

    // Return the updated assistant (without internal _vkd properties for the response)
    const responseAssistant = {
      ...updatedAssistant,
      definition: removeVkdProperties(updatedAssistant.definition)
    };

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Assistant updated successfully",
        assistant: responseAssistant
      })
    }
  } catch (error) {
    pt.logger.error({ message: 'Error updating assistant', error });
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Error updating assistant",
        error: (error as Error).message
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