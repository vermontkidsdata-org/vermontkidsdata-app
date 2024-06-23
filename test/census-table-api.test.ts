process.env.SERVICE_TABLE = 'vkd-qa-service-table';

import { APIGatewayProxyEventV2 } from 'aws-lambda';
import * as dbUtils from '../src/db-utils';
import * as tablesApi from '../src/tablesApi';
import { expectCORS, LambdaResponse } from './utils';

interface APIResponse {
  body: string,
  headers: {
    [key: string]: string
  },
  statusCode: number
}

jest.setTimeout(10000);

describe('Census Table API', () => {
  let queryDBSpy: any;
  beforeEach(() => {
    // Stub all external dependency functions of module to be tested
    queryDBSpy = jest.spyOn(dbUtils, 'queryDB');
    process.env.VKD_ENVIRONMENT = 'qa';
    process.env.REGION = 'us-east-1';
    process.env.DB_SECRET_NAME = `vkd/${process.env.VKD_ENVIRONMENT}/dbcreds`;
  });
  // Actions to be done after each test
  afterEach(() => {
    // Restore the stubs
    queryDBSpy.mockRestore();
  });

  describe('getDataSetYearsByDataset', () => {
    it('works normally', async () => {
      const values = [1776, 1987];
      queryDBSpy.mockResolvedValue(values.map(vintage => ({
        vintage
      } as tablesApi.CensusDataset)));

      const ret = await tablesApi.getDataSetYearsByDataset({
        pathParameters: {
          dataset: 'acs/acs5'
        }
      } as unknown as APIGatewayProxyEventV2) as APIResponse;
      expect(ret.statusCode).toBe(200);
      const body = JSON.parse(ret.body);
      expect(body.years.length).toBe(2);
      expect(body.years[0]).toBe(1776);
      expect(body.years[1]).toBe(1987);
      expect(Object.keys(ret.headers).find(k => k.toLowerCase() === 'access-control-allow-origin')).not.toBeUndefined();
    })

    it('returns no data with unknown dataset', async () => {
      queryDBSpy.mockResolvedValue([]);

      const ret = await tablesApi.getDataSetYearsByDataset({
        pathParameters: {
          dataset: 'acs/acs5-x'
        }
      } as unknown as APIGatewayProxyEventV2) as APIResponse;
      expect(ret.statusCode).toBe(200);
      const body = JSON.parse(ret.body);
      expect(body.years.length).toBe(0);
      expect(Object.keys(ret.headers).find(k => k.toLowerCase() === 'access-control-allow-origin')).not.toBeUndefined();
    });

    it('errors without param', async () => {
      const ret = await tablesApi.getDataSetYearsByDataset({
        pathParameters: {
          // dataset: 'acs/acs5'
        }
      } as unknown as APIGatewayProxyEventV2) as APIResponse;
      expect(ret.statusCode).toBe(400);
      expect(Object.keys(ret.headers).find(k => k.toLowerCase() === 'access-control-allow-origin')).not.toBeUndefined();
    });

    it('gets 500 on exception', async () => {
      queryDBSpy.mockImplementation(() => {
        throw new Error('some exception');
      })

      const ret = await tablesApi.getDataSetYearsByDataset({
        pathParameters: {
          dataset: 'acs/acs5-x'
        }
      } as unknown as APIGatewayProxyEventV2) as APIResponse;
      expect(ret.statusCode).toBe(500);
      expect(Object.keys(ret.headers).find(k => k.toLowerCase() === 'access-control-allow-origin')).not.toBeUndefined();
    });

  });

  it('S1701 -- unknown vars', async () => {
    // queryDBSpy.mock.invocationCall in mockResolvedValue(BOGUS_BRANCH_NAME);

    const ret = await tablesApi.getCensusByGeo({
      pathParameters: {
        table: 'S1701',
        geoType: 'head_start'
      }, queryStringParameters: {
        variables: 'S1701_C01_044E,S1601_C01_001E,S1601_C01_002E'
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;

    expect(ret.statusCode).toBe(400);
    const body = JSON.parse(ret.body) as tablesApi.ErrorResponse;
    expect(body.message).toContain('S1601_C01_001E,S1601_C01_002E');
    expect(body.message).not.toContain('S1701_C01_044E');
    // Make sure even the error response has CORS headers
    expectCORS(ret);
  });

  it('getGeosByType for county', async () => {
    const ret = await tablesApi.getGeosByType({
      pathParameters: { geoType: 'county' }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    const resp = JSON.parse(ret.body) as tablesApi.GetGeosByTypeResponse;
    expect(resp.geos).toBeDefined();
    expect(resp.geos.length).toBe(14);
    expectCORS(ret);
  });
  it('HS region, valid year for acs1, only two variables', async () => {
    const ret = await tablesApi.getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'head_start'
      }, queryStringParameters: {
        year: '2005',
        dataset: 'acs/acs1',
        variables: 'B09001_002E,B09001_001E'
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    expect(ret.statusCode).toBe(200);
    const body: tablesApi.GetCensusByGeoResponse = JSON.parse(ret.body);
    expect(body.metadata.variables?.length).toBe(2);
    expect(body.metadata.variables?.toString()).toBe('B09001_002E,B09001_001E');
    expect(body.columns.length).toBe(3);
    expect(body.columns[0].id).toBe('geo');
    expect(body.columns[1].id).toBe('B09001_002E');
    expect(body.columns[2].id).toBe('B09001_001E');
    expectCORS(ret);
  });

  it('AHS district', async () => {
    const ret = await tablesApi.getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'ahs_district'
      }, queryStringParameters: {}
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    expect(ret.statusCode).toBe(200);
    const body: tablesApi.GetCensusByGeoResponse = JSON.parse(ret.body);
    expect(body.columns.length).toBe(11);
    expect(body.rows.length).toBe(13);
    expect(body.rows[0].geo).toBe("Barre");
    expect(body.rows[0].B09001_001E).toBe(12164);
    expect(body.rows[12].geo).toBe("Vermont");
    expect(body.rows[12].B09001_001E).toBe(115632);
    expectCORS(ret);
  });

  it('HS region, invalid year', async () => {
    const ret = await tablesApi.getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'head_start'
      }, queryStringParameters: {
        year: '1776'
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    expect(ret.statusCode).toBe(400);
    const body = JSON.parse(ret.body) as tablesApi.ErrorResponse;
    expect(body.message).toContain('invalid year/dataset combination');
    expectCORS(ret);
  });

  it('verify even a 500 has a CORS header', async () => {
    const ret = await tablesApi.getCensusByGeo(undefined as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    expect(ret.statusCode).toBe(500);
    expectCORS(ret);
  });

  it('MOEs', async () => {
    const ret = await tablesApi.getCensusByGeo({
      pathParameters: {
        table: 'S1701',
        geoType: 'head_start'
      }, queryStringParameters: {
        variables: 'S1701_C01_044E',
        extensions: 'moe'
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    expect(ret.statusCode).toBe(200);
    const body: tablesApi.GetCensusByGeoResponse = JSON.parse(ret.body);
    expect(body.metadata.variables?.length).toBe(2);
    expect(body.metadata.variables).toContain('S1701_C01_044E');
    expect(body.metadata.variables).toContain('S1701_C01_044M');
    expect(body.columns.length).toBe(3);
    expect(body.rows.length).toBe(8);
    expect(body.rows[0].geo).toBe('Bennington County HS/EHS');
    expect(body.rows[0].S1701_C01_044E).toBe(20676);
    expect(body.rows[0].S1701_C01_044M).toBe(3280);
  }, 25000);
});
