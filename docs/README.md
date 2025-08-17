# AI Assistant API Documentation Suite

## Overview

This documentation suite provides comprehensive guidance for frontend developers building a React client application for the Vermont Kids Data AI Assistant API. The API leverages OpenAI's Assistants API to provide intelligent data analysis and question-answering capabilities for Vermont children's data.

## Documentation Structure

### 1. [AI Client Documentation](./ai-client-documentation.md) - **Main Document**
The primary comprehensive guide covering:
- **Complete API endpoint documentation** with examples
- **Authentication and security guidelines**
- **Data models and response formats**
- **Frontend integration patterns** and React hooks
- **Error handling strategies**
- **Performance optimization recommendations**
- **Suggested API improvements** and additional endpoints

### 2. [AI API Reference](./ai-api-reference.md) - **Quick Reference**
A condensed reference document featuring:
- **Quick endpoint lookup** with HTTP methods and parameters
- **Common request/response examples**
- **Rate limiting information**
- **Status codes and error formats**
- **Complete conversation flow examples**

### 3. [Frontend Architecture Guide](./frontend-architecture-guide.md) - **Implementation Guide**
Detailed architectural recommendations including:
- **Technology stack recommendations**
- **Project structure and organization**
- **Service layer patterns** for API integration
- **State management** with React Query and Zustand
- **Component architecture** examples
- **Performance optimization** strategies
- **Accessibility guidelines**
- **Testing approaches**

### 4. [Assistant API Usage Guide](./assistant-api-usage.md) - **Existing Documentation**
Existing documentation covering:
- **OpenAI Assistants API context maintenance**
- **Conversation history retrieval**
- **Implementation examples**

## Key Features of the AI API

### User-Facing Capabilities
- **Asynchronous AI conversations** with job-based processing
- **File upload support** (PDF, TXT, JSON, CSV)
- **Conversation history management** with full context retrieval
- **Multiple assistant types** for different use cases
- **Real-time status polling** for AI response generation

### Administrative Features
- **Assistant management** (create, update, publish)
- **Function management** for custom AI capabilities
- **Document management** for knowledge base
- **Environment support** (sandbox, production)
- **Usage analytics** and filtering

## Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   React Client  │────│  Lambda API      │────│  OpenAI API     │
│                 │    │                  │    │                 │
│ • Chat UI       │    │ • Authentication │    │ • GPT Models    │
│ • File Upload   │    │ • Job Processing │    │ • Assistants    │
│ • Admin Panel   │    │ • Status Polling │    │ • File Analysis │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                         ┌──────▼──────┐
                         │  DynamoDB   │
                         │             │
                         │ • Messages  │
                         │ • Assistants│
                         │ • Sessions  │
                         └─────────────┘
```

## Quick Start for Frontend Developers

### 1. Understanding the API Flow

```typescript
// 1. Submit a query
const response = await fetch('/ai/completion', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    key: 'your-api-key',
    id: 'conversation-id',
    sortKey: 0,
    query: 'What programs help Vermont children?'
  })
});

// 2. Poll for the AI response
const pollForResponse = async (id, sortKey) => {
  while (true) {
    const result = await fetch(`/ai/completion/${id}/${sortKey}`);
    const data = await result.json();
    
    if (data.response.status === 'success') {
      return data.response.message;
    }
    
    await new Promise(resolve => setTimeout(resolve, 2000));
  }
};
```

### 2. Recommended React Setup

```bash
# Create React app with recommended tools
npm create vite@latest vkd-ai-client -- --template react-ts
cd vkd-ai-client

# Install core dependencies
npm install @tanstack/react-query zustand axios react-router-dom
npm install @types/node ulid react-markdown

