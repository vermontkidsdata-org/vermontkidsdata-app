import { SFNClient } from "@aws-sdk/client-sfn";
import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Completion, getCompletionPK } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { generatePresignedUrl } from "./ai-utils";

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
  pt.logger.info({ message: 'Fetched completion record', id, sortKey: sortKeyNum });

  // Helper function to create response object with optional file link
  const createResponseObject = async (item: any) => {
    const responseObj: any = {
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
    };

    // Add file link if there's an uploaded file
    if (item.uploadedFileS3Path) {
      try {
        pt.logger.info({ message: 'Generating file link for completion', id: item.id, sortKey: item.sortKey, s3Path: item.uploadedFileS3Path });
        const fileLink = await generatePresignedUrl(item.uploadedFileS3Path, 3600); // 1 hour expiry
        responseObj.fileLink = fileLink;
        
        // Also include file metadata if available
        if (item.uploadedFileMetadata) {
          responseObj.fileMetadata = item.uploadedFileMetadata;
        }
        
        pt.logger.info({ message: 'Generated file link for completion', id: item.id, sortKey: item.sortKey });
      } catch (error) {
        pt.logger.error({ message: 'Error generating file link', error, id: item.id, sortKey: item.sortKey });
        // Don't fail the request if file link generation fails
      }
    }

    return responseObj;
  };

  // Check if the client wants the full conversation history
  const includeHistory = event.queryStringParameters?.includeHistory === 'true';
  
  if (includeHistory) {
    pt.logger.info({ message: 'Retrieving full conversation history', id, sortKey: sortKeyNum });
    
    // Fetch all messages in this conversation up to the requested sortKey
    const allMessages = [];
    for (let i = 0; i <= sortKeyNum; i++) {
      const msgRecord = await Completion.get(getCompletionPK(id, i));
      if (msgRecord?.Item) {
        const responseObj = await createResponseObject(msgRecord.Item);
        allMessages.push(responseObj);
      }
    }
    
    const mainResponse = await createResponseObject(record.Item);
    
    return {
      statusCode: 200,
      body: JSON.stringify({
        response: mainResponse,
        history: allMessages,
      }),
    }
  } else {
    // Return just the requested message (original behavior)
    const responseObj = await createResponseObject(record.Item);
    
    return {
      statusCode: 200,
      body: JSON.stringify({
        response: responseObj,
      }),
    }
  }
});