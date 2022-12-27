import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import * as mysql from 'mysql';
import { doOpen, getDBSecret, query } from "./db-utils";

function getRegion(): string {
  return process.env.REGION || 'us-east-1';
}

function getNamespace(): string {
  if (process.env.NAMESPACE) return process.env.NAMESPACE;
  else throw new Error("process.env.NAMESPACE not passed");
}

export async function bar(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  if (event.pathParameters == null || event.pathParameters.queryId == null) {
    return {
      statusCode: 400
    };
  } else {
    const queryId = event.pathParameters.queryId;
    try {
      // console.log('opening connection');
      const connection = await doOpen();
      // console.log('connection open');

      // Get the query to run from the parameters
      const queryRows = await query(connection, 'SELECT sqlText, metadata FROM queries where name=?', [queryId]);
      // console.log(queryRows);
      if (queryRows.length == 0) {
        await connection.end();
        return {
          statusCode: 400,
          body: JSON.stringify({ message: 'unknown chart' })
        };
      }

      const metadata = JSON.parse(queryRows[0].metadata || '{}');

      // Now run the query. Should always return three columns, with the following names
      // - cat: The category(s)
      // - label: The label for the values
      // - value: The value for the values
      const resultRows = await query(connection, queryRows[0].sqlText);
      // console.log('result', resultRows);

      // console.log('closing connection');
      await connection.end();
      // console.log('connection closed');

      interface QueryResult {
        cat: string,
        label: string,
        value: string
      };
      const categories: string[] = [];
      const series: { [label: string]: { [key: string]: string } } = {};
      resultRows.forEach((row: QueryResult) => {
        const cat = row.cat;
        const label = row.label;
        const value = row.value;
        if (series[label] == null) {
          series[label] = {};   // Keyed by category
        }
        if (!categories.includes(cat)) {
          categories.push(cat);
        }
        series[label][cat] = value;
      });

      // console.log('categories', categories);
      // console.log('series', series);
      const retSeries: { name: string, data: number[] }[] = Object.keys(series).map(label => {
        // console.log('label', label);
        return {
          name: label,
          data: categories.map(cat => parseFloat(series[label][cat]))
        };
      });
      // console.log('retSeries', retSeries);

      return {
        statusCode: 200,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json",
          "Access-Control-Allow-Methods": "GET",
        },
        body: JSON.stringify({
          id: queryId,
          metadata: {
            config: metadata
          },
          series: retSeries,
          categories: categories
        })
      };

    } catch (e) {
      console.error(e);
      return {
        statusCode: 500,
        body: (e as Error).message
      };
    }
    // let series = [{ name: 'All Students', data: [50,52] },
    //   { name: 'Free and Reduced Lunch', data: [35,38] },
    //   { name: 'Special Education', data: [13,17] },
    //   { name: 'Historically Marginalized', data: [36,39] }
    // ];
    // let categories = [ 'Jan', 'Feb' ];

    // return {
    //   body: JSON.stringify({
    //     "id": queryId,
    //     "series": series,
    //     "categories": categories
    //     }
    //   ),
    //   headers: {
    //     'Access-Control-Allow-Origin': '*'
    //   },
    //   statusCode: 200
    // }; 
  }
}

// Only run if executed directly
if (!module.parent) {
  (async () => {
    const event: APIGatewayProxyEventV2 = {
      pathParameters: {
        queryId: '59'
      }
    } as unknown as APIGatewayProxyEventV2;
    console.log(await bar(event));
  })();
}