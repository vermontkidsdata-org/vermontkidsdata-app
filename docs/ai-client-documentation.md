# AI Client API Documentation

## Overview

This document provides comprehensive documentation for the Vermont Kids Data AI Assistant API, designed to guide frontend developers in building a React client application. The API provides AI assistant functionality powered by OpenAI's Assistants API, supporting both end-user interactions and administrative management capabilities.

## Architecture

The AI system follows an asynchronous job-based processing model:

1. **Client submits request** → Receives job ID immediately
2. **Background processing** → AI response is processed and stored
3. **Client polls for results** → Retrieves completed response using job ID

This design ensures responsive user experience while handling potentially long-running AI operations.

## Table of Contents

1. [Authentication & Security](#authentication--security)
2. [User-Facing Endpoints](#user-facing-endpoints)
3. [Administrative Endpoints](#administrative-endpoints)
4. [Data Models](#data-models)
5. [Frontend Integration Guide](#frontend-integration-guide)
6. [Error Handling](#error-handling)
7. [Suggested Improvements](#suggested-improvements)

---

## Authentication & Security

### API Key Authentication

All AI endpoints require API key authentication through the `key` parameter in request bodies.

```json
{
  "key": "your-api-key",
  // ... other parameters
}
```

### Session-Based Authentication

For administrative functions, the system uses cookie-based session authentication with OAuth integration:

- **Cookie Name**: `VKD_AUTH`
- **Session Management**: Automatic TTL-based expiration
- **Authorization Context**: Includes access tokens and user domain

### Authorization Headers

For API requests, include the authorization in the request context. The authorizer validates sessions and provides user context to downstream lambdas.

---

## User-Facing Endpoints

These endpoints are designed for end-user interactions with AI assistants and should be integrated into the main user interface.

### 1. Submit AI Query

**Endpoint**: `POST /ai/completion`

Submit a query to an AI assistant and receive a job ID for tracking the response.

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `key` | string | Yes | API key for authentication |
| `id` | string | Yes | Unique conversation ID (generate using ULID for new conversations) |
| `sortKey` | number | Yes | Message sequence number (0 for first message in conversation) |
| `query` | string | Yes | User's question or prompt |
| `stream` | boolean | No | Enable streaming response (default: false) |
| `type` | string | No | Assistant type identifier (default: "vkd") |
| `sandbox` | string | No | Optional sandbox environment name |

#### Request Examples

**Basic Text Query**:
```json
POST /ai/completion
Content-Type: application/json

{
  "key": "your-api-key",
  "id": "01HXYZ123ABC",
  "sortKey": 0,
  "query": "What programs are available for early childhood education in Vermont?",
  "stream": false,
  "type": "vkd"
}
```

**File Upload with Query**:
```javascript
const formData = new FormData();
formData.append('key', 'your-api-key');
formData.append('id', '01HXYZ123ABC');
formData.append('sortKey', '1');
formData.append('query', 'Please analyze this document');
formData.append('file', fileInput.files[0]);

fetch('/ai/completion', {
  method: 'POST',
  body: formData
});
```

**File URL with Query**:
```json
{
  "key": "your-api-key",
  "id": "01HXYZ123ABC",
  "sortKey": 1,
  "query": "Please analyze this report",
  "fileurl": "https://example.com/report.pdf"
}
```

#### Response

```json
{
  "message": "Processing request",
  "id": "01HXYZ123ABC",
  "sortKey": 0,
  "uploadedFileMetadata": {
    "filename": "document.pdf",
    "mimeType": "application/pdf"
  }
}
```

### 2. Retrieve AI Response

**Endpoint**: `GET /ai/completion/{id}/{sortKey}`

Retrieve the AI assistant's response for a specific message.

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | string | Conversation ID |
| `sortKey` | number | Message sequence number |
| `includeHistory` | boolean (query) | Include full conversation history |

#### Request Examples

**Get Single Response**:
```
GET /ai/completion/01HXYZ123ABC/0
```

**Get Response with Full History**:
```
GET /ai/completion/01HXYZ123ABC/2?includeHistory=true
```

#### Response Examples

**Single Response**:
```json
{
  "response": {
    "id": "01HXYZ123ABC",
    "sortKey": 0,
    "status": "success",
    "query": "What programs are available for early childhood education in Vermont?",
    "message": "Vermont offers several early childhood education programs...",
    "title": "Early Childhood Education Programs",
    "created": "2024-01-15T10:30:00.000Z",
    "modified": "2024-01-15T10:32:15.000Z"
  }
}
```

**Response with History**:
```json
{
  "response": {
    "id": "01HXYZ123ABC",
    "sortKey": 2,
    "status": "success",
    "query": "Can you expand on the pre-K programs?",
    "message": "Vermont's Pre-K programs include...",
    "created": "2024-01-15T10:35:00.000Z",
    "modified": "2024-01-15T10:36:45.000Z"
  },
  "history": [
    {
      "id": "01HXYZ123ABC",
      "sortKey": 0,
      "status": "success",
      "query": "What programs are available for early childhood education in Vermont?",
      "message": "Vermont offers several early childhood education programs...",
      "created": "2024-01-15T10:30:00.000Z",
      "modified": "2024-01-15T10:32:15.000Z"
    },
    {
      "id": "01HXYZ123ABC",
      "sortKey": 1,
      "status": "success",
      "query": "What about funding options?",
      "message": "Funding for these programs comes from...",
      "created": "2024-01-15T10:33:00.000Z",
      "modified": "2024-01-15T10:34:30.000Z"
    },
    {
      "id": "01HXYZ123ABC",
      "sortKey": 2,
      "status": "success",
      "query": "Can you expand on the pre-K programs?",
      "message": "Vermont's Pre-K programs include...",
      "created": "2024-01-15T10:35:00.000Z",
      "modified": "2024-01-15T10:36:45.000Z"
    }
  ]
}
```

### 3. List User Completions

**Endpoint**: `GET /ai/completions`

Retrieve a list of AI completions with filtering options.

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `reaction` | string | Filter by user reaction (`+1`, `-1`, `heart`, etc.) |
| `comment` | string | Filter completions that have comments |
| `type` | string | Filter by assistant type |
| `fields` | string | Comma-separated list of fields to return |

**Note**: Only one filter (reaction, comment, or type) can be used per request.

#### Request Examples

```
GET /ai/completions?reaction=+1
GET /ai/completions?comment=true
GET /ai/completions?type=vkd&fields=id,query,message,created
```

#### Response

```json
{
  "completions": [
    {
      "id": "01HXYZ123ABC",
      "sortKey": { "min": 0, "max": 3 },
      "query": "What programs are available for early childhood education in Vermont?",
      "message": "Vermont offers several early childhood education programs...",
      "reaction": "+1",
      "created": "2024-01-15T10:30:00.000Z",
      "modified": "2024-01-15T10:36:45.000Z"
    }
  ]
}
```

---

## Administrative Endpoints

These endpoints are designed for administrative management of AI assistants and should be integrated into an admin dashboard or configuration interface.

### 1. List All Assistants

**Endpoint**: `GET /ai/assistants`

Retrieve a list of all available AI assistants.

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `includeInactive` | boolean | Include inactive assistants (default: false) |
| `type` | string | Filter by assistant type |

#### Request Examples

```
GET /ai/assistants
GET /ai/assistants?includeInactive=true
GET /ai/assistants?type=vkd
```

#### Response

```json
{
  "assistants": [
    {
      "id": "01ASSISTANT123",
      "type": "vkd",
      "name": "Vermont Kids Data Assistant",
      "definition": {
        "name": "VKD Assistant",
        "instructions": "You are an expert on Vermont children's data...",
        "model": "gpt-4-turbo-preview",
        "tools": []
      },
      "active": true,
      "created": "2024-01-10T15:00:00.000Z",
      "modified": "2024-01-15T09:00:00.000Z"
    }
  ]
}
```

### 2. Get Specific Assistant

**Endpoint**: `GET /ai/assistant/{id}`

Retrieve detailed information about a specific assistant.

#### Response

```json
{
  "assistant": {
    "id": "01ASSISTANT123",
    "type": "vkd",
    "name": "Vermont Kids Data Assistant",
    "definition": {
      "name": "VKD Assistant",
      "instructions": "You are an expert on Vermont children's data...",
      "model": "gpt-4-turbo-preview",
      "tools": []
    },
    "active": true,
    "created": "2024-01-10T15:00:00.000Z",
    "modified": "2024-01-15T09:00:00.000Z"
  }
}
```

### 3. Create New Assistant

**Endpoint**: `POST /ai/assistant`

Create a new AI assistant.

#### Request Body

```json
{
  "key": "your-api-key",
  "type": "custom-assistant",
  "name": "Custom Assistant Name",
  "definition": {
    "name": "Custom Assistant",
    "instructions": "Your custom instructions here...",
    "model": "gpt-4-turbo-preview",
    "tools": []
  },
  "sandbox": "development"
}
```

#### Response

```json
{
  "message": "Assistant created successfully",
  "assistant": {
    "id": "01NEWASSISTANT",
    "type": "custom-assistant",
    "name": "Custom Assistant Name",
    "definition": {
      "name": "Custom Assistant",
      "instructions": "Your custom instructions here...",
      "model": "gpt-4-turbo-preview",
      "tools": []
    },
    "active": true
  }
}
```

### 4. Update Assistant

**Endpoint**: `PUT /ai/assistant/{id}`

Update an existing assistant's definition.

#### Request Body

```json
{
  "key": "your-api-key",
  "definition": {
    "name": "Updated Assistant Name",
    "instructions": "Updated instructions...",
    "model": "gpt-4-turbo-preview",
    "tools": []
  }
}
```

### 5. Publish Assistant

**Endpoint**: `POST /ai/assistant/{id}/publish`

Publish an assistant to OpenAI for production use.

#### Response

```json
{
  "assistant": {
    "id": "asst_openai_id_here",
    "object": "assistant",
    "created_at": 1705123456,
    "name": "VKD Assistant <environment>",
    "description": null,
    "model": "gpt-4-turbo-preview",
    "instructions": "You are an expert on Vermont children's data...",
    "tools": []
  },
  "type": "vkd",
  "envName": "production"
}
```

---

## Data Models

### Completion Data Model

```typescript
interface CompletionData {
  id: string;                    // Conversation ID
  sortKey: number;               // Message sequence number
  status: 'new' | 'processing' | 'success' | 'failed';
  query: string;                 // User's input
  message?: string;              // AI response
  title?: string;                // Generated title
  type: string;                  // Assistant type
  envName: string;               // Environment name
  stream?: boolean;              // Streaming enabled
  created: string;               // ISO timestamp
  modified: string;              // ISO timestamp
  reaction?: string;             // User reaction
  comment?: string;              // User comment
  uploadedFileMetadata?: {
    filename: string;
    mimeType: string;
    encoding: string;
  };
}
```

### Assistant Data Model

```typescript
interface AssistantData {
  id: string;                    // Assistant ID
  type: string;                  // Assistant type
  name: string;                  // Display name
  definition: {
    name: string;
    instructions: string;
    model: string;
    tools: Tool[];
    modified: string;
  };
  active: boolean;               // Active status
  sandbox?: string;              // Sandbox environment
  created: string;               // ISO timestamp
  modified: string;              // ISO timestamp
}
```

### Response Status Values

- `new`: Request just submitted
- `processing`: AI is generating response
- `success`: Response completed successfully
- `failed`: Error occurred during processing

---

## Frontend Integration Guide

### Recommended React Client Architecture

#### 1. API Service Layer

Create a centralized API service to handle all AI interactions:

```typescript
// services/aiService.ts
import { ulid } from 'ulid';

export class AIService {
  private apiKey: string;
  private baseUrl: string;

  constructor(apiKey: string, baseUrl: string) {
    this.apiKey = apiKey;
    this.baseUrl = baseUrl;
  }

  async submitQuery(params: {
    conversationId?: string;
    query: string;
    file?: File;
    assistantType?: string;
  }) {
    const conversationId = params.conversationId || ulid();
    const sortKey = await this.getNextSortKey(conversationId);

    const formData = new FormData();
    formData.append('key', this.apiKey);
    formData.append('id', conversationId);
    formData.append('sortKey', sortKey.toString());
    formData.append('query', params.query);
    
    if (params.file) {
      formData.append('file', params.file);
    }
    
    if (params.assistantType) {
      formData.append('type', params.assistantType);
    }

    const response = await fetch(`${this.baseUrl}/ai/completion`, {
      method: 'POST',
      body: formData,
    });

    return response.json();
  }

  async getResponse(conversationId: string, sortKey: number, includeHistory = false) {
    const url = `${this.baseUrl}/ai/completion/${conversationId}/${sortKey}`;
    const params = includeHistory ? '?includeHistory=true' : '';
    
    const response = await fetch(url + params);
    return response.json();
  }

  async pollForResponse(conversationId: string, sortKey: number, maxAttempts = 30) {
    for (let attempt = 0; attempt < maxAttempts; attempt++) {
      const result = await this.getResponse(conversationId, sortKey);
      
      if (result.response.status === 'success') {
        return result;
      } else if (result.response.status === 'failed') {
        throw new Error('AI processing failed');
      }
      
      // Wait before next poll (exponential backoff)
      await new Promise(resolve => setTimeout(resolve, Math.min(1000 * (attempt + 1), 5000)));
    }
    
    throw new Error('Response timeout');
  }

  private async getNextSortKey(conversationId: string): Promise<number> {
    // Implementation to get the next sort key for a conversation
    // This could involve fetching the conversation history
    // For now, return 0 for new conversations
    return 0;
  }
}
```

#### 2. React Hooks for AI Interactions

```typescript
// hooks/useAI.ts
import { useState, useCallback } from 'react';
import { AIService } from '../services/aiService';

export const useAI = (aiService: AIService) => {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const submitQuery = useCallback(async (params: {
    conversationId?: string;
    query: string;
    file?: File;
    assistantType?: string;
  }) => {
    setIsLoading(true);
    setError(null);

    try {
      // Submit the query
      const submission = await aiService.submitQuery(params);
      
      // Poll for the response
      const result = await aiService.pollForResponse(
        submission.id, 
        submission.sortKey
      );
      
      setIsLoading(false);
      return result;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
      setIsLoading(false);
      throw err;
    }
  }, [aiService]);

  return {
    submitQuery,
    isLoading,
    error,
  };
};
```

#### 3. Conversation Management

```typescript
// hooks/useConversation.ts
import { useState, useCallback } from 'react';
import { AIService } from '../services/aiService';

interface Message {
  id: string;
  sortKey: number;
  query: string;
  message: string;
  created: string;
  role: 'user' | 'assistant';
}

export const useConversation = (aiService: AIService, conversationId: string) => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  const loadHistory = useCallback(async () => {
    if (!conversationId) return;

    try {
      // Get the latest message to determine conversation length
      const latestResponse = await aiService.getResponse(conversationId, 0, true);
      
      if (latestResponse.history) {
        const formattedMessages: Message[] = [];
        
        latestResponse.history.forEach((msg: any) => {
          // Add user message
          formattedMessages.push({
            id: msg.id,
            sortKey: msg.sortKey,
            query: msg.query,
            message: msg.query,
            created: msg.created,
            role: 'user'
          });
          
          // Add assistant response
          if (msg.message) {
            formattedMessages.push({
              id: msg.id,
              sortKey: msg.sortKey,
              query: msg.query,
              message: msg.message,
              created: msg.created,
              role: 'assistant'
            });
          }
        });
        
        setMessages(formattedMessages);
      }
    } catch (error) {
      console.error('Failed to load conversation history:', error);
    }
  }, [aiService, conversationId]);

  const sendMessage = useCallback(async (query: string, file?: File) => {
    setIsLoading(true);
    
    // Add user message to UI immediately
    const userMessage: Message = {
      id: conversationId,
      sortKey: messages.length,
      query,
      message: query,
      created: new Date().toISOString(),
      role: 'user'
    };
    
    setMessages(prev => [...prev, userMessage]);

    try {
      const result = await aiService.submitQuery({
        conversationId,
        query,
        file
      });
      
      const response = await aiService.pollForResponse(result.id, result.sortKey);
      
      // Add assistant response
      const assistantMessage: Message = {
        id: response.response.id,
        sortKey: response.response.sortKey,
        query: response.response.query,
        message: response.response.message,
        created: response.response.created,
        role: 'assistant'
      };
      
      setMessages(prev => [...prev, assistantMessage]);
    } catch (error) {
      console.error('Failed to send message:', error);
      // Handle error (e.g., show error message, remove user message, etc.)
    } finally {
      setIsLoading(false);
    }
  }, [aiService, conversationId, messages.length]);

  return {
    messages,
    isLoading,
    loadHistory,
    sendMessage
  };
};
```

### UI Component Examples

#### Chat Interface Component

```tsx
// components/ChatInterface.tsx
import React, { useState, useRef } from 'react';
import { useConversation } from '../hooks/useConversation';
import { AIService } from '../services/aiService';

interface ChatInterfaceProps {
  conversationId: string;
  aiService: AIService;
}

export const ChatInterface: React.FC<ChatInterfaceProps> = ({
  conversationId,
  aiService
}) => {
  const { messages, isLoading, sendMessage } = useConversation(aiService, conversationId);
  const [input, setInput] = useState('');
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() && !selectedFile) return;

    await sendMessage(input, selectedFile || undefined);
    setInput('');
    setSelectedFile(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  return (
    <div className="chat-interface">
      <div className="messages">
        {messages.map((message, index) => (
          <div key={index} className={`message ${message.role}`}>
            <div className="message-content">
              {message.message}
            </div>
            <div className="message-meta">
              {new Date(message.created).toLocaleString()}
            </div>
          </div>
        ))}
        {isLoading && (
          <div className="message assistant loading">
            <div className="typing-indicator">AI is thinking...</div>
          </div>
        )}
      </div>

      <form onSubmit={handleSubmit} className="message-form">
        <div className="input-group">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Ask a question..."
            disabled={isLoading}
          />
          <input
            ref={fileInputRef}
            type="file"
            onChange={(e) => setSelectedFile(e.target.files?.[0] || null)}
            accept=".pdf,.txt,.json,.csv"
            disabled={isLoading}
          />
          <button type="submit" disabled={isLoading || (!input.trim() && !selectedFile)}>
            Send
          </button>
        </div>
        {selectedFile && (
          <div className="selected-file">
            Selected: {selectedFile.name}
            <button type="button" onClick={() => setSelectedFile(null)}>×</button>
          </div>
        )}
      </form>
    </div>
  );
};
```

### State Management Recommendations

#### 1. Context for AI Service

```tsx
// contexts/AIContext.tsx
import React, { createContext, useContext } from 'react';
import { AIService } from '../services/aiService';

const AIContext = createContext<AIService | null>(null);

export const AIProvider: React.FC<{ 
  children: React.ReactNode;
  apiKey: string;
  baseUrl: string;
}> = ({ children, apiKey, baseUrl }) => {
  const aiService = new AIService(apiKey, baseUrl);

  return (
    <AIContext.Provider value={aiService}>
      {children}
    </AIContext.Provider>
  );
};

export const useAIService = () => {
  const service = useContext(AIContext);
  if (!service) {
    throw new Error('useAIService must be used within AIProvider');
  }
  return service;
};
```

#### 2. Global State for Conversations

Consider using Redux Toolkit or Zustand for managing multiple conversations:

```typescript
// store/aiStore.ts (Zustand example)
import { create } from 'zustand';

interface Conversation {
  id: string;
  title: string;
  lastActivity: string;
  messageCount: number;
}

interface AIStore {
  conversations: Conversation[];
  activeConversationId: string | null;
  setActiveConversation: (id: string) => void;
  addConversation: (conversation: Conversation) => void;
  updateConversation: (id: string, updates: Partial<Conversation>) => void;
}

export const useAIStore = create<AIStore>((set) => ({
  conversations: [],
  activeConversationId: null,
  setActiveConversation: (id) => set({ activeConversationId: id }),
  addConversation: (conversation) => 
    set((state) => ({ 
      conversations: [...state.conversations, conversation] 
    })),
  updateConversation: (id, updates) =>
    set((state) => ({
      conversations: state.conversations.map(conv =>
        conv.id === id ? { ...conv, ...updates } : conv
      )
    }))
}));
```

### Performance Optimization

#### 1. Response Caching

```typescript
// utils/responseCache.ts
class ResponseCache {
  private cache = new Map<string, any>();
  private ttl = 5 * 60 * 1000; // 5 minutes

  set(key: string, value: any) {
    this.cache.set(key, {
      value,
      timestamp: Date.now()
    });
  }

  get(key: string) {
    const item = this.cache.get(key);
    if (!item) return null;

    if (Date.now() - item.timestamp > this.ttl) {
      this.cache.delete(key);
      return null;
    }

    return item.value;
  }

  clear() {
    this.cache.clear();
  }
}

export const responseCache = new ResponseCache();
```

#### 2. Optimistic Updates

```typescript
// In your conversation hook, implement optimistic updates
const sendMessage = useCallback(async (query: string, file?: File) => {
  const optimisticMessage = {
    id: ulid(),
    role: 'assistant' as const,
    message: '',
    loading: true,
    created: new Date().toISOString()
  };

  // Add optimistic response immediately
  setMessages(prev => [...prev, userMessage, optimisticMessage]);

  try {
    const result = await aiService.submitQuery({ conversationId, query, file });
    const response = await aiService.pollForResponse(result.id, result.sortKey);
    
    // Replace optimistic message with real response
    setMessages(prev => 
      prev.map(msg => 
        msg.id === optimisticMessage.id 
          ? { ...response.response, role: 'assistant' as const }
          : msg
      )
    );
  } catch (error) {
    // Remove optimistic message on error
    setMessages(prev => prev.filter(msg => msg.id !== optimisticMessage.id));
    throw error;
  }
}, []);
```

---

## Error Handling

### HTTP Status Codes

| Status Code | Description | Common Causes |
|-------------|-------------|---------------|
| 400 | Bad Request | Missing required parameters, invalid sortKey, invalid field names |
| 403 | Forbidden | Invalid API key |
| 404 | Not Found | Conversation not found, assistant not found |
| 500 | Internal Server Error | OpenAI API errors, database issues, file upload failures |

### Error Response Format

```json
{
  "message": "Error description",
  "error": "Detailed error message",
  "id": "conversation-id-if-applicable",
  "envName": "environment-name-if-applicable"
}
```

### Frontend Error Handling

```typescript
// utils/errorHandling.ts
export class AIError extends Error {
  constructor(
    message: string,
    public statusCode?: number,
    public details?: any
  ) {
    super(message);
    this.name = 'AIError';
  }
}

export const handleAIError = (error: any): AIError => {
  if (error.statusCode) {
    switch (error.statusCode) {
      case 400:
        return new AIError('Invalid request. Please check your input.', 400, error);
      case 403:
        return new AIError('Authentication failed. Please check your API key.', 403, error);
      case 404:
        return new AIError('Resource not found.', 404, error);
      case 500:
        return new AIError('Server error. Please try again later.', 500, error);
      default:
        return new AIError('An unexpected error occurred.', error.statusCode, error);
    }
  }
  
  return new AIError('Network error. Please check your connection.', undefined, error);
};
```

### Retry Logic

```typescript
// utils/retry.ts
export const withRetry = async <T>(
  fn: () => Promise<T>,
  maxRetries = 3,
  backoffMs = 1000
): Promise<T> => {
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxRetries) {
        throw error;
      }
      
      // Only retry on certain error types
      if (error instanceof AIError && [500, 502, 503, 504].includes(error.statusCode || 0)) {
        await new Promise(resolve => setTimeout(resolve, backoffMs * (attempt + 1)));
        continue;
      }
      
      throw error;
    }
  }
  
  throw new Error('Retry logic failed unexpectedly');
};
```

---

## Suggested Improvements

### Additional Endpoints for Enhanced Functionality

#### 1. Conversation Management

```typescript
// Suggested new endpoints:

// GET /ai/conversations
// List all conversations for the current user
interface ConversationSummary {
  id: string;
  title: string;
  lastMessage: string;
  messageCount: number;
  created: string;
  modified: string;
}

// DELETE /ai/conversation/{id}
// Delete a conversation and all its messages

// PUT /ai/conversation/{id}/title
// Update conversation title
{
  "title": "Custom conversation title"
}

// POST /ai/conversation/{id}/export
// Export conversation as various formats (PDF, JSON, etc.)
{
  "format": "pdf" | "json" | "txt"
}
```

#### 2. User Feedback and Analytics

```typescript
// PUT /ai/completion/{id}/{sortKey}/reaction
// Add or update user reaction
{
  "reaction": "+1" | "-1" | "heart" | "helpful" | "not_helpful"
}

// POST /ai/completion/{id}/{sortKey}/comment
// Add user comment/feedback
{
  "comment": "This response was very helpful for my research."
}

// GET /ai/analytics/usage
// Get usage analytics for the current user
interface UsageAnalytics {
  totalQueries: number;
  queriesThisMonth: number;
  averageResponseTime: number;
  mostUsedAssistantType: string;
  topTopics: string[];
}
```

#### 3. Real-time Features

```typescript
// WebSocket endpoint for real-time streaming
// ws://api/ai/stream/{conversationId}/{sortKey}
// Stream AI responses in real-time as they're generated

// Server-Sent Events for status updates
// GET /ai/completion/{id}/{sortKey}/stream
// Stream status updates and partial responses
```

#### 4. Enhanced File Management

```typescript
// GET /ai/files
// List uploaded files for the current user
interface FileInfo {
  id: string;
  filename: string;
  size: number;
  mimeType: string;
  uploaded: string;
  usedInConversations: string[];
}

// DELETE /ai/file/{fileId}
// Delete an uploaded file

// POST /ai/file/{fileId}/reuse
// Reuse an existing file in a new conversation
{
  "conversationId": "01HXYZ123ABC",
  "query": "Please analyze this file again with focus on..."
}
```

#### 5. Assistant Discovery and Recommendations

```typescript
// GET /ai/assistants/recommended
// Get recommended assistants based on user history
interface AssistantRecommendation {
  assistant: AssistantData;
  reason: string;
  confidenceScore: number;
}

// GET /ai/assistants/search
// Search assistants by capabilities
{
  "query": "data analysis",
  "capabilities": ["file_upload", "charts", "statistics"]
}
```

### Frontend Architecture Improvements

#### 1. Progressive Web App Features

- **Offline Support**: Cache recent conversations for offline viewing
- **Push Notifications**: Notify users when long-running AI operations complete
- **App Installation**: Allow users to install the React app as a PWA

#### 2. Accessibility Enhancements

- **Screen Reader Support**: Proper ARIA labels for chat interfaces
- **Keyboard Navigation**: Full keyboard support for all interactions
- **High Contrast Mode**: Support for users with visual impairments
- **Voice Input**: Integration with Web Speech API for voice queries

#### 3. Advanced UI Features

```typescript
// Suggested React components:

// MessageComponent with rich formatting
interface MessageComponentProps {
  message: string;
  supportMarkdown?: boolean;
  supportCodeHighlighting?: boolean;
  supportMath?: boolean; // LaTeX rendering
}

// FilePreviewComponent
interface FilePreviewProps {
  file: File;
  onRemove: () => void;
  showThumbnail?: boolean;
}

// ConversationSearchComponent
interface ConversationSearchProps {
  onSearch: (query: string) => void;
  onFilter: (filters: ConversationFilters) => void;
}

// AIAssistantSelectorComponent
interface AssistantSelectorProps {
  assistants: AssistantData[];
  selectedAssistant: string;
  onSelect: (assistantId: string) => void;
}
```

#### 4. Performance Optimizations

- **Virtual Scrolling**: For conversations with many messages
- **Image/File Lazy Loading**: Load file previews on demand
- **Response Streaming**: Display AI responses as they're generated
- **Smart Caching**: Cache conversation data and AI responses intelligently

#### 5. Integration Features

```typescript
// Integration with external services:

// Calendar integration
interface CalendarEvent {
  title: string;
  description: string;
  date: string;
  source: 'ai_recommendation';
}

// Email sharing
interface EmailShare {
  recipient: string;
  subject: string;
  conversationId: string;
  includeHistory: boolean;
}

// Social sharing
interface SocialShare {
  platform: 'twitter' | 'linkedin' | 'facebook';
  content: string;
  conversationId: string;
}
```

### Security Enhancements

#### 1. Enhanced Authentication

```typescript
// Multi-factor authentication
interface MFAConfig {
  method: 'totp' | 'sms' | 'email';
  enabled: boolean;
}

// Session management
interface SessionInfo {
  id: string;
  device: string;
  location: string;
  lastActivity: string;
  active: boolean;
}
```

#### 2. Data Privacy Features

```typescript
// Data retention controls
interface DataRetentionSettings {
  conversationRetentionDays: number;
  fileRetentionDays: number;
  autoDeleteEnabled: boolean;
}

// Privacy controls
interface PrivacySettings {
  shareDataForImprovement: boolean;
  allowAnalytics: boolean;
  exportDataOnDemand: boolean;
}
```

### Scalability Considerations

#### 1. Rate Limiting and Quotas

```typescript
// User quota management
interface UserQuota {
  dailyQueries: number;
  dailyQueryLimit: number;
  monthlyQueries: number;
  monthlyQueryLimit: number;
  fileUploadQuota: number; // in MB
  concurrentRequests: number;
}

// Rate limiting headers
interface RateLimitHeaders {
  'X-RateLimit-Limit': string;
  'X-RateLimit-Remaining': string;
  'X-RateLimit-Reset': string;
}
```

#### 2. Monitoring and Observability

```typescript
// Health check endpoints
// GET /health
interface HealthStatus {
  status: 'healthy' | 'degraded' | 'unhealthy';
  version: string;
  uptime: number;
  dependencies: {
    openai: 'healthy' | 'unhealthy';
    database: 'healthy' | 'unhealthy';
    s3: 'healthy' | 'unhealthy';
  };
}

// Metrics endpoint
// GET /metrics
interface Metrics {
  totalRequests: number;
  averageResponseTime: number;
  errorRate: number;
  activeUsers: number;
}
```

### TODO Items for Development Team

#### High Priority
1. **Implement conversation history API** - Add endpoints for managing conversation metadata
2. **Add user feedback system** - Allow users to rate and comment on AI responses
3. **Enhance error handling** - Implement proper error codes and user-friendly messages
4. **Add file management** - Build endpoints for file listing, deletion, and reuse
5. **Implement rate limiting** - Protect the API from abuse and manage usage quotas

#### Medium Priority
1. **WebSocket streaming** - Real-time response streaming for better UX
2. **Search functionality** - Allow users to search through their conversation history
3. **Assistant recommendations** - Suggest appropriate assistants based on query content
4. **Export capabilities** - Allow users to export conversations in various formats
5. **Offline support** - Cache responses for offline viewing

#### Low Priority
1. **Advanced analytics** - Usage patterns, popular queries, response quality metrics
2. **Integration APIs** - Calendar, email, and social media sharing
3. **Voice interface** - Voice input and text-to-speech output
4. **Mobile optimization** - PWA features and mobile-specific optimizations
5. **Admin dashboard** - Enhanced tools for assistant management and user analytics

---

## Conclusion

This API provides a robust foundation for building a React frontend that can effectively utilize AI assistant capabilities. The asynchronous job-based processing model ensures scalability, while the comprehensive endpoint coverage supports both end-user interactions and administrative management.

Key recommendations for the frontend implementation:

1. **Use the conversation history feature** extensively to provide context-aware interactions
2. **Implement proper error handling and retry logic** for a robust user experience
3. **Cache responses appropriately** to improve performance and reduce API calls
4. **Design with accessibility in mind** from the beginning
5. **Plan for offline functionality** to enhance user experience
6. **Implement proper state management** for multiple conversations and assistant types

The suggested improvements and additional endpoints would significantly enhance the platform's capabilities and user experience. Prioritize implementation based on user needs and business requirements.

For questions or clarifications about any of these endpoints or integration patterns, please refer to the existing codebase in the `src/` directory, particularly the `ai-*.ts` files, which contain the actual implementation details.