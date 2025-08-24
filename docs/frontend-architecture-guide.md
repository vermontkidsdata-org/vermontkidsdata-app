# Frontend Architecture Guide for AI Client

## Overview

This guide provides specific architectural recommendations for building a scalable and efficient React frontend for the Vermont Kids Data AI Assistant API.

## Recommended Technology Stack

### Core Technologies
- **React 18+** with Concurrent Features
- **TypeScript** for type safety
- **React Router v6** for navigation
- **React Query (TanStack Query)** for server state management
- **Zustand** or **Redux Toolkit** for client state
- **Tailwind CSS** for styling
- **Vite** for build tooling

### Additional Libraries
- **React Hook Form** for form management
- **Zod** for schema validation
- **Axios** for HTTP client
- **React Markdown** for rendering AI responses
- **Framer Motion** for animations
- **React Dropzone** for file uploads

## Project Structure

```
src/
├── components/
│   ├── ui/                    # Reusable UI components
│   ├── chat/                  # Chat-specific components
│   ├── admin/                 # Admin interface components
│   └── layout/                # Layout components
├── hooks/                     # Custom React hooks
├── services/                  # API services and utilities
├── stores/                    # State management
├── types/                     # TypeScript type definitions
├── utils/                     # Utility functions
├── pages/                     # Page components
└── constants/                 # Application constants
```

## Core Architecture Patterns

### 1. Service Layer Pattern

Create a dedicated service layer for all API interactions:

```typescript
// services/api/types.ts
export interface ApiConfig {
  baseUrl: string;
  apiKey: string;
  timeout?: number;
}

export interface ApiResponse<T = any> {
  data: T;
  status: number;
  statusText: string;
}

// services/api/client.ts
import axios, { AxiosInstance } from 'axios';
import { ApiConfig, ApiResponse } from './types';

export class ApiClient {
  private client: AxiosInstance;

  constructor(config: ApiConfig) {
    this.client = axios.create({
      baseURL: config.baseUrl,
      timeout: config.timeout || 30000,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    // Request interceptor to add API key
    this.client.interceptors.request.use((config) => {
      if (config.data && typeof config.data === 'object') {
        config.data.key = config.data.key || config.apiKey;
      }
      return config;
    });

    // Response interceptor for error handling
    this.client.interceptors.response.use(
      (response) => response,
      (error) => {
        console.error('API Error:', error);
        return Promise.reject(error);
      }
    );
  }

  async get<T>(url: string, params?: any): Promise<ApiResponse<T>> {
    const response = await this.client.get(url, { params });
    return response;
  }

  async post<T>(url: string, data?: any): Promise<ApiResponse<T>> {
    const response = await this.client.post(url, data);
    return response;
  }

  async put<T>(url: string, data?: any): Promise<ApiResponse<T>> {
    const response = await this.client.put(url, data);
    return response;
  }

  async delete<T>(url: string): Promise<ApiResponse<T>> {
    const response = await this.client.delete(url);
    return response;
  }

  async postFormData<T>(url: string, formData: FormData): Promise<ApiResponse<T>> {
    const response = await this.client.post(url, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return response;
  }
}

// services/api/aiService.ts
import { ApiClient } from './client';
import { 
  CompletionRequest, 
  CompletionResponse, 
  AssistantData,
  ConversationHistory 
} from '../../types/ai';

export class AIService {
  constructor(private apiClient: ApiClient) {}

  async submitCompletion(request: CompletionRequest): Promise<CompletionResponse> {
    if (request.file) {
      const formData = new FormData();
      formData.append('id', request.id);
      formData.append('sortKey', request.sortKey.toString());
      formData.append('query', request.query);
      formData.append('file', request.file);
      
      if (request.type) formData.append('type', request.type);
      if (request.sandbox) formData.append('sandbox', request.sandbox);

      const response = await this.apiClient.postFormData<CompletionResponse>(
        '/ai/completion',
        formData
      );
      return response.data;
    } else {
      const response = await this.apiClient.post<CompletionResponse>(
        '/ai/completion',
        request
      );
      return response.data;
    }
  }

  async getCompletion(
    id: string, 
    sortKey: number, 
    includeHistory = false
  ): Promise<ConversationHistory> {
    const params = includeHistory ? { includeHistory: 'true' } : {};
    const response = await this.apiClient.get<ConversationHistory>(
      `/ai/completion/${id}/${sortKey}`,
      params
    );
    return response.data;
  }

  async listAssistants(includeInactive = false): Promise<AssistantData[]> {
    const params = includeInactive ? { includeInactive: 'true' } : {};
    const response = await this.apiClient.get<{ assistants: AssistantData[] }>(
      '/ai/assistants',
      params
    );
    return response.data.assistants;
  }

  // Additional service methods...
}
```

