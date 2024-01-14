import { APIGatewayProxyEventV2 } from "aws-lambda";
import { QueryRow } from "../chartsApi";
import { table } from "../tablesApi";

interface Response {
  body: string,
  statusCode: number,
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

interface CustomResponse {
  id: string,
  metadata: {
    config: {
      yAxis: {
        type: string
      }
    },
  },
  series: {
    name: string,
    data: number[]
  }[],
  categories: string[]
}

export async function getResponse(queryRow: QueryRow): Promise<CustomResponse> {
  if (!process.env.NAMESPACE) process.env.NAMESPACE = 'qa';

  // const topicsResp = await table({
  //   pathParameters: { queryId: 'dashboard:topics:table' },
  // } as unknown as APIGatewayProxyEventV2) as Response;

  const categoriesResp = await table({
    pathParameters: { queryId: 'dashboard:categories:table' },
  } as unknown as APIGatewayProxyEventV2) as Response;

  const subcategoriesResp = await table({
    pathParameters: { queryId: 'dashboard:subcategories:table' },
  } as unknown as APIGatewayProxyEventV2) as Response;

  const indicatorsResp = await table({
    pathParameters: { queryId: 'dashboard:indicators:table' },
  } as unknown as APIGatewayProxyEventV2) as Response;
  console.log({ message: 'raw indicatorsResp', indicatorsResp });

  // console.log({ resp: 'topicsResp', rows: JSON.parse(topicsResp.body).rows });
  // console.log({ resp: 'categoriesResp', rows: JSON.parse(categoriesResp.body).rows });
  // console.log({ resp: 'subcategoriesResp', rows: JSON.parse(subcategoriesResp.body).rows });
  // console.log({ resp: 'indicatorsResp', rows: JSON.parse(indicatorsResp.body).rows });

  // const topicRows: TopicsRow[] = JSON.parse(topicsResp.body).rows;
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
  return data;
}