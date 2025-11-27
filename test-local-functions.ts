// Local test for our assistant functions
import { lambdaHandler as downloadHandler } from './src/ai-assistant-download';
import { lambdaHandler as uploadHandler } from './src/ai-assistant-upload';

async function testFunctions() {
  console.log('Testing assistant functions locally...');
  
  // Test download function with mock event
  const mockDownloadEvent = {
    pathParameters: { id: 'test-assistant-id' },
    queryStringParameters: { key: '09848734-8745-afrt-8745-8745873487' },
    headers: {},
    body: null,
    isBase64Encoded: false,
    requestContext: {} as any,
    httpMethod: 'GET',
    resource: '/ai/assistant/{id}/export',
    multiValueHeaders: {},
    multiValueQueryStringParameters: {},
    stageVariables: {},
    version: '2.0',
    routeKey: 'GET /ai/assistant/{id}/export'
  };

  try {
    console.log('Testing download function...');
    const downloadResult = await downloadHandler(mockDownloadEvent);
    console.log('Download function result:', downloadResult.statusCode);
    
    if (downloadResult.statusCode === 200) {
      console.log('✅ Download function works!');
    } else {
      console.log('⚠️ Download function returned:', downloadResult.statusCode, downloadResult.body);
    }
  } catch (error) {
    console.log('❌ Download function error:', error);
  }

  // Test upload function with mock event
  const mockUploadEvent = {
    pathParameters: {},
    queryStringParameters: { key: '09848734-8745-afrt-8745-8745873487' },
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      exportData: {
        assistant: {
          id: 'test-id',
          type: 'test-type',
          name: 'Test Assistant',
          definition: {},
          active: true
        },
        functions: [],
        documents: [],
        metadata: {
          exportedAt: new Date().toISOString(),
          exportedFrom: 'test',
          version: '1.0.0'
        }
      },
      options: {
        mode: 'create',
        dryRun: true,
        targetType: 'test-import-type'
      }
    }),
    isBase64Encoded: false,
    requestContext: {} as any,
    httpMethod: 'POST',
    resource: '/ai/assistant/import',
    multiValueHeaders: {},
    multiValueQueryStringParameters: {},
    stageVariables: {},
    version: '2.0',
    routeKey: 'POST /ai/assistant/import'
  };

  try {
    console.log('Testing upload function...');
    const uploadResult = await uploadHandler(mockUploadEvent);
    console.log('Upload function result:', uploadResult.statusCode);
    
    if (uploadResult.statusCode === 200) {
      console.log('✅ Upload function works!');
    } else {
      console.log('⚠️ Upload function returned:', uploadResult.statusCode, uploadResult.body);
    }
  } catch (error) {
    console.log('❌ Upload function error:', error);
  }
}

testFunctions().catch(console.error);