### 2. React Query Integration

Use React Query for server state management:

```typescript
// hooks/queries/useAI.ts
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { AIService } from '../../services/api/aiService';
import { CompletionRequest } from '../../types/ai';

export const useSubmitCompletion = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (request: CompletionRequest) => {
      return aiService.submitCompletion(request);
    },
    onSuccess: (data) => {
      // Invalidate and refetch completion data
      queryClient.invalidateQueries({
        queryKey: ['completion', data.id, data.sortKey],
      });
    },
  });
};

export const useCompletion = (
  id: string, 
  sortKey: number, 
  includeHistory = false,
  options?: { enabled?: boolean; refetchInterval?: number }
) => {
  return useQuery({
    queryKey: ['completion', id, sortKey, includeHistory],
    queryFn: () => aiService.getCompletion(id, sortKey, includeHistory),
    enabled: options?.enabled !== false,
    refetchInterval: options?.refetchInterval,
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

export const usePollingCompletion = (id: string, sortKey: number) => {
  return useQuery({
    queryKey: ['completion', id, sortKey],
    queryFn: () => aiService.getCompletion(id, sortKey),
    refetchInterval: (data) => {
      // Stop polling when completion is successful or failed
      if (data?.response?.status === 'success' || data?.response?.status === 'failed') {
        return false;
      }
      return 2000; // Poll every 2 seconds
    },
    refetchIntervalInBackground: false,
  });
};

export const useAssistants = (includeInactive = false) => {
  return useQuery({
    queryKey: ['assistants', includeInactive],
    queryFn: () => aiService.listAssistants(includeInactive),
    staleTime: 10 * 60 * 1000, // 10 minutes
  });
};
```

### 3. State Management with Zustand

```typescript
// stores/conversationStore.ts
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';

interface Message {
  id: string;
  sortKey: number;
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
  status?: 'sending' | 'sent' | 'delivered' | 'failed';
  file?: File;
}

interface Conversation {
  id: string;
  title: string;
  messages: Message[];
  assistantType: string;
  lastActivity: string;
  isActive: boolean;
}

interface ConversationStore {
  conversations: Record<string, Conversation>;
  activeConversationId: string | null;
  
  // Actions
  createConversation: (conversation: Omit<Conversation, 'messages'>) => void;
  setActiveConversation: (id: string | null) => void;
  addMessage: (conversationId: string, message: Message) => void;
  updateMessage: (conversationId: string, messageId: string, updates: Partial<Message>) => void;
  updateConversationTitle: (conversationId: string, title: string) => void;
  deleteConversation: (conversationId: string) => void;
  clearAllConversations: () => void;
  
  // Selectors
  getActiveConversation: () => Conversation | null;
  getConversation: (id: string) => Conversation | null;
  getConversationList: () => Conversation[];
}

export const useConversationStore = create<ConversationStore>()(
  devtools(
    persist(
      immer((set, get) => ({
        conversations: {},
        activeConversationId: null,

        createConversation: (conversation) =>
          set((state) => {
            state.conversations[conversation.id] = {
              ...conversation,
              messages: [],
            };
            state.activeConversationId = conversation.id;
          }),

        setActiveConversation: (id) =>
          set((state) => {
            state.activeConversationId = id;
          }),

        addMessage: (conversationId, message) =>
          set((state) => {
            if (state.conversations[conversationId]) {
              state.conversations[conversationId].messages.push(message);
              state.conversations[conversationId].lastActivity = message.timestamp;
            }
          }),

        updateMessage: (conversationId, messageId, updates) =>
          set((state) => {
            const conversation = state.conversations[conversationId];
            if (conversation) {
              const messageIndex = conversation.messages.findIndex(
                (msg) => msg.id === messageId
              );
              if (messageIndex !== -1) {
                Object.assign(conversation.messages[messageIndex], updates);
              }
            }
          }),

        updateConversationTitle: (conversationId, title) =>
          set((state) => {
            if (state.conversations[conversationId]) {
              state.conversations[conversationId].title = title;
            }
          }),

        deleteConversation: (conversationId) =>
          set((state) => {
            delete state.conversations[conversationId];
            if (state.activeConversationId === conversationId) {
              state.activeConversationId = null;
            }
          }),

        clearAllConversations: () =>
          set((state) => {
            state.conversations = {};
            state.activeConversationId = null;
          }),

        // Selectors
        getActiveConversation: () => {
          const state = get();
          return state.activeConversationId
            ? state.conversations[state.activeConversationId] || null
            : null;
        },

        getConversation: (id) => {
          const state = get();
          return state.conversations[id] || null;
        },

        getConversationList: () => {
          const state = get();
          return Object.values(state.conversations).sort(
            (a, b) => new Date(b.lastActivity).getTime() - new Date(a.lastActivity).getTime()
          );
        },
      })),
      {
        name: 'conversation-store',
        partialize: (state) => ({
          conversations: state.conversations,
          activeConversationId: state.activeConversationId,
        }),
      }
    ),
    { name: 'ConversationStore' }
  )
);
```

