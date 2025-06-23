import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { ALL_WITH_COMMENTS, Completion, CompletionData, forEachThing, getReactionKeyAttribute, getTypeKeyAttribute } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const pt = makePowerTools({ prefix: 'ai-get-completions' });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  // const ret = validateAPIAuthorization(event);
  // if (ret) {
  //   return ret;
  // }

  // Filtering. The only filters we allow at the moment is (1) by reaction or (2) completions with comments.
  // We don't allow filtering by both reaction and comment, so it's one or the other.
  const { reaction, comment, type } = event.queryStringParameters || {};
  // Only one of reaction, comment, or type can be present
  const filterCount = [reaction, comment, type].filter(Boolean).length;
  if (filterCount !== 1) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Invalid request - filter by exactly one of reaction, comment, or type",
      }),
    }
  }

  // If there are specific list of fields in a query string parameter, only return those fields
  const fields = event.queryStringParameters?.fields?.split(',').map((field) => field.trim());
  const attributes = fields?.filter((field) =>
    ['type', 'fileName', 'reaction', 'comment', 'query', 'status', 'message', 'stream', 'created', 'modified'].includes(field),
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
    query: type ?
      getTypeKeyAttribute(type) :
    reaction ?
      getReactionKeyAttribute(reaction) :
      ALL_WITH_COMMENTS,
    index: type ? 
      { index: 'GSI3' } :
    reaction ?
      { index: 'GSI1' } :
      { index: 'GSI2' },
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
      // No longer filter by sortKey for type; collect all completions
      completions.push(rest);
    },
  );

  // Group completions by id (PK), and for each group, find min/max sortKey
  const grouped: Record<string, Omit<CompletionData, 'thread' | 'entity'>[]> = {};
  for (const c of completions) {
    if (!grouped[c.id]) grouped[c.id] = [];
    grouped[c.id].push(c);
  }

  const result = Object.values(grouped).map(group => {
    const sortKeys = group.map(c => c.sortKey).filter(sk => typeof sk === 'number');
    const minSortKey = Math.min(...sortKeys);
    const maxSortKey = Math.max(...sortKeys);
    // Use the record with the min sortKey as the base
    const base = group.find(c => c.sortKey === minSortKey) || group[0];
    // Exclude the original sortKey, replace with [min, max]
    const { sortKey, ...rest } = base;
    return {
      ...rest,
      sortKey: { min: minSortKey, max: maxSortKey },
    };
  });

  return {
    statusCode: 200,
    body: JSON.stringify({
      completions: result,
    }),
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