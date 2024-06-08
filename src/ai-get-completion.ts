import { SFNClient } from "@aws-sdk/client-sfn";
import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Completion, getCompletionPK } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const { ASSISTANT_ID, VKD_API_KEY } = process.env;

const pt = makePowerTools({ prefix: 'ai-post-completion' });

const sfn = new SFNClient({});

interface PostCompletionRequest {
  key: string,
  id: string,
  sortKey: number,
  query: string
}

export const handler = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  if (ASSISTANT_ID == null) {
    throw new Error('ASSISTANT_ID is not set');
  }

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

  // Fetch the thread from the database
  const record = await Completion.get(getCompletionPK(id, parseInt(sortKey)));
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

  return {
    statusCode: 200,
    body: JSON.stringify({
      response: {
        id: record.Item.id,
        sortKey: record.Item.sortKey,
        status: record.Item.status,
        query: record.Item.query,
        message: record.Item.message,
        created: record.Item.created,
        modified: record.Item.modified,
        reaction: record.Item.reaction,
        comment: record.Item.comment,
      },
    })
  }
});