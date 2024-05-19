process.env.SERVICE_TABLE = 'vkd-qa-service-table';

import { APIGatewayProxyEventV2, APIGatewayProxyEventV2WithLambdaAuthorizer } from 'aws-lambda';
import { randomUUID } from 'crypto';
import { VKDAuthorizerContext } from 'src/authorizer';
import * as dbUtils from '../src/db-utils';
import * as queriesApiDelete from '../src/queries-api-delete';
import * as queriesApiGet from '../src/queries-api-get';
import * as queriesApiGetList from '../src/queries-api-getList';
import * as queriesApiPost from '../src/queries-api-post';
import * as queriesApiPut from '../src/queries-api-put';

import { canonicalize } from './canonicalize';
import { LambdaResponse } from './utils';

describe('queries-api-getList', () => {
  beforeEach(() => {
    process.env.REGION = 'us-east-1';
    process.env.NAMESPACE = 'qa';
    process.env.DB_SECRET_NAME = `vkd/${process.env.NAMESPACE}/dbcreds`;
  });

  it('does a basic query', async () => {
    const ret = await queriesApiGetList.lambdaHandler({
    } as unknown as APIGatewayProxyEventV2WithLambdaAuthorizer<VKDAuthorizerContext>) as LambdaResponse;
    expect(ret.statusCode).toBe(200);
    const body: { rows: { name: string }[] } = JSON.parse(ret.body);
    expect(body.rows.length).toBeGreaterThan(0);
    expect(body.rows.filter(row => row.name === '57').length).toBe(1);
  });
});

