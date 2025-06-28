import { S3Client, PutObjectCommand, PutObjectCommandInput, S3ServiceException } from "@aws-sdk/client-s3";
import { SFNClient, StartExecutionCommand } from "@aws-sdk/client-sfn";
import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Thread } from "openai/resources/beta/threads/threads";
import { connectOpenAI, createThread, FileNameType } from "./ai-utils";
import { ASSISTANT_TYPE_VKD, Completion, CompletionData, getCompletionPK, getNamespace, getPublishedAssistantKey, PublishedAssistant } from "./db-utils";
import { makePowerTools, prepareAPIGateway, StepFunctionInputOutput } from "./lambda-utils";
import { ulid } from "ulid";

const { VKD_API_KEY } = process.env;

const pt = makePowerTools({ prefix: 'ai-post-completion' });

const sfn = new SFNClient({});
// Create S3 client with explicit configuration and timeout
const s3 = new S3Client({
  region: process.env.AWS_REGION || 'us-east-1',
  maxAttempts: 3,
  requestHandler: {
    abortSignal: AbortSignal.timeout(15000) // 15 second timeout
  }
});

interface PostCompletionRequest {
  key: string,
  id: string,
  sortKey: number,
  query: string,
  stream?: boolean,
  type?: string,
  sandbox?: string,
}

import Busboy from "busboy";
import { Readable } from "stream";

