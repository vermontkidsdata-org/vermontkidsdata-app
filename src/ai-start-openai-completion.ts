import { FILE_MAP, askWithStreaming, connectOpenAI, openai, startAskWithoutStreaming } from "./ai-utils";
import { Completion, getCompletionPK } from "./db-utils";
import { StepFunctionInputOutput, makePowerTools, prepareStepFunction } from "./lambda-utils";

const { ASSISTANT_ID, } = process.env;

const pt = makePowerTools({ prefix: 'ai-start-openai-completion' });

interface Footnote {
  refnum: number,
  filename: string,
  url: string,
  file_id: string,
}

export const lambdaHandler = async (event: StepFunctionInputOutput): Promise<StepFunctionInputOutput> => {
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
  const footnotes: Footnote[] = [];
  let refnum = 0;

  if (event.stream) {
    // Start the assistant with streaming
    await askWithStreaming({
      thread,
      userQuestion: event.query,
      assistantId: ASSISTANT_ID,
      debugCallback: async ({ event }) => {
        pt.logger.info({ message: 'Debug callback', event });
      },
      callback: async ({ finished, chunk, annotations }) => {
        console.log("Callback", { finished, chunk, annotations });
        const localFootnotes: Footnote[] = [];

        if (annotations) {
          for (const annotation of annotations) {
            if (annotation.type === 'file_citation' && annotation.file_citation?.file_id) {
              const file = await openai.files.retrieve(annotation.file_citation.file_id);
              pt.logger.info({
                message: 'Cited file', info: {
                  id: file.id,
                  name: file.filename,
                  purpose: file.purpose,
                  bytes: file.bytes,
                }
              });

              // See if we already have a footnote to this file
              const existing = footnotes.find(f => f.filename === file.filename);
              if (existing) {
                pt.logger.info({ message: 'Already have a footnote', existing });
                localFootnotes.push(existing);
              } else {
                // Not yet, need to look it up in the map
                const mapped = FILE_MAP.find(f => f.filename === file.filename);
                if (mapped) {
                  pt.logger.info({ message: 'Mapped file', mapped });
                  const localFootnote = {
                    refnum: ++refnum,
                    filename: file.filename,
                    url: mapped.url,
                    file_id: file.id,
                  };
                  footnotes.push(localFootnote);
                  localFootnotes.push(localFootnote);
                }
              }
            }
          }
        }

        let cleanChunk = chunk;
        if (cleanChunk && annotations) {
          // Substitute the footnotes based on the text of each annotation
          for (const annotation of annotations) {
            if (annotation.type === 'file_citation' && annotation.file_citation?.file_id) {
              const localFootnote = localFootnotes.find(f => f.file_id === annotation.file_citation?.file_id);
              if (annotation.text) {
                const re = new RegExp(annotation.text, 'g');
                if (localFootnote) {
                  cleanChunk = cleanChunk.replace(re, `[^${localFootnote.refnum}]`);
                } else {
                  cleanChunk = cleanChunk.replace(re, '');
                }
              }
            }
          }
        }

        if (finished) {
          pt.logger.info({ message: 'Finished streaming' });
          await Completion.update({
            ...pk,
            status: 'success',
            message,
          });
          return;
        } else if (cleanChunk) {
          pt.logger.info({ message: 'Got clean chunk', chunk, cleanChunk });
          message += cleanChunk;

          await Completion.update({
            ...pk,
            status: 'in_progress',
            message,
          });
          return;
        }
      }
    });

    return {
      ...event,
      status: 'completed'
    };
  } else {
    const response = await startAskWithoutStreaming({
      thread,
      userQuestion: event.query,
      assistantId: ASSISTANT_ID,
    });

    return {
      ...event,
      runId: response.runId,
      status: 'in_progress'
    };
  }
}

export const handler = prepareStepFunction(lambdaHandler);