describe('queries-api-get', () => {
  beforeEach(() => {
    process.env.REGION = 'us-east-1';
    process.env.NAMESPACE = 'qa';
  });

  it('basic query', async () => {
    const ret = await queriesApiGet.lambdaHandler({
      pathParameters: {
        id: 1
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    expect(ret.statusCode).toBe(200);
    const body: { row: { id: number; name: string } } = JSON.parse(ret.body);
    expect(body.row.id).toBe(1);
    expect(body.row.name).toBe("57");
  });

  describe('queries-api-post', () => {
    it('basic post', async () => {
      const name = randomUUID();
      const ret = await queriesApiPost.lambdaHandler({
        body: JSON.stringify({
          name,
          sqlText: `select hospital_service as cat,  year as label, value from data_developmentalscreening where hospital_service = 'ALL'`,
          columnMap: JSON.stringify({ "ALL": "Vermont" }),
          metadata: JSON.stringify({ "title": "Percent of children with a developmental screening by age 3", "yAxis": { "type": "percent" } })
        })
      } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
      expect(ret.statusCode).toBe(200);
      const body: { id: number; } = JSON.parse(ret.body);
      expect(body.id).toBeGreaterThanOrEqual(14);
    });

    it('disallows existing name', async () => {
      const ret = await queriesApiPost.lambdaHandler({
        body: JSON.stringify({
          name: "57",
          sqlText: `BOGUS`,
        })
      } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
      expect(ret.statusCode).toBe(400);
    });
  });

  describe('queries-api-put', () => {
    beforeEach(() => {
      process.env.REGION = 'us-east-1';
      process.env.NAMESPACE = 'qa';
    });

    it('basic put', async () => {
      const ret = await queriesApiPut.lambdaHandler({
        pathParameters: {
          id: '5'
        },
        body: JSON.stringify({
          name: '61',
          sqlText: `select hospital_service as cat,  year as label, value from data_developmentalscreening where hospital_service = 'ALL'`,
          columnMap: JSON.stringify({ "ALL": "Vermont" }),
          metadata: JSON.stringify({ "title": "Percent of children with a developmental screening by age 3", "yAxis": { "type": "percent" } })
        })
      } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
      expect(ret.statusCode).toBe(200);
      const body: { row: { id: number; name: string; sqlText: string; columnMap: string; metadata: string } } = JSON.parse(ret.body);
      expect(body.row.id).toBe('5');
      expect(body.row.name).toBe('61');
      expect(body.row.sqlText).toBe(`select hospital_service as cat,  year as label, value from data_developmentalscreening where hospital_service = 'ALL'`);
      expect(JSON.parse(body.row.columnMap)).toMatchObject({ "ALL": "Vermont" });
      expect(JSON.parse(body.row.metadata)).toMatchObject({ "title": "Percent of children with a developmental screening by age 3", "yAxis": { "type": "percent" } });
    });

    it('disallows name change', async () => {
      const ret = await queriesApiPut.lambdaHandler({
        pathParameters: {
          id: '5'
        },
        body: JSON.stringify({
          name: '61-999',
          sqlText: `select hospital_service as cat,  year as label, value from data_developmentalscreening where hospital_service = 'ALL'`,
          columnMap: JSON.stringify({ "ALL": "Vermont" }),
          metadata: JSON.stringify({ "title": "Percent of children with a developmental screening by age 3", "yAxis": { "type": "percent" } })
        })
      } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
      expect(ret.statusCode).toBe(400);
    });

    it('working without passing name', async () => {
      const ret = await queriesApiPut.lambdaHandler({
        pathParameters: {
          id: '5'
        },
        body: JSON.stringify({
          sqlText: `select hospital_service as cat,  year as label, value from data_developmentalscreening where hospital_service = 'ALL'`,
          columnMap: JSON.stringify({ "ALL": "Vermont" }),
          metadata: JSON.stringify({ "title": "Percent of children with a developmental screening by age 3", "yAxis": { "type": "percent" } })
        })
      } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
      expect(ret.statusCode).toBe(200);
    });

    it('empty body', async () => {
      const ret = await queriesApiPut.lambdaHandler({
        pathParameters: {
          id: '61'
        },
      } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
      expect(ret.statusCode).toBe(400);
    });

    it('not found', async () => {
      const ret = await queriesApiPut.lambdaHandler({
        pathParameters: {
          id: '99999999999'
        },
        body: JSON.stringify({
          name: '61',
          sqlText: `select hospital_service as cat,  year as label, value from data_developmentalscreening where hospital_service = 'ALL'`,
          columnMap: JSON.stringify({ "ALL": "Vermont" }),
          metadata: JSON.stringify({ "title": "Percent of children with a developmental screening by age 3", "yAxis": { "type": "percent" } })
        })
      } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
      expect(ret.statusCode).toBe(404);
      // const body: { row: { id: number; name: string } } = JSON.parse(ret.body);
      // expect(body.row.id).toBe(1);
      // expect(body.row.name).toBe("57");
    });

  });
});

describe('queries-api-delete', () => {
  let doDBOpenSpy: any;
  let doDBQuerySpy: any;
  let doDBCommitSpy: any;
  let doDBCloseSpy: any;

  beforeEach(() => {
    process.env.REGION = 'us-east-1';
    process.env.NAMESPACE = 'qa';
    doDBOpenSpy = jest.spyOn(dbUtils, 'doDBOpen');
    doDBQuerySpy = jest.spyOn(dbUtils, 'doDBQuery');
    doDBCommitSpy = jest.spyOn(dbUtils, 'doDBCommit');
    doDBCloseSpy = jest.spyOn(dbUtils, 'doDBClose');
  });

  // Actions to be done after each test
  afterEach(() => {
    // Restore the stubs
    doDBOpenSpy.mockRestore();
    doDBQuerySpy.mockRestore();
    doDBCommitSpy.mockRestore();
    doDBCloseSpy.mockRestore();
  });

  const id = 'foobar';

  it('id not found', async () => {
    doDBOpenSpy.mockResolvedValue();
    doDBCommitSpy.mockResolvedValue();
    doDBCloseSpy.mockResolvedValue();
    doDBQuerySpy.mockImplementation(async (sql: string, args: any[]) => {
      const cSql = canonicalize(sql);
      if (cSql === canonicalize('SELECT id, name FROM queries where id=?')) {
        expect(args[0]).toBe(id);
        return [];
      } else {
        throw new Error(`unexpected sql: ${sql}`);
      }
    });
    const ret = await queriesApiDelete.lambdaHandler({
      pathParameters: {
        id
      },
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    expect(ret.statusCode).toBe(404);
    expect(doDBQuerySpy.mock.calls.length).toBe(1);
    expect(doDBOpenSpy.mock.calls.length).toBe(1);
    expect(doDBCommitSpy.mock.calls.length).toBe(0);
    expect(doDBCloseSpy.mock.calls.length).toBe(1);
  });

  it('deletes with id', async () => {
    doDBOpenSpy.mockResolvedValue();
    doDBCommitSpy.mockResolvedValue();
    doDBCloseSpy.mockResolvedValue();

    doDBQuerySpy.mockImplementation(async (sql: string, args: any[]) => {
      const cSql = canonicalize(sql);
      if (cSql === canonicalize('SELECT id, name FROM queries where id=?')) {
        expect(args[0]).toBe(id);
        return [{ id, name: 'foo' }];
      } else if (cSql === canonicalize('delete from queries where id=?')) {
        expect(args[0]).toBe(id);
        return [];
      } else {
        throw new Error(`unexpected sql: ${sql}`);
      }
    });
    const ret = await queriesApiDelete.lambdaHandler({
      pathParameters: {
        id
      },
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    expect(ret.statusCode).toBe(200);
    expect(doDBQuerySpy.mock.calls.length).toBe(2);
    expect(doDBOpenSpy.mock.calls.length).toBe(1);
    expect(doDBCommitSpy.mock.calls.length).toBe(1);
    expect(doDBCloseSpy.mock.calls.length).toBe(1);
  });
});