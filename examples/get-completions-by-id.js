// Example script to test the new GET completion/{id} endpoint
// Usage: node get-completions-by-id.js <conversation-id>

const axios = require('axios');
const API_URL = process.env.API_URL || 'https://your-api-url.com';
const API_KEY = process.env.API_KEY || 'your-api-key';

async function getCompletionsById(conversationId) {
  try {
    const response = await axios.get(`${API_URL}/ai/completion/${conversationId}`, {
      headers: {
        'x-api-key': API_KEY
      }
    });
    
    console.log('Response status:', response.status);
    console.log('Response data:', JSON.stringify(response.data, null, 2));
    
    return response.data;
  } catch (error) {
    console.error('Error fetching completions:', error.response?.data || error.message);
    throw error;
  }
}

// Get conversation ID from command line arguments
const conversationId = process.argv[2];

if (!conversationId) {
  console.error('Please provide a conversation ID as a command line argument');
  console.error('Usage: node get-completions-by-id.js <conversation-id>');
  process.exit(1);
}

// Execute the test
getCompletionsById(conversationId)
  .then(() => console.log('Test completed successfully'))
  .catch(() => process.exit(1));