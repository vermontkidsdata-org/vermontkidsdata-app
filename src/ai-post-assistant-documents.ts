import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantDocument, Document, getAssistantDocumentKey, getAssistantKey, getDocumentKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";
import { HttpStatusCode } from "axios";

const SERVICE = 'ai-put-assistant';

const pt = makePowerTools({ prefix: SERVICE });

interface PostAssistantDocumentCommand {
  commands: {
    command: 'add' | 'remove';
    identifier: string;
  }[];
}

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
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
  } else if (assItem.sandbox) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Sandbox assistants cannot have documents",
      })
    }
  }

  // Only active ones can be published
  if (!assItem.active) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Assistant must be active to be updated",
      })
    }
  }

  if (!event.body) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing body",
      })
    }
  }

  const { commands } = JSON.parse(event.body) as PostAssistantDocumentCommand;
  pt.logger.info({ message: 'commands to execute', assistantId, commands });

  // Wait 5 seconds
  pt.logger.info({ message: 'waiting 5 seconds' });
  await new Promise(resolve => setTimeout(resolve, 5000));

  for (const command of commands) {
    if (command.command === 'add') {// Add document
      // First get the document (must exist, obviously)
      const pk = getDocumentKey(command.identifier);
      pt.logger.info({ message: 'adding document to assistant', assistantId, command, pk });
      const docRow = await Document.get(pk, {
        consistent: true, // Might be a race condition
      });
      pt.logger.info({ message: 'fetched document?', assistantId, command, docRow });
      if (!docRow.Item) {
        return {
          statusCode: HttpStatusCode.BadRequest,
          body: JSON.stringify({
            message: "Document not found",
            identifier: command.identifier,
            pk
          })
        }
      }

      await AssistantDocument.put({
        assistantId,
        identifier: command.identifier,
        bucket: docRow.Item.bucket,
        key: docRow.Item.key,
      });
    } else if (command.command === 'remove') {// Remove document
      await AssistantDocument.delete(getAssistantDocumentKey(assistantId, command.identifier));
    } else {
      return {
        statusCode: HttpStatusCode.BadRequest,
        body: JSON.stringify({
          message: "Invalid command",
          command,
        })
      }
    }
  }

  return {
    statusCode: HttpStatusCode.Ok,
    body: JSON.stringify({
      message: "Commands executed",
      assistantId,
      commands,
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