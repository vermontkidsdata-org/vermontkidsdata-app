process.env.SERVICE_TABLE = 'vkd-qa-service-table';

import { APIGatewayProxyEventV2 } from 'aws-lambda';
import { lambdaHandlerBar } from '../src/chartsApi';
import { } from '../src/db-utils';
import { expectCORS, LambdaResponse } from './utils';

describe('chartsApi', () => {
  beforeEach(() => {
    process.env.REGION = 'us-east-1';
    process.env.VKD_ENVIRONMENT = 'qa';
    process.env.DB_SECRET_NAME = `vkd/${process.env.VKD_ENVIRONMENT}/dbcreds`;
  });
  
  test('basic query', async () => {
    // queryDBSpy.mock.invocationCall in mockResolvedValue(BOGUS_BRANCH_NAME);

    const ret = await lambdaHandlerBar({
      pathParameters: {
        queryId: '60'
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    // {
    //   "id": "60",
    //   "metadata": { "config": { "title": "Percent of children under 18 adequately covered by health insurance", "yAxis": { "type": "percent" } } },
    //   "series": [{ "name": "Percent Children Covered", "data": [79, 78] }],
    //   "categories": ["2017-2018", "2019-2020"]
    // }
    expect(ret.statusCode).toBe(200);
    const body = JSON.parse(ret.body);
    expect(body.series[0].data[0]).toBe(79.2);
    expect(body.series[1].data[0]).toBe(78.2);

    // Make sure even the error response has CORS headers
    expectCORS(ret);
  });

  test('returns null on -1', async () => {
    // queryDBSpy.mock.invocationCall in mockResolvedValue(BOGUS_BRANCH_NAME);

    const ret = await lambdaHandlerBar({
      pathParameters: {
        queryId: 'women_no_leave:chart'
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    // {
    //   "id": "60",
    //   "metadata": { "config": { "title": "Percent of children under 18 adequately covered by health insurance", "yAxis": { "type": "percent" } } },
    //   "series": [{ "name": "Percent Children Covered", "data": [79, 78] }],
    //   "categories": ["2017-2018", "2019-2020"]
    // }
    expect(ret.statusCode).toBe(200);
    const body = JSON.parse(ret.body);
    console.log({body: JSON.stringify(body)});
    expect(body.series[0].data[3]).toBeNull();
    // expect(body.series[1].data[0]).toBe(78.2);

    // Make sure even the error response has CORS headers
    expectCORS(ret);
  });

});
