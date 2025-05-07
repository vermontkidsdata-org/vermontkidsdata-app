process.env.SERVICE_TABLE = 'vkd-qa-service-table';

import { APIGatewayProxyEventV2 } from 'aws-lambda';
import { lambdaHandlerBar } from '../src/chartsApi';
import { doDBOpen, doDBQuery, doDBClose } from '../src/db-utils';
import { expectCORS, LambdaResponse } from './utils';

// Mock the database functions
jest.mock('../src/db-utils', () => ({
  doDBOpen: jest.fn(),
  doDBQuery: jest.fn(),
  doDBClose: jest.fn(),
}));

const mockDoDBOpen = doDBOpen as jest.Mock;
const mockDoDBQuery = doDBQuery as jest.Mock;
const mockDoDBClose = doDBClose as jest.Mock;

describe('chartsApi', () => {
  beforeEach(() => {
    process.env.REGION = 'us-east-1';
    process.env.VKD_ENVIRONMENT = 'qa';
    process.env.DB_SECRET_NAME = `vkd/${process.env.VKD_ENVIRONMENT}/dbcreds`;
    
    // Reset mocks
    jest.clearAllMocks();
    
    // Set up default mock implementations
    mockDoDBOpen.mockResolvedValue(undefined);
    mockDoDBClose.mockResolvedValue(undefined);
  });
  
  test('basic query', async () => {
    // Mock query results for getQueryRow
    mockDoDBQuery.mockResolvedValueOnce([{
      sqlText: 'SELECT cat, label, value FROM data',
      metadata: '{"config": {"title": "Percent of children under 18 adequately covered by health insurance", "yAxis": {"type": "percent"}}}',
      uploadType: 'test-upload'
    }]);
    
    // Mock query results for getDefaultDataset
    mockDoDBQuery.mockResolvedValueOnce([
      { cat: '2017-2018', label: 'Series 1', value: '79.2' },
      { cat: '2019-2020', label: 'Series 1', value: '78.2' },
      { cat: '2017-2018', label: 'Series 2', value: '79.2' },
      { cat: '2019-2020', label: 'Series 2', value: '78.2' }
    ]);

    const ret = await lambdaHandlerBar({
      pathParameters: {
        queryId: '60'
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    
    expect(ret.statusCode).toBe(200);
    const body = JSON.parse(ret.body);
    expect(body.series[0].data[0]).toBe(79.2);
    expect(body.series[1].data[0]).toBe(79.2);

    // Make sure even the error response has CORS headers
    expectCORS(ret);
  });

  test('returns null on -1', async () => {
    // Mock query results for getQueryRow
    mockDoDBQuery.mockResolvedValueOnce([{
      sqlText: 'SELECT cat, label, value FROM data',
      metadata: '{"config": {"title": "Women with no paid leave", "yAxis": {"type": "percent"}}}',
      uploadType: 'test-upload'
    }]);
    
    // Mock query results for getDefaultDataset with a negative value that should be converted to null
    mockDoDBQuery.mockResolvedValueOnce([
      { cat: 'Cat1', label: 'Series 1', value: '10' },
      { cat: 'Cat2', label: 'Series 1', value: '20' },
      { cat: 'Cat3', label: 'Series 1', value: '30' },
      { cat: 'Cat4', label: 'Series 1', value: '-1' } // This should be converted to null
    ]);

    const ret = await lambdaHandlerBar({
      pathParameters: {
        queryId: 'women_no_leave:chart'
      }
    } as unknown as APIGatewayProxyEventV2) as LambdaResponse;
    
    expect(ret.statusCode).toBe(200);
    const body = JSON.parse(ret.body);
    expect(body.series[0].data[3]).toBeNull(); // Check that -1 was converted to null
    
    // Make sure even the error response has CORS headers
    expectCORS(ret);
  });

});