### 4. Custom Hooks for AI Interactions

```typescript
// hooks/useConversation.ts
import { useCallback, useEffect, useMemo } from 'react';
import { ulid } from 'ulid';
import { useConversationStore } from '../stores/conversationStore';
import { useSubmitCompletion, usePollingCompletion } from './queries/useAI';

export const useConversation = (conversationId?: string) => {
  const {
    getActiveConversation,
    createConversation,
    addMessage,
    updateMessage,
    setActiveConversation,
  } = useConversationStore();

  const submitCompletion = useSubmitCompletion();
  
  const activeConversation = getActiveConversation();
  const currentConversation = conversationId 
    ? useConversationStore().getConversation(conversationId)
    : activeConversation;

  const sendMessage = useCallback(async (
    content: string, 
    file?: File,
    assistantType = 'vkd'
  ) => {
    let targetConversationId = conversationId || activeConversation?.id;

    // Create new conversation if none exists
    if (!targetConversationId) {
      targetConversationId = ulid();
      createConversation({
        id: targetConversationId,
        title: content.slice(0, 50) + (content.length > 50 ? '...' : ''),
        assistantType,
        lastActivity: new Date().toISOString(),
        isActive: true,
      });
    }

    // Add user message to store
    const userMessage = {
      id: ulid(),
      sortKey: currentConversation?.messages.length || 0,
      role: 'user' as const,
      content,
      timestamp: new Date().toISOString(),
      status: 'sending' as const,
      file,
    };

    addMessage(targetConversationId, userMessage);

    try {
      // Submit to API
      const response = await submitCompletion.mutateAsync({
        id: targetConversationId,
        sortKey: userMessage.sortKey,
        query: content,
        file,
        type: assistantType,
      });

      // Update user message status
      updateMessage(targetConversationId, userMessage.id, { status: 'sent' });

      // Add placeholder assistant message
      const assistantMessage = {
        id: ulid(),
        sortKey: userMessage.sortKey,
        role: 'assistant' as const,
        content: '',
        timestamp: new Date().toISOString(),
        status: 'sending' as const,
      };

      addMessage(targetConversationId, assistantMessage);

      return {
        conversationId: targetConversationId,
        messageId: assistantMessage.id,
        sortKey: userMessage.sortKey,
      };
    } catch (error) {
      updateMessage(targetConversationId, userMessage.id, { status: 'failed' });
      throw error;
    }
  }, [
    conversationId,
    activeConversation,
    currentConversation,
    createConversation,
    addMessage,
    updateMessage,
    submitCompletion,
  ]);

  return {
    conversation: currentConversation,
    sendMessage,
    isLoading: submitCompletion.isPending,
    error: submitCompletion.error,
  };
};

// hooks/useAIResponse.ts
export const useAIResponse = (
  conversationId: string,
  sortKey: number,
  messageId: string,
  enabled = true
) => {
  const { updateMessage } = useConversationStore();
  
  const { data, error, isLoading } = usePollingCompletion(
    conversationId,
    sortKey,
    { enabled }
  );

  useEffect(() => {
    if (data?.response) {
      const { status, message } = data.response;
      
      if (status === 'success' && message) {
        updateMessage(conversationId, messageId, {
          content: message,
          status: 'delivered',
        });
      } else if (status === 'failed') {
        updateMessage(conversationId, messageId, {
          content: 'Sorry, I encountered an error processing your request.',
          status: 'failed',
        });
      }
    }
  }, [data, conversationId, messageId, updateMessage]);

  useEffect(() => {
    if (error) {
      updateMessage(conversationId, messageId, {
        content: 'Sorry, I encountered an error processing your request.',
        status: 'failed',
      });
    }
  }, [error, conversationId, messageId, updateMessage]);

  return {
    isLoading,
    error,
    response: data?.response,
  };
};
```