# Install UI dependencies
npm install tailwindcss @headlessui/react @heroicons/react
```

### 3. Essential Components

The architecture guide provides complete implementations for:
- **AIService** - Centralized API client
- **useConversation** - React hook for chat interactions
- **ChatInterface** - Complete chat UI component
- **ConversationStore** - State management for multiple conversations

## Integration Patterns

### Authentication
- **API Key**: Required for all AI endpoints in request body
- **Session Auth**: For administrative functions via cookies
- **Rate Limiting**: Built-in protection with configurable limits

### Error Handling
- **HTTP Status Codes**: 400 (Bad Request), 403 (Forbidden), 404 (Not Found), 500 (Server Error)
- **Retry Logic**: Exponential backoff for transient failures
- **User-Friendly Messages**: Clear error communication in UI

### Performance Optimization
- **Response Caching**: 5-minute TTL for completed responses
- **Request Deduplication**: Prevent duplicate API calls
- **Virtual Scrolling**: For large conversation histories
- **Code Splitting**: Lazy load admin features

## Security Considerations

### Data Protection
- **API Key Security**: Store securely, never expose in client code
- **Session Management**: Automatic TTL and secure cookie handling
- **File Upload Validation**: Size limits and type restrictions
- **Input Sanitization**: Prevent injection attacks

### Privacy Features (Recommended)
- **Data Retention Controls**: User-configurable retention periods
- **Export Capabilities**: GDPR compliance features
- **Analytics Opt-out**: User privacy controls

## Scalability Features

### Current Capabilities
- **Asynchronous Processing**: Non-blocking AI interactions
- **Environment Isolation**: Sandbox and production separation
- **Assistant Versioning**: Publish/update cycle management
- **Conversation Persistence**: DynamoDB storage with efficient querying

### Recommended Enhancements
- **WebSocket Streaming**: Real-time AI response delivery
- **Advanced Caching**: Redis integration for high-traffic scenarios
- **Load Balancing**: Multiple assistant instances
- **CDN Integration**: Static asset optimization

## Development Workflow

### 1. Setup Development Environment
```bash
# Clone the backend repository
git clone https://github.com/vermontkidsdata-org/vermontkidsdata-app.git

# Set up frontend project (see Architecture Guide)
# Configure API proxy in vite.config.ts for local development
```

### 2. API Testing
```bash
# Use the existing test endpoints to validate connectivity
curl -X POST https://api.vermontkidsdata.org/ai/completion \
  -H "Content-Type: application/json" \
  -d '{"key":"your-key","id":"test","sortKey":0,"query":"Hello"}'
```

### 3. Build and Deploy
```bash
# Build for production
npm run build

# Deploy to CDN or static hosting
# Configure environment variables for production API
```

## Support and Troubleshooting

### Common Issues
1. **CORS Errors**: Configure API proxy for local development
2. **Authentication Failures**: Verify API key configuration
3. **File Upload Issues**: Check file size and type restrictions
4. **Slow Responses**: Implement proper loading states and timeouts

### Debugging Tools
- **Browser DevTools**: Network tab for API inspection
- **React DevTools**: Component state debugging
- **Query DevTools**: React Query cache inspection

### API Monitoring
- **Health Checks**: `/health` endpoint for system status
- **Usage Metrics**: Track API call patterns and performance
- **Error Rates**: Monitor and alert on failure patterns

## Next Steps

1. **Review the main documentation** in [ai-client-documentation.md](./ai-client-documentation.md)
2. **Set up your development environment** using the [Frontend Architecture Guide](./frontend-architecture-guide.md)
3. **Implement basic chat functionality** using the provided React patterns
4. **Add administrative features** for assistant management
5. **Optimize for production** with performance and security best practices

## Contributing

When extending this API or documentation:

1. **Follow the established patterns** for consistency
2. **Update all relevant documentation** when adding new endpoints
3. **Include TypeScript types** for all new data structures
4. **Add comprehensive error handling** for new features
5. **Write tests** for critical functionality
6. **Consider accessibility** in UI implementations

## Resources

- **OpenAI Assistants API**: https://platform.openai.com/docs/assistants/overview
- **React Query Documentation**: https://tanstack.com/query/latest
- **Zustand State Management**: https://github.com/pmndrs/zustand
- **Tailwind CSS**: https://tailwindcss.com/docs
- **Accessibility Guidelines**: https://www.w3.org/WAI/WCAG21/quickref/

This documentation suite provides everything needed to build a robust, scalable, and user-friendly frontend for the Vermont Kids Data AI Assistant API.