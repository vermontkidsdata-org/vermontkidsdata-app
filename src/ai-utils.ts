import { GetSecretValueCommand, SecretsManagerClient } from "@aws-sdk/client-secrets-manager";
import OpenAI from "openai";
import { TextContentBlock } from "openai/resources/beta/threads/messages";
import { Thread } from "openai/resources/beta/threads/threads";

export const IN_PROGRESS_ERROR = 'InProgressError';

const secretManager = new SecretsManagerClient({});
let openai: OpenAI;

interface IThread {
  id: string;
}

export async function connectOpenAI(): Promise<void> {
  const val = await secretManager.send(new GetSecretValueCommand({ SecretId: process.env.AI_SECRET_NAME }));
  if (!val.SecretString) throw new Error('Secret not found');

  const config = JSON.parse(val.SecretString);
  openai = new OpenAI({ apiKey: config.OPENAI_API_KEY })
}

export async function createThread(): Promise<Thread> {
  return await openai.beta.threads.create();
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