### 5. Component Architecture

```typescript
// components/chat/ChatInterface.tsx
import React, { useEffect, useRef } from 'react';
import { useConversation } from '../../hooks/useConversation';
import { MessageList } from './MessageList';
import { MessageInput } from './MessageInput';
import { ConversationHeader } from './ConversationHeader';

interface ChatInterfaceProps {
  conversationId?: string;
  className?: string;
}

export const ChatInterface: React.FC<ChatInterfaceProps> = ({
  conversationId,
  className = '',
}) => {
  const { conversation, sendMessage, isLoading, error } = useConversation(conversationId);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [conversation?.messages]);

  const handleSendMessage = async (content: string, file?: File) => {
    try {
      await sendMessage(content, file);
    } catch (error) {
      console.error('Failed to send message:', error);
    }
  };

  return (
    <div className={`flex flex-col h-full ${className}`}>
      <ConversationHeader conversation={conversation} />
      
      <div className="flex-1 overflow-hidden">
        <MessageList 
          messages={conversation?.messages || []}
          isLoading={isLoading}
        />
        <div ref={messagesEndRef} />
      </div>

      <MessageInput
        onSendMessage={handleSendMessage}
        disabled={isLoading}
        error={error}
      />
    </div>
  );
};

// components/chat/MessageList.tsx
import React from 'react';
import { Message } from '../../types/conversation';
import { MessageBubble } from './MessageBubble';
import { TypingIndicator } from './TypingIndicator';

interface MessageListProps {
  messages: Message[];
  isLoading?: boolean;
}

export const MessageList: React.FC<MessageListProps> = ({
  messages,
  isLoading = false,
}) => {
  return (
    <div className="flex-1 overflow-y-auto p-4 space-y-4">
      {messages.map((message) => (
        <MessageBubble key={message.id} message={message} />
      ))}
      {isLoading && <TypingIndicator />}
    </div>
  );
};

// components/chat/MessageBubble.tsx
import React from 'react';
import ReactMarkdown from 'react-markdown';
import { Message } from '../../types/conversation';
import { FileAttachment } from './FileAttachment';

interface MessageBubbleProps {
  message: Message;
}

export const MessageBubble: React.FC<MessageBubbleProps> = ({ message }) => {
  const isUser = message.role === 'user';
  const isFailedMessage = message.status === 'failed';

  return (
    <div className={`flex ${isUser ? 'justify-end' : 'justify-start'}`}>
      <div
        className={`max-w-3xl rounded-lg px-4 py-2 ${
          isUser
            ? 'bg-blue-600 text-white'
            : isFailedMessage
            ? 'bg-red-100 text-red-800 border border-red-300'
            : 'bg-gray-100 text-gray-800'
        }`}
      >
        {message.file && (
          <FileAttachment file={message.file} />
        )}
        
        {isUser ? (
          <p className="whitespace-pre-wrap">{message.content}</p>
        ) : (
          <ReactMarkdown className="prose prose-sm max-w-none">
            {message.content}
          </ReactMarkdown>
        )}

        <div className={`text-xs mt-2 ${isUser ? 'text-blue-200' : 'text-gray-500'}`}>
          {new Date(message.timestamp).toLocaleTimeString()}
          {message.status === 'sending' && ' • Sending...'}
          {message.status === 'failed' && ' • Failed to send'}
        </div>
      </div>
    </div>
  );
};
```

### 6. Error Boundary and Loading States

