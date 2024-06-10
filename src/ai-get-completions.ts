import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { ALL_WITH_COMMENTS, Completion, CompletionData, forEachThing, getReactionKeyAttribute } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const { VKD_API_KEY } = process.env;

const pt = makePowerTools({ prefix: 'ai-get-completions' });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  const key = event.queryStringParameters?.key;
  if (key !== VKD_API_KEY) {
    return {
      statusCode: 403,
      body: JSON.stringify({
        "message": "Invalid API key",
      })
    };
  }

  // Filtering. The only filters we allow at the moment is (1) by reaction or (2) completions with comments.
  // We don't allow filtering by both reaction and comment, so it's one or the other.
  const { reaction, comment } = event.queryStringParameters || {};
  if (!reaction && !comment || reaction && comment) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Invalid request - filter by reaction or comment but not both",
      }),
    }
  }

  // If there are specific list of fields in a query string parameter, only return those fields
  const fields = event.queryStringParameters?.fields?.split(',').map((field) => field.trim());
  const attributes = fields?.filter((field) =>
    ['reaction', 'comment', 'query', 'status', 'message', 'stream', 'created', 'modified'].includes(field)
  ) as (keyof CompletionData)[];
  attributes?.push('id', 'sortKey');
  if (fields?.some((field) => !(attributes as string[]).includes(field))) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Invalid field(s) requested",
      }),
    }
  }

  // Fetch the requested completions from the database
  const { query, index } = {
    query: reaction ?
      getReactionKeyAttribute(reaction) :
      ALL_WITH_COMMENTS,
    index: reaction ?
      { index: 'GSI1' } :
      { index: 'GSI2' }
  };

  const completions: Omit<CompletionData, 'thread' | 'entity'>[] = [];

  pt.logger.info({ message: 'Fetching completions', query, index });

  await forEachThing<CompletionData>(
    () => Completion.query(query, {
      ...index,
      attributes,
    }),
    async (completion) => {
      const { thread, entity, ...rest } = completion;
      completions.push(rest);
    },
  );

  return {
    statusCode: 200,
    body: JSON.stringify({
      completions,
    })
  }
}

export const handler = prepareAPIGateway(lambdaHandler);

// if (!module.parent) {
//   (async () => {
//     const event = {
//       queryStringParameters: {
//         key: VKD_API_KEY,
//         reaction: '+1',
//       },
//     } as any;
//     const result = await lambdaHandler(event);
//     console.log(result);
//   })();
// }