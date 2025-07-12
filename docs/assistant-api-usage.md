# OpenAI Assistants API Usage Guide

## Understanding Context Maintenance in Threads

The OpenAI Assistants API maintains context within a thread. When you send multiple messages in the same thread, the assistant remembers the conversation history and can respond appropriately to follow-up questions or requests to expand on previous responses.

## Issue: Missing Context in Responses

We identified an issue where when asking the assistant to expand a section of a previous response, only that expanded section was being returned without the rest of the original content.

### Root Cause

The OpenAI Assistants API was correctly maintaining context within the thread, but our application was only retrieving and displaying the latest message from the thread, not the cumulative conversation history.

## Solution: Retrieving Full Conversation History

We've updated the `ai-get-completion.ts` endpoint to support retrieving the full conversation history up to a specific message. This allows clients to display the entire conversation context, not just the latest response.

### How to Use the New Feature

When calling the completion endpoint, add the `includeHistory=true` query parameter:

```
GET /ai/completion/{id}/{sortKey}?includeHistory=true
```

#### Response Format

The response will include both the specific message requested and a `history` array containing all messages in the conversation up to and including the requested message:

```json
{
  "response": {
    "id": "conversation-id",
    "sortKey": 3,
    "status": "success",
    "query": "Expand the section on early childhood education",
    "message": "Here's the expanded section on early childhood education...",
    "created": "2025-07-12T13:45:00.000Z",
    "modified": "2025-07-12T13:45:10.000Z"
  },
  "history": [
    {
      "id": "conversation-id",
      "sortKey": 0,
      "status": "success",
      "query": "Tell me about Vermont's children",
      "message": "Vermont's children...",
      "created": "2025-07-12T13:40:00.000Z",
      "modified": "2025-07-12T13:40:10.000Z"
    },
    {
      "id": "conversation-id",
      "sortKey": 1,
      "status": "success",
      "query": "What about healthcare?",
      "message": "Healthcare for Vermont's children...",
      "created": "2025-07-12T13:42:00.000Z",
      "modified": "2025-07-12T13:42:10.000Z"
    },
    {
      "id": "conversation-id",
      "sortKey": 2,
      "status": "success",
      "query": "Tell me about education",
      "message": "Education in Vermont...",
      "created": "2025-07-12T13:44:00.000Z",
      "modified": "2025-07-12T13:44:10.000Z"
    },
    {
      "id": "conversation-id",
      "sortKey": 3,
      "status": "success",
      "query": "Expand the section on early childhood education",
      "message": "Here's the expanded section on early childhood education...",
      "created": "2025-07-12T13:45:00.000Z",
      "modified": "2025-07-12T13:45:10.000Z"
    }
  ]
}
```

### Client Implementation

Clients should:

1. Request the full history when displaying a conversation
2. Accumulate and display all messages in the conversation, not just the latest one
3. When displaying follow-up responses (like expanded sections), integrate them into the full context

## Example Code

See the example script in `examples/get-completion-with-history.js` for a demonstration of how to retrieve and display the full conversation history.