```typescript
// components/ui/ErrorBoundary.tsx
import React, { Component, ErrorInfo, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
  };

  public static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Uncaught error:', error, errorInfo);
  }

  public render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="flex items-center justify-center h-64">
          <div className="text-center">
            <h2 className="text-lg font-semibold text-gray-900 mb-2">
              Something went wrong
            </h2>
            <p className="text-gray-600 mb-4">
              We encountered an unexpected error. Please try refreshing the page.
            </p>
            <button
              className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
              onClick={() => window.location.reload()}
            >
              Refresh Page
            </button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

// components/ui/LoadingSpinner.tsx
import React from 'react';

interface LoadingSpinnerProps {
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

export const LoadingSpinner: React.FC<LoadingSpinnerProps> = ({
  size = 'md',
  className = '',
}) => {
  const sizeClasses = {
    sm: 'w-4 h-4',
    md: 'w-8 h-8',
    lg: 'w-12 h-12',
  };

  return (
    <div className={`animate-spin ${sizeClasses[size]} ${className}`}>
      <div className="border-2 border-blue-600 border-t-transparent rounded-full w-full h-full"></div>
    </div>
  );
};
```

### 7. Testing Strategy

```typescript
// __tests__/hooks/useConversation.test.tsx
import { renderHook, act } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useConversation } from '../../hooks/useConversation';
import { AIService } from '../../services/api/aiService';

// Mock the AI service
jest.mock('../../services/api/aiService');

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
      mutations: { retry: false },
    },
  });
  
  return ({ children }: { children: React.ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
};

describe('useConversation', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should send a message successfully', async () => {
    const mockSubmitCompletion = jest.fn().mockResolvedValue({
      id: 'test-conversation',
      sortKey: 0,
      message: 'Processing request',
    });

    (AIService.prototype.submitCompletion as jest.Mock) = mockSubmitCompletion;

    const { result } = renderHook(() => useConversation(), {
      wrapper: createWrapper(),
    });

    await act(async () => {
      await result.current.sendMessage('Hello, AI!');
    });

    expect(mockSubmitCompletion).toHaveBeenCalledWith({
      id: expect.any(String),
      sortKey: 0,
      query: 'Hello, AI!',
      type: 'vkd',
    });
  });

  it('should handle message sending errors', async () => {
    const mockSubmitCompletion = jest.fn().mockRejectedValue(
      new Error('API Error')
    );

    (AIService.prototype.submitCompletion as jest.Mock) = mockSubmitCompletion;

    const { result } = renderHook(() => useConversation(), {
      wrapper: createWrapper(),
    });

    await expect(
      act(async () => {
        await result.current.sendMessage('Hello, AI!');
      })
    ).rejects.toThrow('API Error');
  });
});
```

## Performance Optimization Strategies

### 1. Code Splitting and Lazy Loading

```typescript
// routes/AppRoutes.tsx
import React, { Suspense } from 'react';
import { Routes, Route } from 'react-router-dom';
import { LoadingSpinner } from '../components/ui/LoadingSpinner';

// Lazy load route components
const ChatPage = React.lazy(() => import('../pages/ChatPage'));
const AdminPage = React.lazy(() => import('../pages/AdminPage'));
const ConversationsPage = React.lazy(() => import('../pages/ConversationsPage'));

export const AppRoutes: React.FC = () => {
  return (
    <Suspense fallback={<LoadingSpinner size="lg" />}>
      <Routes>
        <Route path="/" element={<ChatPage />} />
        <Route path="/conversations" element={<ConversationsPage />} />
        <Route path="/admin" element={<AdminPage />} />
        <Route path="/chat/:conversationId" element={<ChatPage />} />
      </Routes>
    </Suspense>
  );
};
```

### 2. Memoization and Performance

```typescript
// components/chat/MessageList.tsx (optimized)
import React, { memo, useMemo } from 'react';
import { FixedSizeList as List } from 'react-window';
import { Message } from '../../types/conversation';
import { MessageBubble } from './MessageBubble';

interface MessageListProps {
  messages: Message[];
  isLoading?: boolean;
}

const MessageItem = memo<{ index: number; style: any; data: Message[] }>(
  ({ index, style, data }) => (
    <div style={style}>
      <MessageBubble message={data[index]} />
    </div>
  )
);

export const MessageList: React.FC<MessageListProps> = memo(({
  messages,
  isLoading = false,
}) => {
  const itemData = useMemo(() => messages, [messages]);

  if (messages.length < 50) {
    // Use regular rendering for small message lists
    return (
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map((message) => (
          <MessageBubble key={message.id} message={message} />
        ))}
      </div>
    );
  }

  // Use virtualization for large message lists
  return (
    <List
      height={600}
      itemCount={messages.length}
      itemSize={100}
      itemData={itemData}
    >
      {MessageItem}
    </List>
  );
});
```

