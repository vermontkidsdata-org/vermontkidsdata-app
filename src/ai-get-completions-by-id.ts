import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Completion, getConversationKeyAttribute } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { generatePresignedUrl } from "./ai-utils";

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

  // Format the response similar to the existing endpoint
  const completions = await Promise.all(
    queryResult.Items.map(item => createResponseObject(item))
  );

  return {
    statusCode: 200,
    body: JSON.stringify({
      responses: completions,
    }),
  }
});