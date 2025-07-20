import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, getAssistantKey, getAllAssistants } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";
import { removeVkdProperties } from "./assistant-def";
import { ulid } from "ulid";

const SERVICE = 'ai-post-assistant';

const pt = makePowerTools({ prefix: SERVICE });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<any>
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: SERVICE, event });
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  // Parse the request body to get the assistant definition
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
    const definition = requestBody.definition;
    
    if (!definition) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Missing assistant definition in request body",
        })
      }
    }

    // Check if the type is provided
    const type = requestBody.type;
    if (!type) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Missing assistant type in request body",
        })
      }
    }
    
    // Check if there's already an assistant with the same type
    const existingAssistants = await getAllAssistants({ type });
    if (existingAssistants.length > 0) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "An assistant with this type already exists",
          type,
          existingAssistantId: existingAssistants[0].id
        })
      }
    }

    // Generate a new assistant ID
    const assistantId = ulid().toLowerCase();

    // Create the assistant record
    const newAssistant = {
      id: assistantId,
      type,
      name: requestBody.name || definition.name || 'Unnamed Assistant',
      definition: {
        ...definition,
        modified: new Date().toISOString()
      },
      active: true,
      ...(requestBody.sandbox && { sandbox: requestBody.sandbox }),
    };

    pt.logger.info({ message: 'Creating new assistant', assistantId, newAssistant });
    
    // Save the new assistant to the database
    await Assistant.put(newAssistant);

    // Return the created assistant (without internal _vkd properties for the response)
    const responseAssistant = {
      ...newAssistant,
      definition: removeVkdProperties(newAssistant.definition)
    };

    return {
      statusCode: 201,
      body: JSON.stringify({
        message: "Assistant created successfully",
        assistant: responseAssistant
      })
    }
  } catch (error) {
    pt.logger.error({ message: 'Error creating assistant', error });
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Error creating assistant",
        error: (error as Error).message
      })
    }
  }
}

export const handler = prepareAPIGateway(lambdaHandler);