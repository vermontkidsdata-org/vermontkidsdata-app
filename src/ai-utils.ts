import { GetSecretValueCommand, SecretsManagerClient } from "@aws-sdk/client-secrets-manager";
import OpenAI from "openai";
import { AssistantStreamEvent } from "openai/resources/beta/assistants";
import { AnnotationDelta, TextContentBlock, TextDeltaBlock } from "openai/resources/beta/threads/messages";
import { Thread } from "openai/resources/beta/threads/threads";
import { BarChartResult, getChartData } from "./chartsApi";
import { makePowerTools } from "./lambda-utils";

export const IN_PROGRESS_ERROR = 'InProgressError';

const pt = makePowerTools({ prefix: 'ai-utils' });

const secretManager = new SecretsManagerClient({});
export let openai: OpenAI;

export function getOpenAI(): OpenAI {
  return openai;
}

/**
 * This is a list of files that are available for citation in the AI responses.
 */
export const FILE_MAP = [{
  "filename": "how_are_vermonts_young_children_2023.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/the_state_of_vermonts_children_2023_year_in_review.pdf",
  "name": "The State of Vermont's Children 2023 Year in Review"
}, {
  "filename": "how_are_vermonts_young_children_2022.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/State-of-Vermonts-Children-2022.pdf",
  "name": "The State of Vermont's Children 2022"
}, {
  "filename": "how_are_vermonts_young_children_2021.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/2022/01/The-State-of-Vermonts-Children-2021-Year-in-Review.pdf",
  "name": "The State of Vermont's Children 2021 Year in Review"
}, {
  "filename": "how_are_vermonts_young_children_2020.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/2021/01/2020-How-Are-Vermonts-Young-Children-and-Families.pdf",
  "name": "How Are Vermont's Young Children and Families 2020"
}, {
  "filename": "how_are_vermonts_young_children_2019.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/2020/01/BBF-2019-HAVYCF-REPORT-SinglePgs.pdf",
  "name": "How Are Vermont's Young Children 2019"
}, {
  "filename": "how_are_vermonts_young_children_2018.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/2019/01/BBF-2018-HAVYCF-FINAL-SINGLES-1.pdf",
  "name": "How Are Vermont's Young Children 2018"
}];

interface IThread {
  id: string;
}

export async function connectOpenAI(): Promise<void> {
  // Allow API key to be set as an environment variable
  let apiKey: string | undefined = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    const val = await secretManager.send(new GetSecretValueCommand({ SecretId: process.env.AI_SECRET_NAME }));
    if (!val.SecretString) throw new Error('Secret not found');

    const config = JSON.parse(val.SecretString);
    apiKey = config.OPENAI_API_KEY;
  }

  openai = new OpenAI({ apiKey });
}

export async function createThread(): Promise<Thread> {
  return await openai.beta.threads.create();
}


function isTextDeltaBlock(block: any): block is TextDeltaBlock {
  return block.type === "text";
}

class EventEmitter {
  public emit(arg0: string, event: any) {
    console.log(arg0 + ":" + event);
  }
}

const barChartCache = new Map<string, BarChartResult>();

async function getChartDataWithCache(queryId: string): Promise<BarChartResult> {
  if (barChartCache.has(queryId)) {
    return barChartCache.get(queryId)!;
  }

  const data = await getChartData(queryId);
  barChartCache.set(queryId, data);
  return data;
}

export type StreamingCallback = (props: { failed: boolean, event?: AssistantStreamEvent, finished: boolean, chunk?: string, annotations?: AnnotationDelta[] }) => Promise<void>;
export type StreamingDebugCallback = (props: { event: AssistantStreamEvent }) => Promise<void>;

