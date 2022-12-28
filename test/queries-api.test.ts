import { APIGatewayProxyEventV2 } from 'aws-lambda';
import { } from '../src/db-utils';
import * as queriesApiGetList from '../src/queries-api-getList';
import { LambdaResponse } from './utils';

describe('queries-api-getList', () => {
  beforeEach(() => {
    process.env.REGION = 'us-east-1';
    process.env.NAMESPACE = 'qa';
  });

  it('basic query', async () => {
    const ret = await queriesApiGetList.lambdaHandler({
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    console.log('query response -->', ret.body);
    expect(ret.statusCode).toBe(200);
    const body: { rows: { name: string }[] } = JSON.parse(ret.body);
    expect(body.rows.length).toBeGreaterThan(0);
    expect(body.rows.filter(row => row.name === '57').length).toBe(1);
  });

});
