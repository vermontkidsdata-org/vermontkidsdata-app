import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { HttpStatusCode } from 'axios';
import { httpResponse } from './cors';
import { table } from './tablesApi';

interface Response {
  body: string,
  statusCode: number,
}

const tableInfo = {
  topics: {
    ref: 'name',
  },
  categories: {
    ignored: ['id', 'Category'],
    ref: 'Category',
  },
  subcategories: {
    ignored: ['id', 'Category'],
    ref: 'Category',
  },
  indicators: {
    ignored: ['id', 'link', 'slug', 'title', 'wp_id', 'Chart_url',
    // I'm not sure where these come in...
    'geo_state',
    'geo_ahs_district',
    'geo_county',
    'geo_su_sd',
    'geo_hsa',
    'goal 1 (healthy start)',
    'goal 2 (families and comm)',
    'goal 3 (opportunties)',
    'goal 4 (integrated/resource/data-drive)',
  ],
    ref: 'Category',
  },
}

type ValidThingNames = 'categories' | 'subcategories' | 'indicators';
type ValidRefNames = 'topics' | 'categories' | 'subcategories';

interface Data {
  rows: Record<string,string|number>[]
}

function validate(thingName: ValidThingNames , things: Data, refName: ValidRefNames, refs: Data): {
  columnsNotFound?: string[],
  unusedRefs?: string[],
} {
  let columnsNotFound: string[] | undefined = undefined;

  // console.log({ topics: topics.rows });
  const thingInfo = tableInfo[thingName];
  const refInfo = tableInfo[refName];

  const validRefs: string[] = refs.rows.map((row: Record<string, any>) => row[refInfo.ref]);
  const ignored = thingInfo.ignored.map(col => humanToInternalFrontEnd(col));

  // console.log({ validTopics: validRefs});
  const usedRefs: Record<string,boolean> = {};

  for (const row of things.rows) {
    console.log(row);
    for (const col of Object.keys(row)) {
      const intCol = humanToInternalFrontEnd(col);
      const found = validRefs.find(ref => humanToInternalFrontEnd(ref) === intCol);
      if (found) {
        usedRefs[found] = true;
      }

      if (!found && !ignored.includes(intCol)) {
        if (!columnsNotFound) columnsNotFound = [];
        columnsNotFound.push(col);
      }
    }

    if (columnsNotFound?.length) {
      console.error({message: 'column(s) not found!', thingName, errors: columnsNotFound});
      break;
    }
  }

  // Find the unused refs
  const unusedRefs = validRefs.filter(ref => !usedRefs[ref]);
  
  return {columnsNotFound, unusedRefs: unusedRefs.length ? unusedRefs : undefined};
}

function humanToInternalFrontEnd(name: string): string {
  return name.toLowerCase();
}

export async function check(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {  
  if (!process.env.VKD_ENVIRONMENT) process.env.VKD_ENVIRONMENT = 'qa';

  const topicsResp = await table({
    pathParameters: { queryId: 'dashboard:topics:table' },
  } as unknown as APIGatewayProxyEventV2) as Response;

  const categoriesResp = await table({
    pathParameters: { queryId: 'dashboard:categories:table' },
  } as unknown as APIGatewayProxyEventV2) as Response;

  const subcategoriesResp = await table({
    pathParameters: { queryId: 'dashboard:subcategories:table' },
  } as unknown as APIGatewayProxyEventV2) as Response;

  const indicatorsResp = await table({
    pathParameters: { queryId: 'dashboard:indicators:table' },
  } as unknown as APIGatewayProxyEventV2) as Response;

  if (topicsResp.statusCode !== HttpStatusCode.Ok || categoriesResp.statusCode !== HttpStatusCode.Ok ||
    subcategoriesResp.statusCode !== HttpStatusCode.Ok || indicatorsResp.statusCode !== HttpStatusCode.Ok) {
    console.log('bad status');
    process.exit(1);
  }

  console.log('OK status');
  const topics = JSON.parse(topicsResp.body);
  const categories = JSON.parse(categoriesResp.body);
  const subcategories = JSON.parse(subcategoriesResp.body);
  const indicators = JSON.parse(indicatorsResp.body);

  interface TableErrors {
    columnsNotFound?: string[],
    unusedRefs?: string[],
  }

  // console.log({ topics, categories, subcategories, indicators });
  // First make sure topics -> categories, using front end comparison
  const errors: {
    topics: TableErrors,
    categories: TableErrors,
    subcategories: TableErrors,
    indicators: TableErrors,
  } = {
    topics: { },
    categories: { },
    subcategories: { },
    indicators: { },
  };

  ({
    columnsNotFound: errors.categories.columnsNotFound,
    unusedRefs: errors.topics.unusedRefs,
  } = validate('categories', categories, 'topics', topics));
  
  ({
    columnsNotFound: errors.subcategories.columnsNotFound,
    unusedRefs: errors.categories.unusedRefs,
  } = validate('subcategories', subcategories, 'categories', categories));

  ({
    columnsNotFound: errors.indicators.columnsNotFound,
    unusedRefs: errors.subcategories.unusedRefs,
  } = validate('indicators', indicators, 'subcategories', subcategories));
  
  return httpResponse(200, errors, true);
}

(async () => {
  console.log(await check({} as any));
})();