import { S3Client, PutObjectCommand, PutObjectCommandInput } from "@aws-sdk/client-s3";
import { SFNClient, StartExecutionCommand } from "@aws-sdk/client-sfn";
import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Thread } from "openai/resources/beta/threads/threads";
import { connectOpenAI, createThread } from "./ai-utils";
import { ASSISTANT_TYPE_VKD, Completion, getCompletionPK, getNamespace, getPublishedAssistantKey, PublishedAssistant } from "./db-utils";
import { makePowerTools, prepareAPIGateway, StepFunctionInputOutput } from "./lambda-utils";
import { ulid } from "ulid";

const { VKD_API_KEY } = process.env;

const pt = makePowerTools({ prefix: 'ai-post-completion' });

const sfn = new SFNClient({});
const s3 = new S3Client({});

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
  let uploadedFileName: string | undefined;
  let uploadedFileMime: string | undefined;

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
        filename: string | undefined,
        _encoding: any,
        mimetype: string | undefined) => {
        pt.logger.info({ message: 'Received file upload', filename, mimetype });
        
        try {
          // Generate a ULID for the file name
          const fileId = ulid();
          const s3Key = `uploads/${fileId}`;
          
          // Collect file data into buffer
          const chunks: Buffer[] = [];
          for await (const chunk of file) {
            chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
          }
          const fileBuffer = Buffer.concat(chunks);
          
          // Upload to S3
          const params: PutObjectCommandInput = {
            Bucket: S3_BUCKET_NAME,
            Key: s3Key,
            Body: fileBuffer
          };
          
          // Only add ContentType if mimetype is defined
          if (mimetype) {
            params.ContentType = mimetype;
          }
          
          // Only add Metadata if filename is defined, and ensure keys are lowercase
          if (filename) {
            params.Metadata = {
              originalfilename: filename // lowercase key for metadata
            };
          }
          
          pt.logger.info({ message: 'Uploading file to S3', params });
          await s3.send(new PutObjectCommand(params));
          
          // Store S3 path
          uploadedFileS3Path = `${S3_BUCKET_NAME}/${s3Key}`;
          uploadedFileName = filename;
          uploadedFileMime = mimetype;
          
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

  // Need this because we're creating a thread
  await connectOpenAI();

  // If it's not the first message, continue the thread
  let thread: Thread;

  if (data.sortKey === 0) {
    thread = await createThread();
    pt.logger.info({ message: 'Created thread', thread });
  } else {
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
  await Completion.put({
    ...data,
    status: 'new',
    thread,
    type,
    envName,
    uploadedFileS3Path: uploadedFileS3Path || undefined,
    uploadedFileName: uploadedFileName || undefined,
    uploadedFileMime: uploadedFileMime || undefined,
  });

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
      uploadedFileName: uploadedFileName || undefined,
      uploadedFileMime: uploadedFileMime || undefined,
    } as StepFunctionInputOutput),
  }));

  pt.logger.info({ message: 'Started state machine', sf });
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Processing request",
      id: data.id,
      sortKey: data.sortKey,
      uploadedFile: uploadedFileName ? { name: uploadedFileName, mime: uploadedFileMime } : undefined,
    }),
  }
});