import { injectLambdaContext, Logger } from '@aws-lambda-powertools/logger';
import { captureLambdaHandler, Tracer } from '@aws-lambda-powertools/tracer';
import middy from '@middy/core';
import cors from '@middy/http-cors';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { doDBClose, doDBOpen, doDBQuery } from "./db-utils";

// Set your service name. This comes out in service lens etc.
const serviceName = `charts-api-${process.env.NAMESPACE}`;
const logger = new Logger({
  logLevel: process.env.LOG_LEVEL || 'INFO',
  serviceName
});
const tracer = new Tracer({ serviceName });

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  if (event.pathParameters == null || event.pathParameters.queryId == null) {
    return {
      statusCode: 400
    };
  } else {
    const queryId = event.pathParameters.queryId;
    // console.log('opening connection');
    await doDBOpen();
    try {
      // Get the query to run from the parameters
      const queryRows = await doDBQuery('SELECT sqlText, metadata, uploadType FROM queries where name=?', [queryId]);
      // console.log(queryRows);
      if (queryRows.length == 0) {
        return {
          statusCode: 400,
          body: JSON.stringify({ message: 'unknown chart' })
        };
      }

      const metadata = JSON.parse(queryRows[0].metadata || '{}');
      const uploadType = queryRows[0].uploadType;
      
      // Now run the query. Should always return three columns, with the following names
      // - cat: The category(s)
      // - label: The label for the values
      // - value: The value for the values
      const resultRows = await doDBQuery(queryRows[0].sqlText);
      // console.log('result', resultRows);

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
      const retSeries: { name: string, data: (number|null)[] }[] = Object.keys(series).map(label => {
        // console.log('label', label);
        return {
          name: label,
          data: categories.map(cat => {
            const val = parseFloat(series[label][cat]);
            return (val < 0 ? null : val);
          })
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
            config: metadata,
            uploadType
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
    } finally {
      await doDBClose();
    }
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
    console.log(await lambdaHandler(event));
  })();
}

export const bar = middy(lambdaHandler)
  .use(captureLambdaHandler(tracer))
  .use(injectLambdaContext(logger))
  .use(
    cors({
      origin: "*",
    })
  );
