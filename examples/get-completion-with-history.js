/**
 * Example script to demonstrate retrieving a completion with full conversation history
 * 
 * Usage: 
 * 1. Set the API_KEY, CONVERSATION_ID, and SORT_KEY variables below
 * 2. Run with: node get-completion-with-history.js
 */

const axios = require('axios');

// Configuration
const API_ENDPOINT = 'https://your-api-endpoint.execute-api.us-east-1.amazonaws.com/prod/ai/completion';
const API_KEY = 'your-api-key';
const CONVERSATION_ID = 'your-conversation-id';
const SORT_KEY = 3; // The message number you want to retrieve (with history)

async function getCompletionWithHistory() {
  try {
    // Make the API request with includeHistory=true
    const response = await axios.get(
      `${API_ENDPOINT}/${CONVERSATION_ID}/${SORT_KEY}?includeHistory=true&key=${API_KEY}`
    );
    
    console.log('API Response:');
    console.log(JSON.stringify(response.data, null, 2));
    
    // If history is available, display the full conversation
    if (response.data.history && response.data.history.length > 0) {
      console.log('\n--- Full Conversation ---');
      
      response.data.history.forEach(msg => {
        console.log(`\n[User Query #${msg.sortKey}]: ${msg.query}`);
        console.log(`[Assistant Response #${msg.sortKey}]: ${msg.message}`);
        console.log('---');
      });
    }
  } catch (error) {
    console.error('Error retrieving completion:', error.response?.data || error.message);
  }
}

// Execute the function
getCompletionWithHistory();