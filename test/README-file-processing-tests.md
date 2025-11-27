# File Processing Tests Documentation

## Overview

This document describes the comprehensive file processing tests that have been added to the integration test suite to ensure robust regression testing for post-completion scenarios involving file uploads and processing.

## Test Coverage

The file processing tests cover the following scenarios:

### 1. Multiple File Types (`multiple-file-types`)
**Purpose**: Test AI completion with different file formats
**Files Tested**:
- `sample.txt` - Plain text file with various content types
- `sample.csv` - Structured data file with user information
- `sample.json` - JSON configuration file with nested objects

**What it tests**:
- File upload handling for different MIME types
- Content processing for structured vs unstructured data
- AI's ability to understand and analyze different file formats
- Response quality validation for each file type

### 2. Large File Upload (`large-file-upload`)
**Purpose**: Test system behavior with larger files
**File**: `large-file.txt` (contains Lorem ipsum text, ~3KB)

**What it tests**:
- S3 upload performance with larger files
- OpenAI file processing limits
- Timeout handling (uses 2-minute timeout)
- Memory usage during file processing
- Response quality with larger content volumes

### 3. File URL Processing (`file-url-processing`)
**Purpose**: Test file processing from external URLs
**Test URL**: GitHub README file (publicly accessible)

**What it tests**:
- HTTP/HTTPS file fetching
- URL validation and error handling
- Remote file download and processing
- Network timeout handling
- Content processing from external sources

### 4. File Retrieval with Links (`file-retrieval-with-links`)
**Purpose**: Test completion retrieval with file download links
**File**: `sample.txt`

**What it tests**:
- Presigned URL generation for file downloads
- File metadata preservation and retrieval
- API response structure with file information
- File link expiration handling
- Metadata accuracy (filename, MIME type, etc.)

### 5. Streaming with Files (`streaming-with-files`)
**Purpose**: Test streaming completions with file uploads
**File**: `sample.json`

**What it tests**:
- Streaming response generation with file context
- Real-time processing of file content
- Streaming performance with file attachments
- Status updates during streaming
- Message assembly from streaming chunks

### 6. File Error Handling (`file-error-handling`)
**Purpose**: Test various error scenarios in file processing

**Error Scenarios Tested**:
- **Non-existent File URL**: Tests handling of 404 errors from external URLs
- **Invalid File Type**: Tests processing of binary/unsupported files
- **Conflicting File Sources**: Tests validation when both file upload and URL are provided

**What it tests**:
- Error response codes and messages
- Graceful degradation for unsupported files
- Input validation for conflicting parameters
- Error recovery mechanisms
- User-friendly error reporting

## Test Files Structure

```
test/fixtures/test-files/
├── sample.txt          # Basic text file with various content
├── sample.csv          # Structured data file
├── sample.json         # JSON configuration file
├── large-file.txt      # Large text file for performance testing
└── invalid-file.bin    # Binary file for error testing
```

## Running the Tests

### Run All File Processing Tests
```bash
npx ts-node test/integration-test.ts --env=qa
```

### Run Specific File Processing Test
```bash
npx ts-node test/integration-test.ts --env=qa --test-type=multiple-file-types
npx ts-node test/integration-test.ts --env=qa --test-type=large-file-upload
npx ts-node test/integration-test.ts --env=qa --test-type=file-url-processing
npx ts-node test/integration-test.ts --env=qa --test-type=file-retrieval-with-links
npx ts-node test/integration-test.ts --env=qa --test-type=streaming-with-files
npx ts-node test/integration-test.ts --env=qa --test-type=file-error-handling
```

### Run with Debug Mode
```bash
npx ts-node test/integration-test.ts --env=qa --test-type=multiple-file-types --debug
```

## Expected Results

### Success Criteria
- All file uploads complete successfully (HTTP 200)
- Completions reach 'success' status
- Response messages meet minimum length requirements
- File metadata is preserved and retrievable
- Presigned URLs are generated for file downloads
- Error scenarios are handled gracefully

### Performance Expectations
- Standard files (< 1KB): Complete within 30 seconds
- Large files (> 1KB): Complete within 2 minutes
- URL processing: Complete within 45 seconds
- Streaming responses: Begin within 10 seconds

## Integration with Existing Tests

The file processing tests integrate seamlessly with the existing test framework:

- Use the same `IntegrationTester` class and helper methods
- Follow the same test result reporting format
- Support the same command-line options (env, debug, etc.)
- Maintain consistent error handling and logging

## Regression Testing Benefits

These tests provide comprehensive regression testing for:

1. **File Upload Pipeline**: From multipart form parsing to S3 storage
2. **OpenAI Integration**: File upload to OpenAI and processing
3. **Content Processing**: AI analysis of different file types
4. **API Response Structure**: Consistent response formats with file data
5. **Error Handling**: Graceful handling of various failure scenarios
6. **Performance**: System behavior under different file sizes and types

## Maintenance

### Adding New File Types
1. Create test file in `test/fixtures/test-files/`
2. Add entry to `fileTypes` array in `testMultipleFileTypes`
3. Update this documentation

### Updating Test URLs
- Ensure URLs remain publicly accessible
- Use stable, long-term URLs (e.g., GitHub raw files)
- Test URL accessibility before committing changes

### Monitoring Test Health
- Review test results regularly for performance degradation
- Update timeout values if system performance changes
- Monitor external URL availability for URL processing tests

## Troubleshooting

### Common Issues
1. **File Not Found**: Ensure test fixtures exist in correct locations
2. **Network Timeouts**: Check internet connectivity for URL tests
3. **API Key Issues**: Verify environment variables are set correctly
4. **S3 Permissions**: Ensure proper AWS credentials and bucket access

### Debug Tips
- Use `--debug` flag to see detailed API requests/responses
- Check file sizes and formats if uploads fail
- Verify network connectivity for URL-based tests
- Review AWS CloudWatch logs for backend errors