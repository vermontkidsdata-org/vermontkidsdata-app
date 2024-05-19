import { IN_PROGRESS_ERROR, checkAskWithoutStreaming, connectOpenAI } from "./ai-utils";
import { Completion, getCompletionPK } from "./db-utils";
import { StepFunctionInputOutput, makePowerTools, prepareStepFunction } from "./lambda-utils";

const pt = makePowerTools({ prefix: 'ai-check-openai-completion' });

export class InProgressError extends Error {
  constructor(message: string) {
    super(message);
    this.name = IN_PROGRESS_ERROR;
  }
}

export const handler = prepareStepFunction(async (event: StepFunctionInputOutput): Promise<StepFunctionInputOutput> => {
  pt.logger.info({ message: 'Checking OpenAI completion', event });

  const item = await Completion.get(getCompletionPK(event.id, event.sortKey));
  pt.logger.info({ message: 'Got completion item', item });
  if (item?.Item?.thread == null) {
    throw new Error(`Thread not found for ${event.id}:${event.sortKey}`);
  }

  await connectOpenAI();

  const response = await checkAskWithoutStreaming({
    thread: item.Item.thread,
    runId: event.runId,
  })

  pt.logger.info({ message: 'Checked OpenAI completion', response });

  await Completion.update({
    ...getCompletionPK(event.id, event.sortKey),
    ...response,
  });

  if (response.status === 'failure') {
    throw new Error(response.message);
  } else if (response.status === 'in_progress') {
    throw new InProgressError('Completion in progress');
  } else {
    return {
      ...event,
      status: response.status,
    };
  }
});