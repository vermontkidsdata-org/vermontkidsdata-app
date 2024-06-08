import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Completion, getCompletionPK } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const { VKD_API_KEY } = process.env;

const pt = makePowerTools({ prefix: 'ai-post-update' });

interface PostUpdateRequest {
  key: string,
  reaction?: string, // A simple thumbs up or thumbs down kind of thing
  comment?: string, // A more detailed comment
}

export const handler = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  const id = event.pathParameters?.id;
  const sortKey = event.pathParameters?.sortKey;
  if (id == null || sortKey == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Invalid request",
      }),
    }
  }

  const { key, ...data } = JSON.parse(event.body || '{}') as PostUpdateRequest;
  if (key !== VKD_API_KEY) {
    return {
      statusCode: 403,
      body: JSON.stringify({
        "message": "Invalid API key",
      })
    };
  }

  // Fetch the thread from the database
  const pk = getCompletionPK(id, parseInt(sortKey));
  const record = await Completion.get(pk);
  if (record?.Item?.thread == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Conversation not found",
        id,
        sortKey,
      }),
    }
  }

  // Update the record with the reaction and comment
  const item = record.Item;
  item.reaction = data.reaction ?? item.reaction;
  item.comment = data.comment ?? item.comment;
  await Completion.update(item);

  return {
    statusCode: 200,
    body: JSON.stringify({
      response: {
        id: item.id,
        sortKey: item.sortKey,
        status: item.status,
        query: item.query,
        message: item.message,
        created: item.created,
        modified: item.modified,
        reaction: item.reaction,
        comment: item.comment,
      },
    })
  }
});