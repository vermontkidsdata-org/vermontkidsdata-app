# Upload Status API

## Overview

The upload status API allows you to check the current status of a file upload operation in the Vermont Kids Data system.

## Authentication

⚠️ **Authentication Required**: This API endpoint requires authentication via a VKD_AUTH cookie. You must be logged in to the Vermont Kids Data system to access this endpoint.

## Endpoint

**URL Pattern:** `GET /upload-status/{id}`

**Example invocation:**
```bash
# With authentication cookie
curl -H "Cookie: VKD_AUTH=your-session-token" "https://api.qa.vtkidsdata.org/upload-status/{your-upload-id}"
```

## Parameters

- **id** (required): The unique identifier for the upload you want to check the status of. This should be in the path parameter.

## Response Format

The API returns a JSON object with the following structure:

```json
{
  "status": "string",
  "numRecords": number,
  "percent": number,
  "errors": "string",
  "lastUpdated": "string"
}
```

## Example Usage

If you have an upload ID like `b9752e4c-cd99-472f-9b70-9f4a15b96a62`, you would call:

```bash
# For QA environment (with authentication)
curl -H "Cookie: VKD_AUTH=your-session-token" \
  "https://api.qa.vtkidsdata.org/upload-status/b9752e4c-cd99-472f-9b70-9f4a15b96a62"

# For production environment (with authentication)
curl -H "Cookie: VKD_AUTH=your-session-token" \
  "https://api.vtkidsdata.org/upload-status/b9752e4c-cd99-472f-9b70-9f4a15b96a62"
```

### Getting Authentication Token

To obtain the VKD_AUTH session token, you need to:
1. Log in to the Vermont Kids Data system through the web interface
2. Extract the VKD_AUTH cookie value from your browser's developer tools
3. Use that token in your API requests

Alternatively, you can use the OAuth callback endpoint to programmatically authenticate and obtain a session token.

## Response Fields

- **status**: Current status of the upload (e.g., "processing", "completed", "failed")
- **numRecords**: Number of records processed
- **percent**: Completion percentage (0-100)
- **errors**: Any error messages if the upload failed
- **lastUpdated**: Timestamp of the last status update

## Error Responses

- **400**: If uploadId is missing
- **401**: If authentication is missing or invalid (no VKD_AUTH cookie or expired session)
- **403**: If the user is not authorized to access the upload status
- **500**: If the upload record is not found in the database

### Authentication Error Example

If you call the API without proper authentication:
```bash
curl "https://api.qa.vtkidsdata.org/upload-status/b9752e4c-cd99-472f-9b70-9f4a15b96a62"
```

You will receive a `401 Unauthorized` or `403 Forbidden` response from the API Gateway authorizer.

## Implementation Details

The upload ID is typically returned when you initiate an upload operation, and you can use this API to poll for the current status of that upload. 

The implementation is in [`src/upload-get-status.ts`](../src/upload-get-status.ts) and uses the [`UploadStatus`](../src/db-utils.ts) DynamoDB table to retrieve status information.

## CORS Configuration

The API includes CORS headers to allow cross-origin requests:
- `Access-Control-Allow-Origin: *`
- `Access-Control-Allow-Methods: GET`
- `Content-Type: application/json`