class EventHandler {
  async handleRequiresAction(data: any, runId: string, threadId: string, callback: StreamingCallback) {
    try {
      const toolOutputs: { tool_call_id: string, output: string }[] = [];

      for (const toolCall of data.required_action.submit_tool_outputs.tool_calls) {
        if (toolCall.function.name === "get_child_poverty") {
          // {
          //   id: 'call_eTKIWrpcyUxfImkh4koY1Yc8',
          //   type: 'function',
          //   function: {
          //     name: 'get_child_poverty',
          //     arguments: '{"location": "Chittenden", "type": "percent", "year": 2020}'
          //   }
          // }
          console.log("Processing get_child_poverty tool call", toolCall);
          const data = await getChartDataWithCache("children_in_poverty_under_12_all:chart");
          console.log("getChartData", data);
          const { location, type, year } = JSON.parse(toolCall.function.arguments) as { location: string, type: string, year: number | string };

          // See if we have the requested geography; else we'll just use "Vermont"
          const series = data.series.find((s: any) => s.name.toLowerCase() === location.toLowerCase()) ||
            data.series.find((s: any) => s.name.toLowerCase() === "vermont") ||
            data.series[data.series.length - 1];

          // See if we have the year; else we'll just use the last year
          let yearPos = data.categories.indexOf(parseInt(`${year}`, 10));
          if (yearPos < 0) {
            yearPos = data.categories.length - 1;
          }

          const output = {
            value: series.data[yearPos],
            geography: series.name,
            year: data.categories[yearPos],
            url: "https://ui.vtkidsdata.org/linechart/children_in_poverty_under_12:chart",
          };
          console.log("output", output);

          toolOutputs.push({
            tool_call_id: toolCall.id,
            output: JSON.stringify(output)
          });
        } else if (toolCall.function.name === "get_3squares_benefit_and_chart") {
          // {
          //   id: 'call_IP9awjq6zdppsJQRVHnA4sUZ',
          //   type: 'function',
          //   function: {
          //     name: 'get_3squares_benefit',
          //     arguments: '{"group": "individual", "year": "2022"}'
          //   }
          // }
          const { group, year } = JSON.parse(toolCall.function.arguments);
          console.log({ message: "Processing get_3squares_benefit tool call", toolCall, group, year });

          const data = await getChartDataWithCache("avgbenefit_3squares_vt:chart");
          console.log("getChartData", data);
          const series = data.series.find((s: any) => s.name.toLowerCase() === group.toLowerCase());
          if (series) {
            console.log("series", series);
            const yearPos = data.categories.indexOf(parseInt(year, 10));
            if (yearPos >= 0) {
              const value = series.data[yearPos];
              console.log("found value", value);
              toolOutputs.push({
                tool_call_id: toolCall.id,
                output: JSON.stringify({
                  value: `${value}`,
                  url: "https://ui.vtkidsdata.org/columnchart/avgbenefit_3squares_vt:chart",
                })
              });

              continue;
            }
          }

          // Give up
          toolOutputs.push({
            tool_call_id: toolCall.id,
            output: "unknown",
          });
        }
      }

      // Submit all the tool outputs at the same time
      console.log({ toolOutputs });
      await this.submitToolOutputs(toolOutputs, runId, threadId, callback);
    } catch (error) {
      console.error("Error processing required action:", error);
    }
  }

  async submitToolOutputs(toolOutputs: any, runId: string, threadId: string, callback: StreamingCallback) {
    try {
      // Use the submitToolOutputsStream helper
      const stream = openai.beta.threads.runs.submitToolOutputsStream(
        threadId,
        runId,
        { tool_outputs: toolOutputs },
      );
      for await (const event of stream) {
        if (await handleEvent(event, callback)) break;
      }
    } catch (error) {
      console.error("Error submitting tool outputs:", error);
    }
  }
}

const eventHandler = new EventHandler();

async function handleEvent(event: any, callback: StreamingCallback): Promise<boolean> {
  if (event.event === 'thread.run.created') {
  } else if (event.event === 'thread.run.failed') {
    console.error("Run failed");
    await callback({ finished: true, failed: true, event });
    return true;
  } else if (event.event === 'thread.run.completed') {
    console.log("Run completed");
    return true;
  } else if (event.event === 'thread.message.delta') {
    if (isTextDeltaBlock(event.data.delta.content?.[0])) {
      const text = event.data.delta.content?.[0].text;
      const annotations = text?.annotations;
      const chunk = text?.value;
      await callback({ finished: false, chunk, annotations, event, failed: false });
    }
  } else if (event.event === 'thread.run.requires_action') {
    console.log("Requires action: ", JSON.stringify(event.data.required_action));
    await eventHandler.handleRequiresAction(event.data, event.data.id, event.data.thread_id, callback);
  }

  return false;
}

export async function askWithStreaming(props: { thread: Thread, userQuestion: string, assistantId: string, callback: StreamingCallback, debugCallback?: StreamingDebugCallback }): Promise<void> {
  const { thread, userQuestion, assistantId, callback, debugCallback } = props;

  // Pass in the user question into the existing thread
  await openai.beta.threads.messages.create(thread.id, {
    role: "user",
    content: userQuestion,
  });

  // Create a run
  const stream = await openai.beta.threads.runs.create(thread.id, {
    assistant_id: assistantId,
    stream: true,
  });

  for await (const event of stream) {
    if (debugCallback) {
      await debugCallback({ event });
    }
    if (await handleEvent(event, callback)) break;
  }

  await callback({ finished: true, failed: false });
}


export async function startAskWithoutStreaming(props: { thread: Thread, userQuestion: string, assistantId: string }): Promise<{
  runId: string,
}> {
  const { thread, userQuestion, assistantId } = props;

  // Pass in the user question into the existing thread
  await openai.beta.threads.messages.create(thread.id, {
    role: "user",
    content: userQuestion,
  });

  // Create a run
  const run = await openai.beta.threads.runs.create(thread.id, {
    assistant_id: assistantId,
    // stream: true,
    // response_format: { type: "json_object" }
  });

  return {
    runId: run.id,
  }
}

export async function checkAskWithoutStreaming(props: { thread: Thread, runId: string }): Promise<{
  status: string,
  message?: string,
}> {
  const { thread, runId } = props;

  console.log("Polling for completion...", thread.id, runId);
  const runStatus = await openai.beta.threads.runs.retrieve(
    thread.id,
    runId
  );
  console.log({ message: "Current status...", runStatus });
  if (runStatus.status === "completed") {
    // Get the last assistant message from the messages array
    const messages = await openai.beta.threads.messages.list(thread.id);

    // Find the last message for the current run
    const lastMessageForRun = messages.data
      .filter(
        (message: any) =>
          message.run_id === runId && message.role === "assistant"
      )
      .pop();

    // If an assistant message is found, console.log() it
    if (lastMessageForRun) {
      return {
        status: 'success',
        message: (lastMessageForRun.content[0] as TextContentBlock).text.value,
      }
    }
  }

  return {
    status: runStatus.status,
  }
}

