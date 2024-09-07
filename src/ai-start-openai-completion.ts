import { ChunkHandler, Footnote, askWithStreaming, connectOpenAI, getOpenAI, startAskWithoutStreaming } from "./ai-utils";
import { getPublishedAssistant } from "./assistant-def";
import { Completion, getCompletionPK } from "./db-utils";
import { StepFunctionInputOutput, makePowerTools, prepareStepFunction } from "./lambda-utils";

// const { ASSISTANT_ID } = process.env;

const pt = makePowerTools({ prefix: 'ai-start-openai-completion' });

export const lambdaHandler = async (event: StepFunctionInputOutput): Promise<StepFunctionInputOutput> => {
  pt.logger.info({ message: 'Starting OpenAI completion', event });

  // if (ASSISTANT_ID == null) {
  //   throw new Error('ASSISTANT_ID is not set');
  // }

  await connectOpenAI();

  const pk = getCompletionPK(event.id, event.sortKey);
  const item = await Completion.get(pk);
  pt.logger.info({ message: 'Got completion item', item });
  if (item?.Item?.thread == null) {
    throw new Error(`Thread not found for ${event.id}:${event.sortKey}`);
  }

  const envName = event.envName;
  if (envName == null) {
    throw new Error('envName is not set in the event');
  }

  const thread = item.Item.thread;
  pt.logger.info({ message: 'Initial status', item, thread });

  const footnotes: Footnote[] = [];
  let refnum = 0;

  const assistantData = await getPublishedAssistant(envName);
  if (!assistantData) {
    throw new Error('Assistant not found');
  }
  pt.logger.info({ message: 'Got assistant data', assistantData });
  
  if (event.stream) {
    // Start the assistant with streaming
    const chunkHandler = new ChunkHandler();

    await askWithStreaming({
      thread,
      userQuestion: event.query,
      assistantId: assistantData.openAIAssistantId,
      assistant: assistantData.definition,
      
      // debugCallback: async ({ event }) => {
      //   pt.logger.info({ message: 'Debug callback', event });
      // },
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
    });

    return {
      ...event,
      runId: response.runId,
      status: 'in_progress',
    };
  }
}

export const handler = prepareStepFunction(lambdaHandler);