export const handler = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  let key: string | undefined;
  let sandbox: string | undefined;
  let _type: string | undefined;
  let data: any = {};
  let uploadedFileS3Path: string | undefined;
  let uploadedFileMetadata: FileNameType | undefined;

  const {S3_BUCKET_NAME} = process.env;
  if (!S3_BUCKET_NAME) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "S3_BUCKET_NAME environment variable is not set",
      }),
    };
  }
  
  // Detect multipart/form-data
  const contentType = event.headers["content-type"] || event.headers["Content-Type"];
  if (contentType && contentType.startsWith("multipart/form-data")) {
    // Parse multipart form
    const bb = Busboy({
      headers: { "content-type": contentType }
    });

    // Lambda event.body is base64-encoded if isBase64Encoded is true
    const bodyBuffer = Buffer.from(event.body || "", event.isBase64Encoded ? "base64" : "utf8");

    // Promisify busboy parsing
    await new Promise<void>((resolve, reject) => {
      bb.on("file", async (_fieldname: any,
        file: Readable,
        _uploadedFileMetadata: FileNameType,
        _encoding: any,
        _mimetype: string | undefined) => {
        pt.logger.info({ message: 'Received file upload', _uploadedFileMetadata });
        
        try {
          // Generate a ULID for the file name
          const fileId = ulid();
          const s3Key = `uploads/${fileId}`;
          
          // Create a promise to handle the file data collection
          const fileData = await new Promise<Buffer>((resolve, reject) => {
            const chunks: Buffer[] = [];
            
            file.on('data', (chunk) => {
              chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
            });
            
            file.on('end', () => {
              const buffer = Buffer.concat(chunks);
              resolve(buffer);
            });
            
            file.on('error', (err) => {
              pt.logger.error({ message: 'Error reading file stream', error: err });
              reject(err);
            });
          });
          
          // Use absolute minimal parameters for S3 upload - just bucket, key, and body
          const params: PutObjectCommandInput = {
            Bucket: S3_BUCKET_NAME,
            Key: s3Key,
            Body: fileData
          };
          
          // Skip ContentType for now to eliminate potential header issues
          
          pt.logger.info({ message: 'Preparing S3 upload', bucket: S3_BUCKET_NAME, key: s3Key });
          
          // Use a try-catch specifically for the S3 operation
          try {
            const command = new PutObjectCommand(params);
            
            // Create a timeout for the S3 operation
            const timeoutPromise = new Promise((_, reject) => {
              setTimeout(() => reject(new Error('S3 upload timed out after 10 seconds')), 10000);
            });
            
            // Race the S3 upload against the timeout
            const result = await Promise.race([
              s3.send(command),
              timeoutPromise
            ]) as any;
            
            pt.logger.info({ message: 'S3 upload completed successfully', result });
          } catch (error: unknown) {
            // More detailed error handling based on error type
            if (error instanceof S3ServiceException) {
              pt.logger.error({
                message: 'S3 Service Exception',
                errorName: error.name,
                errorMessage: error.message,
                errorCode: error.$metadata?.httpStatusCode,
                requestId: error.$metadata?.requestId,
                cfId: error.$metadata?.cfId,
                extendedRequestId: error.$metadata?.extendedRequestId
              });
            } else if (error instanceof Error) {
              pt.logger.error({
                message: 'Error in S3 upload',
                errorName: error.name,
                errorMessage: error.message,
                errorStack: error.stack
              });
            } else {
              pt.logger.error({
                message: 'Unknown error in S3 upload',
                error: String(error)
              });
            }
            
            // Try to provide more context about the error
            pt.logger.info({
              message: 'S3 upload context',
              fileSize: fileData.length,
              bucket: S3_BUCKET_NAME,
              key: s3Key
            });
            
            throw error;
          }
          
          // Store S3 path
          uploadedFileS3Path = `${S3_BUCKET_NAME}/${s3Key}`;
          uploadedFileMetadata = _uploadedFileMetadata;

          pt.logger.info({ message: 'File uploaded to S3', s3Path: uploadedFileS3Path });
        } catch (error) {
          pt.logger.error({ message: 'Error uploading file to S3', error });
          reject(error);
        }
      });
      bb.on("field", (fieldname, val) => {
        if (fieldname === "key") key = val;
        else if (fieldname === "sandbox") sandbox = val;
        else if (fieldname === "type") _type = val;
        else data[fieldname] = val;
      });
      bb.on("finish", () => resolve());
      bb.on("error", err => reject(err));
      bb.end(bodyBuffer);
    });
  } else {
    // Default: JSON body
    const parsed = JSON.parse(event.body || '{}') as PostCompletionRequest;
    key = parsed.key;
    sandbox = parsed.sandbox;
    _type = parsed.type;
    data = { ...parsed };
    delete data.key;
    delete data.sandbox;
    delete data.type;
  }

  if (key !== VKD_API_KEY) {
    return {
      statusCode: 403,
      body: JSON.stringify({
        "message": "Invalid API key",
      }),
    };
  }
  const ns = getNamespace();

  const envName = (ns + (sandbox ? `/${sandbox}` : '')).toLowerCase();
  const type = _type ?? ASSISTANT_TYPE_VKD;

  // Make sure the assistant is published
  const pubAss = (await PublishedAssistant.get(getPublishedAssistantKey(type, envName)))?.Item;
  if (!pubAss) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Assistant not published, did you use POST /ai/assistant/XXX/publish?",
        envName,
      }),
    }
  }

  pt.logger.info({ message: 'Found published assistant, starting thread', data, envName, type, pubAss, id: data.id, sortKey: data.sortKey });

  // Need this because we're creating a thread
  pt.logger.info({ message: 'Connecting to OpenAI' });
  await connectOpenAI();
  pt.logger.info({ message: 'Connected to OpenAI' });

  // If it's not the first message, continue the thread
  let thread: Thread;

  // Make sure sortKey is a number
  if (typeof data.sortKey !== 'number') {
    data.sortKey = parseInt(data.sortKey, 10);
    if (isNaN(data.sortKey)) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Invalid sortKey",
          id: data.id,
        }),
      }
    }
  }
  
  if (data.sortKey === 0) {
    pt.logger.info({ message: 'Creating new thread for first message', data });
    thread = await createThread();
    pt.logger.info({ message: 'Created thread', thread });
  } else {
    pt.logger.info({ message: 'Continuing existing thread', data });
    // Fetch the thread from the database
    const record = await Completion.get(getCompletionPK(data.id, 0));
    if (record?.Item?.thread == null) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Conversation not found",
          id: data.id,
        }),
      }
    }

    thread = record.Item.thread;
  }

  // If a file was uploaded, store its info in the Completion record for downstream processing
  const completionData: Omit<CompletionData, 'created' | 'modified' | 'entity'> = {
    ...data,
    status: 'new',
    thread,
    type,
    envName,
    uploadedFileS3Path,
    uploadedFileMetadata,
  };
  pt.logger.info({ message: 'Storing completion data', completionData });
  await Completion.put(completionData);

  const sf = await sfn.send(new StartExecutionCommand({
    stateMachineArn: process.env.VKD_STATE_MACHINE_ARN,
    input: JSON.stringify({
      id: data.id,
      sortKey: data.sortKey,
      query: data.query,
      stream: data.stream,
      type: pubAss.type,
      envName,
      uploadedFileS3Path: uploadedFileS3Path || undefined,
      uploadedFileMetadata: uploadedFileMetadata || undefined,
    } as StepFunctionInputOutput),
  }));

  pt.logger.info({ message: 'Started state machine', sf });
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Processing request",
      id: data.id,
      sortKey: data.sortKey,
      uploadedFileMetadata,
    }),
  }
});