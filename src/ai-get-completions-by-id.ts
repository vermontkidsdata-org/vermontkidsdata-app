import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Completion, getConversationKeyAttribute } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const pt = makePowerTools({ prefix: 'ai-get-completions-by-id' });

export const handler = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Invalid request - missing id parameter",
      }),
    }
  }

  pt.logger.info({ message: 'Retrieving all completions for conversation', id });
  
  // Query all completions with the given id as partition key
  const queryResult = await Completion.query(getConversationKeyAttribute(id));

  if (!queryResult.Items || queryResult.Items.length === 0) {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: "Conversation not found",
        id,
      }),
    }
  }

  // Format the response similar to the existing endpoint
  const completions = queryResult.Items.map(item => ({
    id: item.id,
    sortKey: item.sortKey,
    status: item.status,
    query: item.query,
    message: item.message,
    title: item.title,
    created: item.created,
    modified: item.modified,
    reaction: item.reaction,
    comment: item.comment,
  }));

  return {
    statusCode: 200,
    body: JSON.stringify({
      responses: completions,
    }),
  }
});