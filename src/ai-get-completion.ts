import { SFNClient } from "@aws-sdk/client-sfn";
import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Completion, getCompletionPK } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const pt = makePowerTools({ prefix: 'ai-get-completion' });

const sfn = new SFNClient({});

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

  // Parse the sortKey
  const sortKeyNum = parseInt(sortKey);
  
  // Fetch the specific completion from the database
  const record = await Completion.get(getCompletionPK(id, sortKeyNum));
  if (record?.Item?.status == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Conversation not found",
        id,
        sortKey,
      }),
    }
  }

  // Check if the client wants the full conversation history
  const includeHistory = event.queryStringParameters?.includeHistory === 'true';
  
  if (includeHistory) {
    pt.logger.info({ message: 'Retrieving full conversation history', id, sortKey: sortKeyNum });
    
    // Fetch all messages in this conversation up to the requested sortKey
    const allMessages = [];
    for (let i = 0; i <= sortKeyNum; i++) {
      const msgRecord = await Completion.get(getCompletionPK(id, i));
      if (msgRecord?.Item) {
        allMessages.push({
          id: msgRecord.Item.id,
          sortKey: msgRecord.Item.sortKey,
          status: msgRecord.Item.status,
          query: msgRecord.Item.query,
          message: msgRecord.Item.message,
          title: msgRecord.Item.title,
          created: msgRecord.Item.created,
          modified: msgRecord.Item.modified,
          reaction: msgRecord.Item.reaction,
          comment: msgRecord.Item.comment,
        });
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
          title: record.Item.title,
          created: record.Item.created,
          modified: record.Item.modified,
          reaction: record.Item.reaction,
          comment: record.Item.comment,
        },
        history: allMessages,
      }),
    }
  } else {
    // Return just the requested message (original behavior)
    return {
      statusCode: 200,
      body: JSON.stringify({
        response: {
          id: record.Item.id,
          sortKey: record.Item.sortKey,
          status: record.Item.status,
          query: record.Item.query,
          message: record.Item.message,
          title: record.Item.title,
          created: record.Item.created,
          modified: record.Item.modified,
          reaction: record.Item.reaction,
          comment: record.Item.comment,
        },
      }),
    }
  }
});