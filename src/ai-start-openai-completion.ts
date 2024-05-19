import { connectOpenAI, startAskWithoutStreaming } from "./ai-utils";
import { Completion, getCompletionPK } from "./db-utils";
import { StepFunctionInputOutput, makePowerTools, prepareStepFunction } from "./lambda-utils";

const { ASSISTANT_ID } = process.env;

const pt = makePowerTools({ prefix: 'ai-start-openai-completion' });

export const handler = prepareStepFunction(async (event: StepFunctionInputOutput): Promise<StepFunctionInputOutput> => {
  pt.logger.info({ message: 'Starting OpenAI completion', event });

  if (ASSISTANT_ID == null) {
    throw new Error('ASSISTANT_ID is not set');
  }

  await connectOpenAI();

  const item = await Completion.get(getCompletionPK(event.id, event.sortKey));
  pt.logger.info({ message: 'Got completion item', item });
  if (item?.Item?.thread == null) {
    throw new Error(`Thread not found for ${event.id}:${event.sortKey}`);
  }

  const thread = item.Item.thread;
  pt.logger.info({ message: 'Found thread', thread });

  const response = await startAskWithoutStreaming({
    thread,
    userQuestion: event.query,
    assistantId: ASSISTANT_ID,
  });

  event.runId = response.runId;
  
  return event;
});