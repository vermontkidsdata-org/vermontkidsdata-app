import { SFNClient, StartExecutionCommand } from "@aws-sdk/client-sfn";
import { APIGatewayProxyEventV2 } from "aws-lambda";
import { Thread } from "openai/resources/beta/threads/threads";
import { connectOpenAI, createThread } from "./ai-utils";
import { Completion, getCompletionPK } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const { ASSISTANT_ID, VKD_API_KEY } = process.env;

const pt = makePowerTools({ prefix: 'ai-post-completion' });

const sfn = new SFNClient({});

interface PostCompletionRequest {
  key: string,
  id: string,
  sortKey: number,
  query: string,
  stream?: boolean,
}

export const handler = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  if (ASSISTANT_ID == null) {
    throw new Error('ASSISTANT_ID is not set');
  }

  const { key, ...data } = JSON.parse(event.body || '{}') as PostCompletionRequest;
  if (key !== VKD_API_KEY) {
    return {
      statusCode: 403,
      body: JSON.stringify({
        "message": "Invalid API key",
      })
    };
  }

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

  await Completion.update({
    ...data,
    status: 'new',
    thread,
  });

  const sf = await sfn.send(new StartExecutionCommand({
    stateMachineArn: process.env.VKD_STATE_MACHINE_ARN,
    input: JSON.stringify({
      id: data.id,
      sortKey: data.sortKey,
      query: data.query,
      stream: data.stream,
    }),
  }));

  pt.logger.info({ message: 'Started state machine', sf });
  return {
    statusCode: 200,
    body: JSON.stringify({
      "message": "Processing request",
    })
  }
});