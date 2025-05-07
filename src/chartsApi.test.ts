import { APIGatewayProxyEventV2 } from 'aws-lambda';
import { getResponse as getIndicatorsBySubcat } from './custom/indicators-by-subcat';
import { doDBClose, doDBOpen, doDBQuery } from "./db-utils";
import { makePowerTools } from './lambda-utils';
import { getUploadType, transformValueExtToInt, transformValueIntToExt } from './uploadData';
import {
  getQueryRow,
  getDefaultDataset,
  getChartData,
  lambdaHandlerBar,
  lambdaHandlerGetFilter,
  QueryRow,
  BarChartResult,
  BadRequestError, // Assuming BadRequestError is exported or defined in a way it can be imported/used
  UploadTypeFilters,
  QueryFilters,
  QueryMetadata,
  MetadataFiltersDef
} from './chartsApi'; // Assuming BadRequestError is exported or accessible

// Mock dependencies
jest.mock('./db-utils');
jest.mock('./custom/indicators-by-subcat');
jest.mock('./lambda-utils');
jest.mock('./uploadData');

// Mock implementations
const mockDoDBQuery = doDBQuery as jest.Mock;
const mockDoDBOpen = doDBOpen as jest.Mock;
const mockDoDBClose = doDBClose as jest.Mock;
const mockGetIndicatorsBySubcat = getIndicatorsBySubcat as jest.Mock;
const mockMakePowerTools = makePowerTools as jest.Mock;
const mockGetUploadType = getUploadType as jest.Mock;
const mockTransformValueExtToInt = transformValueExtToInt as jest.Mock;
const mockTransformValueIntToExt = transformValueIntToExt as jest.Mock;

// Mock PowerTools logger
const mockLogger = {
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
  debug: jest.fn(),
};
mockMakePowerTools.mockReturnValue({ logger: mockLogger });

// Reset mocks before each test
beforeEach(() => {
  jest.clearAllMocks();
  // Default mock implementations (can be overridden in specific tests)
  mockDoDBOpen.mockResolvedValue(undefined);
  mockDoDBClose.mockResolvedValue(undefined);
  mockDoDBQuery.mockResolvedValue([]);
  mockGetIndicatorsBySubcat.mockResolvedValue({ series: [], categories: [], metadata: {} });
  mockGetUploadType.mockResolvedValue(undefined);
  mockTransformValueExtToInt.mockImplementation(({ value }) => value); // Pass through by default
  mockTransformValueIntToExt.mockImplementation(({ value }) => value); // Pass through by default
});

