import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { httpResponse } from '../src/cors';
import { table } from '../src/tablesApi';

interface Response {
  body: string,
  statusCode: number,
}

const tableInfo = {
  topics: {
    ref: 'name'
  },
  categories: {
    ignored: ['id', 'Category'],
    ref: 'Category'
  },
  subcategories: {
    ignored: ['id', 'Category'],
    ref: 'Category'
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
    ref: 'Category'
  }
}

type ValidThingNames = 'categories' | 'subcategories' | 'indicators';
type ValidRefNames = 'topics' | 'categories' | 'subcategories';

interface Data {
  rows: Record<string, string | number>[]
}

function validate(thingName: ValidThingNames, things: Data, refName: ValidRefNames, refs: Data): {
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
  const usedRefs: Record<string, boolean> = {};

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
      console.error({ message: 'column(s) not found!', thingName, errors: columnsNotFound });
      break;
    }
  }

  // Find the unused refs
  const unusedRefs = validRefs.filter(ref => !usedRefs[ref]);

  return { columnsNotFound, unusedRefs: unusedRefs.length ? unusedRefs : undefined };
}

function humanToInternalFrontEnd(name: string): string {
  return name.toLowerCase();
}

interface TopicsRow {
  id: number,
  name: string
}

interface CategoryRow {
  id: number,
  Category: string,

  // Everything else a topic and a number
  [key: string]: string | number
}

interface SubCategoryRow {
  id: number,
  Category: string,

  // Everything else a subcategory and a number
  [key: string]: string | number
}

interface IndicatorRow {
  id: number,
  wp_id: number,
  slug: string,
  Chart_url: string,
  link: string,
  title: string,

  // Everything else a subcategory and a number
  [key: string]: string | number
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

  console.log({ resp: 'topicsResp', rows: JSON.parse(topicsResp.body).rows });
  console.log({ resp: 'categoriesResp', rows: JSON.parse(categoriesResp.body).rows });
  console.log({ resp: 'subcategoriesResp', rows: JSON.parse(subcategoriesResp.body).rows });
  console.log({ resp: 'indicatorsResp', rows: JSON.parse(indicatorsResp.body).rows });

  const topicRows: TopicsRow[] = JSON.parse(topicsResp.body).rows;
  const categoryRows: CategoryRow[] = JSON.parse(categoriesResp.body).rows;
  const subcategoryRows: SubCategoryRow[] = JSON.parse(subcategoriesResp.body).rows;
  const indicatorRows: IndicatorRow[] = JSON.parse(indicatorsResp.body).rows;

  const catCounts: Record<string, number> = {};
  for (const categoryRow of categoryRows) {
    // console.log({ row: categoryRow });
    for (const subcategoryRow of subcategoryRows) {
      // console.log({ catToCheck: categoryRow.Category, subcategoryRow });
      if (subcategoryRow[categoryRow.Category]) {
        const key = `${categoryRow.Category}|${subcategoryRow.Category}`;
        console.log({ message: 'subcategory in category', subcat: subcategoryRow.Category, cat: categoryRow.Category, key });

        if (catCounts[key] == null) {
          catCounts[key] = 0;
        }

        for (const indicatorRow of indicatorRows) {
          // console.log({ indicatorRow });
          if (indicatorRow[subcategoryRow.Category]) {
            console.log({ message: 'indicator in subcategory', subcat: subcategoryRow.Category, cat: categoryRow.Category });

            catCounts[key]++;
          }
        }
      }
    }
  }
  console.log({ catCounts });

  const data = {
    "id": "dashboard:indicators:chart",
    "metadata": {
      "config": {
        "yAxis": {
          "type": "number"
        }
      },
      // "uploadType": "general:residentialcare" <-- no upload
    },
    "series":
      // {
      //   "name": "under 9",
      //   "data": [
      //     22,
      //     34
      //   ]
      // },
      Object.keys(catCounts).map(key => ({
        "name": key.substring(key.indexOf('|') + 1),
        "data": [catCounts[key]]
      })),
    "categories": [
      'indicators'
    ]
  };
  return httpResponse(200, data, true);
}

(async () => {
  console.log(await check({} as any));
})();