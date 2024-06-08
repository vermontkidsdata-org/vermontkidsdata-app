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

  // Fetch the requested completions from the database
  const { query, index } = {
    query: reaction ?
      { GSI1PK: getReactionKeyAttribute(reaction) } :
      { GSI2PK: ALL_WITH_COMMENTS },
    index: reaction ?
      { index: 'GSI1' } :
      { index: 'GSI2' }
  };

  const completions: CompletionData[] = [];

  await forEachThing<CompletionData>(
    () => Completion.query(query, index),
    async (completion) => {
      completions.push(completion);
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