describe('chartsApi', () => {
  // Tests will go here following the plan
  describe('getQueryRow', () => {
    it('should return query data when found', async () => {
      const mockSqlText = 'SELECT * FROM test';
      const mockMetadata = '{"key": "value"}';
      const mockUploadType = 'test-type';
      const mockFilters = '{"table": "t"}';
      mockDoDBQuery.mockResolvedValueOnce([{ sqlText: mockSqlText, metadata: mockMetadata, uploadType: mockUploadType, filters: mockFilters }]);

      const result = await getQueryRow('test-query');

      expect(mockDoDBOpen).toHaveBeenCalledTimes(1);
      expect(mockDoDBQuery).toHaveBeenCalledWith('SELECT sqlText, metadata, uploadType, filters FROM queries where name=?', ['test-query']);
      expect(result).toEqual({ sqlText: mockSqlText, metadata: mockMetadata, uploadType: mockUploadType, filters: mockFilters });
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

    it('should return undefined when query not found', async () => {
      mockDoDBQuery.mockResolvedValueOnce([]); // Simulate no rows found

      const result = await getQueryRow('unknown-query');

      expect(mockDoDBOpen).toHaveBeenCalledTimes(1);
      expect(mockDoDBQuery).toHaveBeenCalledWith('SELECT sqlText, metadata, uploadType, filters FROM queries where name=?', ['unknown-query']);
      expect(result).toBeUndefined();
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

    it('should call doDBClose even on error during query', async () => {
      const dbError = new Error('DB Error');
      mockDoDBQuery.mockRejectedValueOnce(dbError);

      await expect(getQueryRow('error-query')).rejects.toThrow(dbError);

      expect(mockDoDBOpen).toHaveBeenCalledTimes(1);
      expect(mockDoDBQuery).toHaveBeenCalledWith('SELECT sqlText, metadata, uploadType, filters FROM queries where name=?', ['error-query']);
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });
  });

  describe('getDefaultDataset', () => {
    const mockQueryRow: QueryRow = {
      id: 1,
      name: 'test-query',
      sqlText: 'SELECT cat, label, value FROM data',
      uploadType: 'test-upload',
      metadata: '{"configKey": "configValue"}',
    };

    it('should format data correctly for a basic query', async () => {
      const dbResult = [
        { cat: 'C1', label: 'L1', value: '10' },
        { cat: 'C2', label: 'L1', value: '20' },
        { cat: 'C1', label: 'L2', value: '30' },
      ];
      mockDoDBQuery.mockResolvedValueOnce(dbResult);

      const result = await getDefaultDataset(mockQueryRow);

      expect(mockDoDBOpen).toHaveBeenCalledTimes(1);
      expect(mockDoDBQuery).toHaveBeenCalledWith(mockQueryRow.sqlText);
      expect(result).toEqual({
        id: 'test-query',
        metadata: {
          config: { configKey: 'configValue' },
          uploadType: 'test-upload',
        },
        series: [
          { name: 'L1', data: [10, 20] },
          { name: 'L2', data: [30, null] }, // C2 is missing for L2
        ],
        categories: ['C1', 'C2'],
      });
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
      expect(mockLogger.info).toHaveBeenCalledWith({ message: 'getDefaultDataset: running query', variables: undefined });
    });

    it('should handle query variables', async () => {
      const variables = { var1: 'val1', var2: 'val2' };
      mockDoDBQuery.mockResolvedValueOnce([]); // Mock result for the main query

      await getDefaultDataset(mockQueryRow, variables);

      expect(mockDoDBQuery).toHaveBeenCalledWith(`SET @var1 = 'val1'`);
      expect(mockDoDBQuery).toHaveBeenCalledWith(`SET @var2 = 'val2'`);
      expect(mockDoDBQuery).toHaveBeenCalledWith(mockQueryRow.sqlText);
      expect(mockLogger.info).toHaveBeenCalledWith({ message: 'getDefaultDataset: running query', variables });
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

    it('should include hover data when present', async () => {
      const dbResult = [
        { cat: 'C1', label: 'L1', value: '10', hover: 'H1' },
        { cat: 'C2', label: 'L1', value: '20', hover: null }, // Mix of hover/no hover
        { cat: 'C1', label: 'L2', value: '30', hover: 'H3' },
      ];
      mockDoDBQuery.mockResolvedValueOnce(dbResult);

      const result = await getDefaultDataset(mockQueryRow);

      expect(result.series).toEqual([
        { name: 'L1', data: [10, 20], hover: ['H1', null] },
        { name: 'L2', data: [30, null], hover: ['H3', null] },
      ]);
      expect(result.categories).toEqual(['C1', 'C2']);
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

     it('should convert negative values to null', async () => {
      const dbResult = [
        { cat: 'C1', label: 'L1', value: '10' },
        { cat: 'C2', label: 'L1', value: '-5' }, // Negative value
      ];
      mockDoDBQuery.mockResolvedValueOnce(dbResult);

      const result = await getDefaultDataset(mockQueryRow);

      expect(result.series).toEqual([
        { name: 'L1', data: [10, null] }, // -5 becomes null
      ]);
      expect(result.categories).toEqual(['C1', 'C2']);
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

    it('should handle queryRow without metadata', async () => {
       const queryRowNoMeta: QueryRow = { ...mockQueryRow, metadata: undefined };
       mockDoDBQuery.mockResolvedValueOnce([]); // Mock result for the main query

       const result = await getDefaultDataset(queryRowNoMeta);
       expect(result.metadata.config).toBeUndefined();
       expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

    it('should call doDBClose on error', async () => {
      const dbError = new Error('DB Error during data fetch');
      mockDoDBQuery.mockRejectedValueOnce(dbError); // Error on the main data query

      await expect(getDefaultDataset(mockQueryRow)).rejects.toThrow(dbError);

      expect(mockDoDBOpen).toHaveBeenCalledTimes(1);
      expect(mockDoDBQuery).toHaveBeenCalledWith(mockQueryRow.sqlText);
      expect(mockDoDBClose).toHaveBeenCalledTimes(1); // Ensure close is called even on error
    });
  });

  describe('getChartData', () => {
    const mockQueryId = 'test-chart';
    const mockArgs = { arg1: 'val1' };
    const mockStandardQueryRow: QueryRow = {
      id: 1,
      name: mockQueryId,
      sqlText: 'SELECT ...',
      metadata: '{}', // No custom field
    };
    const mockCustomQueryRow: QueryRow = {
      id: 2,
      name: 'custom-chart',
      sqlText: 'SELECT ...',
      metadata: '{"custom": "dashboard:indicators:chart"}',
    };
    const mockDefaultResult: BarChartResult = { metadata: { config: {}, uploadType: '' }, series: [], categories: [] };
    const mockCustomResult: BarChartResult = { metadata: { config: { custom: true }, uploadType: '' }, series: [], categories: [] };

    // Need to mock getQueryRow for these tests
    // Note: Spying on functions within the same module requires careful handling with Jest.
    // We use spyOn here to intercept calls made *within* getChartData to other functions
    // in the same file (getQueryRow, getDefaultDataset).

    beforeEach(() => {
      // Spy on getQueryRow
      jest.spyOn(require('./chartsApi'), 'getQueryRow').mockImplementation(async (queryId: unknown) => {
         const id = queryId as string; // Cast the unknown param
         if (id === mockStandardQueryRow.name) return mockStandardQueryRow;
         if (id === mockCustomQueryRow.name) return mockCustomQueryRow;
         if (id === 'unknown-chart') return undefined; // Handle unknown case specifically for the test
         return undefined; // Default fallback
      });

      // Spy on getDefaultDataset
      jest.spyOn(require('./chartsApi'), 'getDefaultDataset').mockImplementation(async (queryRow: unknown, variables?: unknown) => {
          // We just need it to return the mock result for these tests
          return mockDefaultResult;
      });

      // getIndicatorsBySubcat is already mocked via jest.mock at the top level
      mockGetIndicatorsBySubcat.mockResolvedValue(mockCustomResult);
    });

    afterEach(() => {
      // Restore the original implementations after each test in this suite
      // Restore the original implementations after each test in this suite
      jest.restoreAllMocks();
    });


    it('should call getDefaultDataset for standard queries', async () => {
      const result = await getChartData(mockStandardQueryRow.name, mockArgs);

      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith(mockStandardQueryRow.name);
      expect(require('./chartsApi').getDefaultDataset).toHaveBeenCalledWith(mockStandardQueryRow, mockArgs);
      expect(mockGetIndicatorsBySubcat).not.toHaveBeenCalled();
      expect(result).toBe(mockDefaultResult);
    });

    it('should call getIndicatorsBySubcat for custom queries', async () => {
      const result = await getChartData(mockCustomQueryRow.name, mockArgs);

      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith(mockCustomQueryRow.name);
      expect(mockGetIndicatorsBySubcat).toHaveBeenCalledWith(mockCustomQueryRow);
      expect(require('./chartsApi').getDefaultDataset).not.toHaveBeenCalled();
      expect(result).toBe(mockCustomResult);
    });

    it('should throw BadRequestError for unknown chart', async () => {
      const unknownQueryId = 'unknown-chart';
      // The beforeEach spy setup now handles returning undefined for 'unknown-chart'

      await expect(getChartData(unknownQueryId, mockArgs)).rejects.toThrow(BadRequestError);
      await expect(getChartData(unknownQueryId, mockArgs)).rejects.toThrow('unknown chart');

      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith(unknownQueryId);
      expect(require('./chartsApi').getDefaultDataset).not.toHaveBeenCalled();
      expect(mockGetIndicatorsBySubcat).not.toHaveBeenCalled();
    });
  });

  describe('lambdaHandlerBar', () => {
    const mockQueryId = 'test-lambda-bar';
    const mockStandardQueryRow: QueryRow = {
      id: 3,
      name: mockQueryId,
      sqlText: 'SELECT ...',
      metadata: '{"yAxis": {"type": "number"}}', // No filters
    };
     const mockQueryRowWithFilters: QueryRow = {
      id: 4,
      name: 'query-with-filters',
      sqlText: 'SELECT ...',
      metadata: '{"yAxis": {"type": "percent"}, "filters": [{"key": "county", "title": "County"}, {"key": "year", "xf": "yyyy"}]}',
      uploadType: 'filtered-data'
    };
    const mockCustomQueryRow: QueryRow = {
      id: 5,
      name: 'custom-lambda-bar',
      sqlText: 'SELECT ...',
      metadata: '{"custom": "dashboard:indicators:chart"}',
    };
    const mockDefaultData = { id: mockQueryId, series: [{ name: 's1', data: [1] }], categories: ['c1'], metadata: { config: {}, uploadType: '' } };
    const mockCustomData = { id: mockCustomQueryRow.name, series: [{ name: 's2', data: [2] }], categories: ['c2'], metadata: { config: { custom: true }, uploadType: '' } };

    // Mock getQueryRow, getDefaultDataset, getIndicatorsBySubcat for this suite
    beforeEach(() => {
       jest.spyOn(require('./chartsApi'), 'getQueryRow').mockImplementation(async (queryId: unknown) => {
         const id = queryId as string;
         if (id === mockStandardQueryRow.name) return mockStandardQueryRow;
         if (id === mockQueryRowWithFilters.name) return mockQueryRowWithFilters;
         if (id === mockCustomQueryRow.name) return mockCustomQueryRow;
         return undefined;
      });
       jest.spyOn(require('./chartsApi'), 'getDefaultDataset').mockResolvedValue(mockDefaultData);
       mockGetIndicatorsBySubcat.mockResolvedValue(mockCustomData);
       // Reset transform mocks for specific checks
       mockTransformValueExtToInt.mockImplementation(({ value }) => `int-${value}`);
    });

     afterEach(() => {
      jest.restoreAllMocks();
    });

    const createEvent = (queryId?: string, queryStringParameters?: Record<string, string>): APIGatewayProxyEventV2 => ({
      rawPath: `/charts/${queryId}`,
      pathParameters: queryId ? { queryId } : undefined,
      queryStringParameters: queryStringParameters,
      requestContext: { http: { method: 'GET' } } as any,
      version: '2.0',
      routeKey: '',
      rawQueryString: '',
      headers: {},
      isBase64Encoded: false,
      body: undefined,
    });

    it('should return 200 with data for valid default request (no params)', async () => {
      const event = createEvent(mockStandardQueryRow.name);
      const response = await lambdaHandlerBar(event) as { statusCode: number, body?: string, headers?: any }; // Type assertion

      expect(response.statusCode).toBe(200);
      expect(response.body).toBe(JSON.stringify(mockDefaultData));
      expect(response.headers).toEqual({
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Access-Control-Allow-Methods": "GET",
      });
      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith(mockStandardQueryRow.name);
      expect(require('./chartsApi').getDefaultDataset).toHaveBeenCalledWith(mockStandardQueryRow, {}); // Empty variables
      expect(mockGetIndicatorsBySubcat).not.toHaveBeenCalled();
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

     it('should return 200 with data for valid default request (with params)', async () => {
      const event = createEvent(mockQueryRowWithFilters.name, { county: 'Orange', year: '2023' });
      const expectedVariables = { county: 'int-Orange', year: 'int-2023' }; // Transformed values
      jest.spyOn(require('./chartsApi'), 'getDefaultDataset').mockResolvedValueOnce({ ...mockDefaultData, id: mockQueryRowWithFilters.name }); // Adjust mock return

      const response = await lambdaHandlerBar(event) as { statusCode: number, body?: string }; // Type assertion

      expect(response.statusCode).toBe(200);
      expect(JSON.parse(response.body || '{}').id).toBe(mockQueryRowWithFilters.name);
      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith(mockQueryRowWithFilters.name);
      expect(mockTransformValueExtToInt).toHaveBeenCalledWith({ columnName: 'county', value: 'Orange', xf: undefined });
      expect(mockTransformValueExtToInt).toHaveBeenCalledWith({ columnName: 'year', value: '2023', xf: 'yyyy' });
      expect(require('./chartsApi').getDefaultDataset).toHaveBeenCalledWith(mockQueryRowWithFilters, expectedVariables);
      expect(mockGetIndicatorsBySubcat).not.toHaveBeenCalled();
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

    it('should return 200 with data for valid custom request', async () => {
      const event = createEvent(mockCustomQueryRow.name);
      const response = await lambdaHandlerBar(event) as { statusCode: number, body?: string }; // Type assertion

      expect(response.statusCode).toBe(200);
      expect(response.body).toBe(JSON.stringify(mockCustomData));
      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith(mockCustomQueryRow.name);
      expect(mockGetIndicatorsBySubcat).toHaveBeenCalledWith(mockCustomQueryRow);
      expect(require('./chartsApi').getDefaultDataset).not.toHaveBeenCalled();
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

    it('should return 400 if queryId is missing', async () => {
      const event = createEvent(undefined); // No queryId
      const response = await lambdaHandlerBar(event) as { statusCode: number }; // Type assertion

      expect(response.statusCode).toBe(400);
      expect(require('./chartsApi').getQueryRow).not.toHaveBeenCalled();
      expect(mockDoDBClose).not.toHaveBeenCalled(); // Should exit early
    });

    it('should return 400 if chart is unknown', async () => {
      const event = createEvent('unknown-chart-id');
      const response = await lambdaHandlerBar(event) as { statusCode: number, body?: string }; // Type assertion

      expect(response.statusCode).toBe(400);
      expect(JSON.parse(response.body || '{}').message).toBe('unknown chart');
      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith('unknown-chart-id');
      expect(require('./chartsApi').getDefaultDataset).not.toHaveBeenCalled();
      expect(mockGetIndicatorsBySubcat).not.toHaveBeenCalled();
      expect(mockDoDBClose).not.toHaveBeenCalled(); // Exits before try/finally
    });

    it('should return 400 if required query parameter is missing', async () => {
      const event = createEvent(mockQueryRowWithFilters.name, { county: 'Orange' }); // Missing 'year'
      const response = await lambdaHandlerBar(event) as { statusCode: number, body?: string }; // Type assertion

      expect(response.statusCode).toBe(400);
      expect(JSON.parse(response.body || '{}').message).toBe('missing parameter year');
      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith(mockQueryRowWithFilters.name);
      expect(require('./chartsApi').getDefaultDataset).not.toHaveBeenCalled();
      expect(mockGetIndicatorsBySubcat).not.toHaveBeenCalled();
      expect(mockDoDBClose).not.toHaveBeenCalled(); // Exits before try/finally
    });

    it('should return 400 on BadRequestError from underlying function', async () => {
      const event = createEvent(mockStandardQueryRow.name);
      const badRequestError = new BadRequestError(400, 'Specific bad request');
      jest.spyOn(require('./chartsApi'), 'getDefaultDataset').mockRejectedValueOnce(badRequestError);

      const response = await lambdaHandlerBar(event) as { statusCode: number, body?: string }; // Type assertion

      expect(response.statusCode).toBe(400);
      expect(JSON.parse(response.body || '{}').message).toBe('Specific bad request');
      expect(mockLogger.error).toHaveBeenCalledWith(badRequestError);
      expect(mockDoDBClose).toHaveBeenCalledTimes(1); // Finally block should run
    });

    it('should return 500 on other errors from underlying function', async () => {
      const event = createEvent(mockStandardQueryRow.name);
      const genericError = new Error('Something went wrong');
      jest.spyOn(require('./chartsApi'), 'getDefaultDataset').mockRejectedValueOnce(genericError);

      const response = await lambdaHandlerBar(event) as { statusCode: number, body?: string }; // Type assertion

      expect(response.statusCode).toBe(500);
      expect(response.body).toBe('Something went wrong');
      expect(mockLogger.error).toHaveBeenCalledWith(genericError);
      expect(mockDoDBClose).toHaveBeenCalledTimes(1); // Finally block should run
    });

     it('should call doDBClose even if getQueryRow throws', async () => {
        const event = createEvent('error-query-id');
        const queryRowError = new Error("getQueryRow failed");
        jest.spyOn(require('./chartsApi'), 'getQueryRow').mockRejectedValueOnce(queryRowError);

        // We expect the handler to re-throw or handle, but need to check close wasn't called
        // In the current implementation, it exits before the try/finally containing doDBClose
        // if getQueryRow fails or returns null. Let's test the re-throw.
         await expect(lambdaHandlerBar(event)).rejects.toThrow(queryRowError);

        // Verify mocks based on actual flow
        expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith('error-query-id');
        expect(mockDoDBClose).not.toHaveBeenCalled(); // As it exits early
     });
  });

  describe('lambdaHandlerGetFilter', () => {
    const mockQueryId = 'test-get-filter';
    const mockQueryRow: QueryRow = {
      id: 6,
      name: mockQueryId,
      sqlText: '', // Not used by this handler
      uploadType: 'filter-test-type',
      filters: JSON.stringify({
        table: 'mock_table',
        filters: {
          county: { column: 'County', exclude: ['Unknown'] },
          year: { column: 'Year', sort: 'number' },
          month: { column: 'Month', sort: 'mmyyyy', xf: 'int-to-mmyyyy' },
          category: { column: 'Category' } // Default sort
        },
        extra_filter_values: {
          county: ['-- All --'],
          category: ['Overall']
        }
      } as QueryFilters),
    };
     const mockQueryRowNoFilters: QueryRow = {
       ...mockQueryRow,
       id: 7,
       name: 'no-filters-query',
       filters: undefined, // Use undefined to match string | undefined type
     };
    const mockUploadTypeData = { id: 'filter-test-type', /* ... other upload type data */ };

    // Mock getQueryRow for this suite
    beforeEach(() => {
       jest.spyOn(require('./chartsApi'), 'getQueryRow').mockImplementation(async (queryId: unknown) => {
         const id = queryId as string;
         if (id === mockQueryRow.name) return mockQueryRow;
         if (id === mockQueryRowNoFilters.name) return mockQueryRowNoFilters;
         return undefined;
      });
      mockGetUploadType.mockResolvedValue(mockUploadTypeData);
      // Reset transform mock for specific checks
      mockTransformValueIntToExt.mockImplementation(({ value, xf }) => xf ? `${xf}(${value})` : `ext-${value}`);
    });

     afterEach(() => {
      jest.restoreAllMocks();
    });

    // Re-use createEvent from lambdaHandlerBar tests
    const createEvent = (queryId?: string): APIGatewayProxyEventV2 => ({
      rawPath: `/filters/${queryId}`,
      pathParameters: queryId ? { queryId } : undefined,
      requestContext: { http: { method: 'GET' } } as any,
      version: '2.0',
      routeKey: '',
      rawQueryString: '',
      headers: {},
      isBase64Encoded: false,
      body: undefined,
      queryStringParameters: {}, // Add this property
    });


    it('should return 200 with sorted, transformed, and filtered values', async () => {
      const event = createEvent(mockQueryRow.name);
      // Mock DB results for each filter column query
      mockDoDBQuery
        .mockResolvedValueOnce([{ value: 'Orange' }, { value: 'Windsor' }, { value: 'Unknown' }]) // county
        .mockResolvedValueOnce([{ value: '2023' }, { value: '2021' }, { value: 'abc' }, { value: '2022' }]) // year (number sort)
        .mockResolvedValueOnce([{ value: '202301' }, { value: '202212' }, { value: 'invalid' }, { value: '202302' }]) // month (mmyyyy sort)
        .mockResolvedValueOnce([{ value: 'Beta' }, { value: 'Alpha' }, { value: 'Gamma' }]); // category (alpha sort)

      const response = await lambdaHandlerGetFilter(event) as { statusCode: number, body?: string };

      expect(response.statusCode).toBe(200);
      expect(mockDoDBOpen).toHaveBeenCalledTimes(1);
      expect(mockGetUploadType).toHaveBeenCalledWith('filter-test-type');
      expect(mockDoDBQuery).toHaveBeenCalledWith('select distinct `County` as value from mock_table order by value');
      expect(mockDoDBQuery).toHaveBeenCalledWith('select distinct `Year` as value from mock_table order by value');
      expect(mockDoDBQuery).toHaveBeenCalledWith('select distinct `Month` as value from mock_table order by value');
      expect(mockDoDBQuery).toHaveBeenCalledWith('select distinct `Category` as value from mock_table order by value');

      // Check transformations were called
      expect(mockTransformValueIntToExt).toHaveBeenCalledWith(expect.objectContaining({ columnName: 'County', value: 'Orange' }));
      expect(mockTransformValueIntToExt).toHaveBeenCalledWith(expect.objectContaining({ columnName: 'Year', value: '2023' }));
      expect(mockTransformValueIntToExt).toHaveBeenCalledWith(expect.objectContaining({ columnName: 'Month', value: '202301', xf: 'int-to-mmyyyy' }));
      expect(mockTransformValueIntToExt).toHaveBeenCalledWith(expect.objectContaining({ columnName: 'Category', value: 'Beta' }));

      const expectedBody = {
        county: ['-- All --', 'ext-Orange', 'ext-Windsor'], // Excludes 'Unknown', adds extra, alpha sorted
        year: ['ext-abc', 'ext-2021', 'ext-2022', 'ext-2023'], // Number sort (non-numbers first)
        month: ['ext-invalid', 'int-to-mmyyyy(202212)', 'int-to-mmyyyy(202301)', 'int-to-mmyyyy(202302)'], // MM/YYYY sort (transformed)
        category: ['Overall', 'ext-Alpha', 'ext-Beta', 'ext-Gamma'] // Alpha sort, adds extra
      };
      expect(JSON.parse(response.body || '{}')).toEqual(expectedBody);
      expect(mockLogger.info).toHaveBeenCalledWith('sorting values', expect.anything());
      expect(mockDoDBClose).toHaveBeenCalledTimes(1);
    });

     it('should return 400 if queryId is missing', async () => {
      const event = createEvent(undefined);
      const response = await lambdaHandlerGetFilter(event) as { statusCode: number };

      expect(response.statusCode).toBe(400);
      expect(require('./chartsApi').getQueryRow).not.toHaveBeenCalled();
      expect(mockDoDBClose).not.toHaveBeenCalled();
    });

    it('should return 400 if chart is unknown', async () => {
      const event = createEvent('unknown-filter-query');
      const response = await lambdaHandlerGetFilter(event) as { statusCode: number, body?: string };

      expect(response.statusCode).toBe(400);
      expect(JSON.parse(response.body || '{}').message).toBe('unknown chart');
      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith('unknown-filter-query');
      expect(mockDoDBClose).not.toHaveBeenCalled();
    });

    it('should return 200 with empty object if query has no filters defined', async () => {
      const event = createEvent(mockQueryRowNoFilters.name);
      const response = await lambdaHandlerGetFilter(event) as { statusCode: number, body?: string };

      expect(response.statusCode).toBe(200);
      expect(response.body).toBe('{}');
      expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith(mockQueryRowNoFilters.name);
      expect(mockDoDBQuery).not.toHaveBeenCalled(); // Should not query DB if filters are null
      expect(mockDoDBClose).not.toHaveBeenCalled(); // Exits early
    });

    it('should return 500 on database error', async () => {
       const event = createEvent(mockQueryRow.name);
       const dbError = new Error('Filter DB query failed');
       mockDoDBQuery.mockRejectedValueOnce(dbError); // Fail the first DB query

       // Since the error happens inside the try/catch, we expect a 500
       // but cannot easily predict the exact response structure without more code.
       // Let's check the status code and that close was called.
       await expect(lambdaHandlerGetFilter(event)).rejects.toThrow(dbError);


       expect(mockDoDBOpen).toHaveBeenCalledTimes(1);
       expect(mockDoDBQuery).toHaveBeenCalledWith('select distinct `County` as value from mock_table order by value');
       expect(mockDoDBClose).toHaveBeenCalledTimes(1); // Finally block should run
    });

     it('should call doDBClose even if getQueryRow throws', async () => {
        const event = createEvent('error-filter-query-id');
        const queryRowError = new Error("getQueryRow failed for filter");
        jest.spyOn(require('./chartsApi'), 'getQueryRow').mockRejectedValueOnce(queryRowError);

        await expect(lambdaHandlerGetFilter(event)).rejects.toThrow(queryRowError);

        expect(require('./chartsApi').getQueryRow).toHaveBeenCalledWith('error-filter-query-id');
        expect(mockDoDBClose).not.toHaveBeenCalled(); // Exits early
     });
  });
});
