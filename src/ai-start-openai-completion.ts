import { askWithStreaming, connectOpenAI, startAskWithoutStreaming } from "./ai-utils";
import { Completion, getCompletionPK } from "./db-utils";
import { StepFunctionInputOutput, makePowerTools, prepareStepFunction } from "./lambda-utils";

const { ASSISTANT_ID, } = process.env;

const pt = makePowerTools({ prefix: 'ai-start-openai-completion' });

export const handler = prepareStepFunction(async (event: StepFunctionInputOutput): Promise<StepFunctionInputOutput> => {
  pt.logger.info({ message: 'Starting OpenAI completion', event });

  if (ASSISTANT_ID == null) {
    throw new Error('ASSISTANT_ID is not set');
  }

  await connectOpenAI();

  const pk = getCompletionPK(event.id, event.sortKey);
  const item = await Completion.get(pk);
  pt.logger.info({ message: 'Got completion item', item });
  if (item?.Item?.thread == null) {
    throw new Error(`Thread not found for ${event.id}:${event.sortKey}`);
  }

  const thread = item.Item.thread;
  pt.logger.info({ message: 'Initial status', item, thread });

  let message: string = '';

  if (event.stream) {
    // Start the assistant with streaming
    await askWithStreaming({
      thread,
      userQuestion: event.query,
      assistantId: ASSISTANT_ID,
      callback: async ({ finished, chunk }) => {
        if (finished) {
          pt.logger.info({ message: 'Finished streaming' });
          await Completion.update({
            ...pk,
            status: 'success',
            message,
          });
          return;
        } else if (chunk) {
          pt.logger.info({ message: 'Got chunk', chunk });
          message += chunk;

          await Completion.update({
            ...pk,
            status: 'in_progress',
            message,
          });
          return;
        }
      }
    });

    event.status = 'completed';
    return event;
  } else {
    const response = await startAskWithoutStreaming({
      thread,
      userQuestion: event.query,
      assistantId: ASSISTANT_ID,
    });

    event.runId = response.runId;
    event.status = 'in_progress';
    return event;
  }
});