### 3. Request Deduplication and Caching

```typescript
// services/cache/responseCache.ts
class ResponseCache {
  private cache = new Map<string, { data: any; timestamp: number; ttl: number }>();

  set(key: string, data: any, ttl = 5 * 60 * 1000) {
    this.cache.set(key, {
      data,
      timestamp: Date.now(),
      ttl,
    });
  }

  get(key: string) {
    const item = this.cache.get(key);
    if (!item) return null;

    if (Date.now() - item.timestamp > item.ttl) {
      this.cache.delete(key);
      return null;
    }

    return item.data;
  }

  invalidate(keyPattern: string) {
    for (const key of this.cache.keys()) {
      if (key.includes(keyPattern)) {
        this.cache.delete(key);
      }
    }
  }

  clear() {
    this.cache.clear();
  }
}

export const responseCache = new ResponseCache();
```

## Accessibility Guidelines

### 1. ARIA Labels and Roles

```typescript
// components/chat/MessageList.tsx (with accessibility)
export const MessageList: React.FC<MessageListProps> = ({
  messages,
  isLoading,
}) => {
  return (
    <div
      role="log"
      aria-live="polite"
      aria-label="Chat conversation"
      className="flex-1 overflow-y-auto p-4 space-y-4"
    >
      {messages.map((message, index) => (
        <div
          key={message.id}
          role="article"
          aria-label={`Message ${index + 1} from ${message.role}`}
        >
          <MessageBubble message={message} />
        </div>
      ))}
      {isLoading && (
        <div role="status" aria-label="AI is typing">
          <TypingIndicator />
        </div>
      )}
    </div>
  );
};
```

### 2. Keyboard Navigation

```typescript
// components/chat/MessageInput.tsx (with keyboard support)
export const MessageInput: React.FC<MessageInputProps> = ({
  onSendMessage,
  disabled,
}) => {
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSubmit();
    }
  };

  return (
    <form onSubmit={handleSubmit} className="p-4 border-t">
      <div className="flex items-end space-x-2">
        <textarea
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={handleKeyDown}
          placeholder="Type your message..."
          disabled={disabled}
          aria-label="Message input"
          className="flex-1 resize-none border rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          rows={1}
        />
        <button
          type="submit"
          disabled={disabled || !input.trim()}
          aria-label="Send message"
          className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          Send
        </button>
      </div>
    </form>
  );
};
```

## Deployment and Build Configuration

### 1. Vite Configuration

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          router: ['react-router-dom'],
          query: ['@tanstack/react-query'],
          ui: ['@radix-ui/react-dialog', '@radix-ui/react-dropdown-menu'],
        },
      },
    },
  },
  server: {
    proxy: {
      '/ai': {
        target: 'https://api.vermontkidsdata.org',
        changeOrigin: true,
        secure: true,
      },
    },
  },
});
```

### 2. Environment Configuration

```typescript
// config/environment.ts
interface Environment {
  apiUrl: string;
  apiKey: string;
  environment: 'development' | 'staging' | 'production';
  enableAnalytics: boolean;
  maxFileUploadSize: number;
}

export const getEnvironment = (): Environment => {
  return {
    apiUrl: import.meta.env.VITE_API_URL || 'https://api.vermontkidsdata.org',
    apiKey: import.meta.env.VITE_API_KEY || '',
    environment: (import.meta.env.VITE_ENVIRONMENT as any) || 'development',
    enableAnalytics: import.meta.env.VITE_ENABLE_ANALYTICS === 'true',
    maxFileUploadSize: Number(import.meta.env.VITE_MAX_FILE_UPLOAD_SIZE) || 10 * 1024 * 1024, // 10MB
  };
};
```

This architecture guide provides a comprehensive foundation for building a scalable, performant, and accessible React frontend for the AI Assistant API. The patterns and practices outlined here will ensure maintainable code and excellent user experience.