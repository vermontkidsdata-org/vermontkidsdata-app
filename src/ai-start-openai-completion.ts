import { ChunkHandler, Footnote, askWithStreaming, connectOpenAI, getOpenAI, startAskWithoutStreaming } from "./ai-utils";
import { Completion, getCompletionPK, getPublishedAssistantKey, PublishedAssistant } from "./db-utils";
import { StepFunctionInputOutput, makePowerTools, prepareStepFunction } from "./lambda-utils";
import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { Readable } from "stream";
import { toFile } from "openai";

// const { ASSISTANT_ID } = process.env;

const pt = makePowerTools({ prefix: 'ai-start-openai-completion' });
const s3Client = new S3Client({ region: process.env.AWS_REGION || 'us-east-1' });

/**
 * Downloads a file from S3 and returns it as a readable stream
 */
async function downloadFromS3(bucket: string, key: string): Promise<Readable> {
  pt.logger.info({ message: 'Downloading file from S3', bucket, key });
  
  const command = new GetObjectCommand({
    Bucket: bucket,
    Key: key,
  });
  
  const response = await s3Client.send(command);
  
  if (!response.Body) {
    throw new Error('Empty response body from S3');
  }
  
  return response.Body as Readable;
}

/**
 * Parses an S3 path in the format bucket-name/path/to/file
 */
function parseS3Path(s3Path: string): { bucket: string, key: string } {
  const firstSlashIndex = s3Path.indexOf('/');
  
  if (firstSlashIndex === -1) {
    throw new Error(`Invalid S3 path format (missing '/'): ${s3Path}`);
  }
  
  const bucket = s3Path.substring(0, firstSlashIndex);
  const key = s3Path.substring(firstSlashIndex + 1);
  
  if (!bucket || !key) {
    throw new Error(`Invalid S3 path format (empty bucket or key): ${s3Path}`);
  }
  
  return { bucket, key };
}

export const lambdaHandler = async (event: StepFunctionInputOutput): Promise<StepFunctionInputOutput> => {
  pt.logger.info({ message: 'Starting OpenAI completion', event });

  await connectOpenAI();

  const pk = getCompletionPK(event.id, event.sortKey);
  const item = await Completion.get(pk);
  pt.logger.info({ message: 'Got completion item', item });
  
  // Log if we have an S3 file path in the completion record
  if (item?.Item?.uploadedFileS3Path) {
    pt.logger.info({
      message: 'Found S3 file path in completion record',
      uploadedFileS3Path: item.Item.uploadedFileS3Path,
      uploadedFileMetadata: item.Item.uploadedFileMetadata,
    });
  }
  if (item?.Item?.thread == null) {
    throw new Error(`Thread not found for ${event.id}:${event.sortKey}`);
  }

  const {type, envName} = event;
  if (envName == null) {
    throw new Error('envName is not set in the event');
  }

  const thread = item.Item.thread;
  pt.logger.info({ message: 'Initial status', item, thread });

  const footnotes: Footnote[] = [];
  let refnum = 0;

  const assistantData = (await PublishedAssistant.get(getPublishedAssistantKey(type, envName)))?.Item;
  if (!assistantData) {
    throw new Error('Assistant not found');
  }
  pt.logger.info({ message: 'Got assistant data', assistantData });

  // --- File upload logic ---
  let fileIds: string[] = [];
  
  // Handle local file upload
  if (event.uploadedFilePath) {
    const fs = await import("fs");
    const path = await import("path");
    const fileStream = fs.createReadStream(event.uploadedFilePath);
    const fileName = event.uploadedFileName || path.basename(event.uploadedFilePath);
    pt.logger.info({ message: 'Uploading local file to OpenAI', fileName, uploadedFilePath: event.uploadedFilePath, uploadedFileMime: event.uploadedFileMime });
    const fileUpload = await getOpenAI().files.create({
      file: fileStream,
      purpose: "assistants",
      filename: fileName,
    } as any); // OpenAI SDK v4+ expects { file, purpose, filename }
    pt.logger.info({ message: 'Uploaded local file to OpenAI', fileId: fileUpload.id });
    fileIds.push(fileUpload.id);
  }
  // Handle S3 file upload if available in the completion record
  else if (item?.Item?.uploadedFileS3Path) {
    pt.logger.info({ message: 'Processing S3 file', s3Path: item.Item.uploadedFileS3Path });
    try {
      const s3Path = item.Item.uploadedFileS3Path;
      const { bucket, key } = parseS3Path(s3Path);
      
      // Download the file from S3
      const fileStream = await downloadFromS3(bucket, key);
      
      // Get the filename from the completion record or extract it from the S3 key
      const fileName = item.Item.uploadedFileMetadata.filename || key.split('/').pop() || 'unknown-file';
      const fileMime = item.Item.uploadedFileMetadata.mimeType || 'application/octet-stream';
      
      pt.logger.info({
        message: 'Uploading S3 file to OpenAI',
        fileName,
        bucket,
        key,
        fileMime
      });
      
      // Convert the stream to a File object that OpenAI SDK can handle
      const fileOptions = { type: fileMime };
      const file = await toFile(fileStream, fileName, fileOptions);
      
      // Upload the file to OpenAI
      const fileUpload = await getOpenAI().files.create({
        file,
        purpose: "assistants"
      } as any); // OpenAI SDK v4+ expects { file, purpose, filename }
      
      pt.logger.info({ message: 'Uploaded S3 file to OpenAI', fileId: fileUpload.id });
      fileIds.push(fileUpload.id);
    } catch (error) {
      pt.logger.error({ message: 'Error processing S3 file', error });
      throw new Error(`Failed to process S3 file: ${error instanceof Error ? error.message : String(error)}`);
    }
  }
  // --- End file upload logic ---

  if (event.stream) {
    // Start the assistant with streaming
    const chunkHandler = new ChunkHandler();

    await askWithStreaming({
      thread,
      userQuestion: event.query,
      assistantId: assistantData.openAIAssistantId,
      assistant: assistantData.definition,
      fileIds: fileIds.length > 0 ? fileIds : undefined,
      callback: async ({ finished, chunk, annotations }) => {
        const { cleanChunk, refnum: newRefnum } = await chunkHandler.handleChunk({ openai: getOpenAI(), finished, chunk, annotations, footnotes, refnum });
        refnum = newRefnum;

        if (finished) {
          pt.logger.info({ message: 'Finished streaming' });

          // I don't think we need to do this because OpenAI will probably do it for us
          // if (footnotes.length > 0) {
          //   message += '\n---\n'+ footnotes.map(({ filename, refnum, url }) => `[${refnum}] [${filename}](${url})`).join('\n');
          // }

          await Completion.update({
            ...pk,
            status: 'success',
            message: chunkHandler.getMessage(),
          });
          return;
        } else if (cleanChunk) {
          await Completion.update({
            ...pk,
            status: 'in_progress',
            message: chunkHandler.getMessage(),
          });
          return;
        }
      },
    });

    return {
      ...event,
      status: 'completed',
    };
  } else {
    const response = await startAskWithoutStreaming({
      thread,
      userQuestion: event.query,
      assistantId: assistantData.openAIAssistantId,
      fileIds: fileIds.length > 0 ? fileIds : undefined,
    });

    return {
      ...event,
      runId: response.runId,
      status: 'in_progress',
    };
  }
}

export const handler = prepareStepFunction(lambdaHandler);