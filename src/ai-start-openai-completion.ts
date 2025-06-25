import { ChunkHandler, Footnote, askWithStreaming, connectOpenAI, getOpenAI, startAskWithoutStreaming } from "./ai-utils";
import { Completion, getCompletionPK, getPublishedAssistantKey, PublishedAssistant } from "./db-utils";
import { StepFunctionInputOutput, makePowerTools, prepareStepFunction } from "./lambda-utils";

// const { ASSISTANT_ID } = process.env;

const pt = makePowerTools({ prefix: 'ai-start-openai-completion' });

export const lambdaHandler = async (event: StepFunctionInputOutput): Promise<StepFunctionInputOutput> => {
  pt.logger.info({ message: 'Starting OpenAI completion', event });

  await connectOpenAI();

  const pk = getCompletionPK(event.id, event.sortKey);
  const item = await Completion.get(pk);
  pt.logger.info({ message: 'Got completion item', item });
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
  if (event.uploadedFilePath) {
    const fs = await import("fs");
    const path = await import("path");
    const fileStream = fs.createReadStream(event.uploadedFilePath);
    const fileName = event.uploadedFileName || path.basename(event.uploadedFilePath);
    pt.logger.info({ message: 'Uploading file to OpenAI', fileName, uploadedFilePath: event.uploadedFilePath, uploadedFileMime: event.uploadedFileMime });
    const fileUpload = await getOpenAI().files.create({
      file: fileStream,
      purpose: "assistants",
      filename: fileName,
    } as any); // OpenAI SDK v4+ expects { file, purpose, filename }
    pt.logger.info({ message: 'Uploaded file to OpenAI', fileId: fileUpload.id });
    fileIds.push(fileUpload.id);
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