export async function askWithoutStreaming(props: { thread: Thread, userQuestion: string, assistantId: string }): Promise<{
  status: string,
  message?: string,
}> {
  const { runId } = await startAskWithoutStreaming(props);
  const { thread, } = props;

  // Polling mechanism to see if runStatus is completed
  let runStatus;
  do {
    await new Promise((resolve) => setTimeout(resolve, 1000));

    runStatus = await checkAskWithoutStreaming({ thread, runId, });
  } while (runStatus.status !== "completed" && runStatus.status !== "failed");

  return runStatus;
}

export interface Footnote {
  refnum: number,
  filename: string,
  url: string,
  file_id: string,
}

export class ChunkHandler {
  lastFootnotes: Footnote[] = [];
  message: string = '';

  getMessage(): string {
    return this.message;
  }

  async handleChunk(props: {
    openai: OpenAI,
    footnotes: Footnote[],
    refnum: number,
    finished: boolean,
    chunk?: string,
    annotations?: AnnotationDelta[],
  }): Promise<{ cleanChunk?: string, refnum: number }> {
    const { finished, chunk, annotations, footnotes, openai: localOpenAI, } = props;
    let cleanChunk = chunk;
    let refnum = props.refnum;

    pt.logger.info("handleChunk", { finished, chunk, annotations });

    const localFootnotes: Footnote[] = [];

    if (annotations) {
      for (const annotation of annotations) {
        if (annotation.type === 'file_citation' && annotation.file_citation?.file_id) {
          const file = await localOpenAI.files.retrieve(annotation.file_citation.file_id);
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
          pt.logger.info({ message: 'Existing footnote? (no existing property if not)', existing });

          if (existing) {
            pt.logger.info({ message: 'Already have a footnote', existing });
            localFootnotes.push(existing);
          } else {
            // Not yet, need to look it up in the map
            const mapped = FILE_MAP.find(f => f.filename === file.filename);
            pt.logger.info({ message: 'Mapped file', FILE_MAP, file, mapped });
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
    } else {
      this.lastFootnotes = [];
    }

    if (cleanChunk && annotations) {
      // Substitute the footnotes based on the text of each annotation
      for (const annotation of annotations) {
        if (annotation.type === 'file_citation' && annotation.file_citation?.file_id && annotation.text) {
          const re = new RegExp(annotation.text, 'g');

          // See if we just had these footnotes
          const lastFootnotesFound = this.lastFootnotes.find(f => f.file_id === annotation.file_citation?.file_id);
          if (lastFootnotesFound) {
            pt.logger.info({ message: 'Last footnotes found, ignoring', lastFootnotesFound, file_id: annotation.file_citation?.file_id });
            cleanChunk = cleanChunk.replace(re, '');
          } else {
            const localFootnote = localFootnotes.find(f => f.file_id === annotation.file_citation?.file_id);
            pt.logger.info({ message: 'Local footnote', localFootnotes, file_id: annotation.file_citation?.file_id, localFootnote, text: annotation.text });
            if (localFootnote) {
              cleanChunk = cleanChunk.replace(re, `[[${localFootnote.refnum}]](${localFootnote.url})`);
              this.lastFootnotes.push(localFootnote);
            } else {
              cleanChunk = cleanChunk.replace(re, '');
            }
          }
        }
      }
    }

    this.message += cleanChunk ?? '';
    return { cleanChunk, refnum };
  }
}

if (!module.parent) {
  if (!process.env.SERVICE_TABLE || !process.env.DB_SECRET_NAME) {
    console.error("Please set environment variables");
    console.error("Run `set SERVICE_TABLE=vkd-qa-service-table` and `set DB_SECRET_NAME=vkd/qa/dbcreds`")
    process.exit(1);
  }

  (async () => {
    await connectOpenAI();
    const thread = await createThread();
    console.log("Created thread", thread);

    const result = await askWithStreaming({
      thread,
      userQuestion: // Pick one
        // "In the last 3 years, was the average individual 3 squares benefit in Vermont flat or did it increase or decrease?"
        // "What is the latest year of the reports?"
        // "What is the average household income for 2020 through 2023?"
        // "How many children lived in poverty in Chittenden in 2020?"
        // "How many children lived in poverty in Chittenden in 1942?"
        "Please compare the state of Vermont's children in 2022 vs 2019. Consider primarily their mental and physical health, but also consider whether they have been able to successfully be educated."
      ,
      assistantId: process.env.ASSISTANT_ID || 'asst_nJKMeBh1KxrqsrL9jGheMcHX',
      callback: async ({ finished, chunk }) => {
        console.log("Callback", { finished, chunk });
      }
    });

    console.log("Result", result);
  })();
}