console.log('top of testcitylambda file');

import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { census } from '/opt/nodejs/citysdk-utils';

console.log('after import of census in testcitylambda file');

// Only run if executed directly
if (!module.parent) {
    (main({} as any)).then((res) => {
      console.log('called directly', res);
    })
  }
  
  export async function main(
    event: APIGatewayProxyEventV2,
  ): Promise<APIGatewayProxyResultV2> {
    console.log('starting main function');
    //get the ACS5 2017 population for all counties in the California
    const result = await census({
        vintage: '2017',
        geoHierarchy: {
          state: "06",
          county: '*',
        },
        sourcePath: ['acs','acs5'],
        values: ['B00001_001E'],
      });
  
    console.log('event 👉', event);
  // Lambda compile error
    return {
      body: JSON.stringify({
        message: 'Successful lambda invocation',
        result: result
      }),
      statusCode: 200,
    };
  }
  