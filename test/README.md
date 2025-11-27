# Integration Tests

This directory contains integration tests for the VKD AI API.

## Integration Test Script

The `integration-test.ts` script provides comprehensive testing of the AI completion API including the new uploadKey functionality.

### Setup

1. Set environment variables for API keys:
   ```bash
   # Option 1: Use VKD_API_KEY as default for both environments
   export VKD_API_KEY="your-api-key"
   
   # Option 2: Set environment-specific keys (takes precedence over VKD_API_KEY)
   export VKD_QA_API_KEY="your-qa-api-key"
   export VKD_PROD_API_KEY="your-prod-api-key"
   ```

2. Ensure you have a test document in your S3 bucket at `test-documents/sample.pdf` for uploadKey testing.

### Usage

```bash
# Run all tests against QA environment
npm run test:integration

# Run all tests with debug output (shows API calls and responses)
npm run test:integration:debug

# Run all tests against production
npm run test:integration:prod

# Run specific uploadKey test
npm run test:integration:uploadkey

# Run uploadKey test with debug output
npm run test:integration:uploadkey:debug

# Direct TypeScript execution
npx ts-node test/integration-test.ts --env=qa
npx ts-node test/integration-test.ts --env=qa --test=uploadkey-completion
npx ts-node test/integration-test.ts --env=qa --debug

# Show help
npx ts-node test/integration-test.ts --help
```

### Available Tests

- **basic-completion**: Tests basic AI completion without file uploads
- **uploadkey-completion**: Tests the new uploadKey functionality
- **file-upload-completion**: Tests file upload completion (placeholder)
- **error-scenarios**: Tests various error conditions and validation

### Test Scenarios

#### Basic Completion
- Posts a simple text query
- Waits for completion
- Validates successful response

#### Upload Key Completion
- Posts a query with uploadKey parameter
- Tests the new functionality for referencing existing S3 files
- Validates that the document is processed correctly

#### Error Scenarios
- Invalid API key rejection
- Conflicting parameters (uploadKey + fileUrl)
- Missing required fields

### Debug Mode

The integration test includes comprehensive debug logging that shows:
- **API Requests**: Method, URL, headers, and request body
- **API Responses**: Status code, headers, and response body
- **Polling Details**: Status checks during completion waiting
- **Security**: API keys are masked in logs for security

Enable debug mode with:
```bash
npm run test:integration:debug
# or
npx ts-node test/integration-test.ts --env=qa --debug
```

**Example Debug Output:**
```
🔍 API Request: POST https://api-qa.vermontkidsdata.org/ai/completion
{
  "key": "09848734...",
  "id": "test-1700000000000-abc123",
  "sortKey": 0,
  "query": "What is the capital of Vermont?",
  "stream": false
}
🔍 API Response: 200 OK
{
  "message": "Processing request",
  "id": "test-1700000000000-abc123",
  "sortKey": 0
}
🔍 Polling attempt 1 for completion test-1700000000000-abc123/0
🔍 API Request: GET https://api-qa.vermontkidsdata.org/ai/completion/test-1700000000000-abc123/0
🔍 API Response: 200 OK
{
  "id": "test-1700000000000-abc123",
  "sortKey": 0,
  "status": "success",
  "message": "Montpelier is the capital of Vermont..."
}
```

### Adding New Tests

To add a new test scenario:

1. Add an entry to the `TEST_SCENARIOS` object:
   ```javascript
   'my-new-test': {
     name: 'My New Test',
     description: 'Description of what this test does',
     test: testMyNewFeature
   }
   ```

2. Implement the test function:
   ```javascript
   async function testMyNewFeature() {
     // Your test implementation
     const id = this.generateTestId();
     // ... test logic
     return { /* test results */ };
   }
   ```

### CI/CD Integration

The test script returns appropriate exit codes:
- `0`: All tests passed
- `1`: One or more tests failed

This makes it suitable for CI/CD pipelines:

```bash
# In your CI pipeline
npm run test:integration || exit 1
# or
npx ts-node test/integration-test.ts --env=qa || exit 1
```

### Output Format

The script provides detailed output including:
- Test progress with status updates
- Timing information
- Summary of results
- Detailed error messages for failures

Example output:
```
🚀 Starting VKD AI API Integration Tests
   Environment: qa
   Base URL: https://api-qa.vermontkidsdata.org

🧪 Running test: basic-completion
   Test basic AI completion without any file uploads
  Posting completion with ID: test-1700000000000-abc123
  Status: new
  Status: in_progress
  Status: success
✅ Test passed in 3456ms

📊 Test Summary:
   Total tests: 4
   Passed: 4
   Failed: 0
   Total duration: 12345ms

✅ All tests passed!