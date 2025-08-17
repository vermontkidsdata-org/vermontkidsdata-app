# AI API Reference

## Quick Reference

This is a condensed reference for all AI-related endpoints in the Vermont Kids Data API. For detailed integration guidance, see [ai-client-documentation.md](./ai-client-documentation.md).

## Base URL

```
https://api.vermontkidsdata.org
```

## Authentication

All endpoints require API key authentication via the `key` parameter in request bodies.

---

## User Endpoints

### Submit AI Query
```http
POST /ai/completion
Content-Type: application/json

{
  "key": "string",
  "id": "string",
  "sortKey": number,
  "query": "string",
  "stream": boolean,
  "type": "string",
  "sandbox": "string"
}
```

### Get AI Response
```http
GET /ai/completion/{id}/{sortKey}?includeHistory=boolean
```

### List Completions
```http
GET /ai/completions?reaction=string&comment=string&type=string&fields=string
```

---

## Administrative Endpoints

### Assistants

#### List Assistants
```http
GET /ai/assistants?includeInactive=boolean&type=string
```

#### Get Assistant
```http
GET /ai/assistant/{id}
```

#### Create Assistant
```http
POST /ai/assistant
Content-Type: application/json

{
  "key": "string",
  "type": "string",
  "name": "string",
  "definition": {
    "name": "string",
    "instructions": "string",
    "model": "string",
    "tools": []
  },
  "sandbox": "string"
}
```

#### Update Assistant
```http
PUT /ai/assistant/{id}
Content-Type: application/json

{
  "key": "string",
  "definition": {
    "name": "string",
    "instructions": "string",
    "model": "string",
    "tools": []
  }
}
```

#### Publish Assistant
```http
POST /ai/assistant/{id}/publish
Content-Type: application/json

{
  "key": "string"
}
```

### Assistant Functions

#### List Assistant Functions
```http
GET /ai/assistant/{id}/functions
```

#### Add Assistant Function
```http
POST /ai/assistant/{id}/function
Content-Type: application/json

{
  "key": "string",
  "name": "string",
  "description": "string",
  // Additional function parameters
}
```

### Documents

#### List Documents
```http
GET /ai/documents?includeInactive=boolean
```

---

## Response Formats

### Success Response
```json
{
  "statusCode": 200,
  "body": {
    // Response data
  }
}
```

### Error Response
```json
{
  "statusCode": 400|403|404|500,
  "body": {
    "message": "Error description",
    "error": "Detailed error message"
  }
}
```

---

## Status Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request |
| 403 | Forbidden (Invalid API Key) |
| 404 | Not Found |
| 500 | Internal Server Error |

---

## File Upload Support

The completion endpoint supports file uploads via multipart/form-data:

```javascript
const formData = new FormData();
formData.append('key', 'your-api-key');
formData.append('id', 'conversation-id');
formData.append('sortKey', '0');
formData.append('query', 'Analyze this file');
formData.append('file', fileInput.files[0]);

fetch('/ai/completion', {
  method: 'POST',
  body: formData
});
```

**Supported file types**: PDF, TXT, JSON, CSV

---

## Polling Pattern

For retrieving AI responses, implement polling:

```javascript
async function pollForResponse(id, sortKey, maxAttempts = 30) {
  for (let i = 0; i < maxAttempts; i++) {
    const response = await fetch(`/ai/completion/${id}/${sortKey}`);
    const data = await response.json();
    
    if (data.response.status === 'success') {
      return data;
    } else if (data.response.status === 'failed') {
      throw new Error('AI processing failed');
    }
    
    await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
  }
  throw new Error('Response timeout');
}
```

---

## Rate Limits

- **Query Submissions**: 10 per minute per API key
- **Status Checks**: 60 per minute per API key  
- **File Uploads**: 5 per minute per API key
- **Admin Operations**: 20 per minute per API key

---

## Examples

### Complete Conversation Flow

```javascript
// 1. Start conversation
const submitResponse = await fetch('/ai/completion', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    key: 'your-api-key',
    id: 'conv-12345',
    sortKey: 0,
    query: 'Tell me about Vermont education data'
  })
});

// 2. Poll for response
const result = await pollForResponse('conv-12345', 0);
console.log(result.response.message);

// 3. Continue conversation
const followUpResponse = await fetch('/ai/completion', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    key: 'your-api-key',
    id: 'conv-12345',
    sortKey: 1,
    query: 'Can you expand on early childhood programs?'
  })
});

// 4. Get response with full history
const fullHistory = await fetch('/ai/completion/conv-12345/1?includeHistory=true');
const historyData = await fullHistory.json();
console.log(historyData.history); // Array of all messages
```

### Assistant Management

```javascript
// List all assistants
const assistants = await fetch('/ai/assistants?key=your-api-key');

// Create new assistant
const newAssistant = await fetch('/ai/assistant', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    key: 'your-api-key',
    type: 'education-specialist',
    name: 'Education Data Specialist',
    definition: {
      name: 'Education Data Specialist',
      instructions: 'You are an expert in Vermont education data and policy...',
      model: 'gpt-4-turbo-preview',
      tools: []
    }
  })
});

// Publish assistant
const published = await fetch(`/ai/assistant/${assistantId}/publish`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ key: 'your-api-key' })
});
```