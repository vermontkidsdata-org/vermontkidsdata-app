#!/usr/bin/env node

/**
 * Script to get MySQL credentials from AWS Secrets Manager and provide connection info
 * Usage: node scripts/get-mysql-credentials.js [environment]
 */

const { SecretsManagerClient, GetSecretValueCommand } = require('@aws-sdk/client-secrets-manager');

async function getDBCredentials(environment = 'qa') {
  const secretId = `vkd/${environment}/dbcreds`;
  
  console.log(`Getting MySQL credentials for environment: ${environment}`);
  console.log(`Fetching secret: ${secretId}`);
  
  try {
    const client = new SecretsManagerClient({ 
      region: 'us-east-1',
      profile: 'BBF' // Use your AWS profile
    });
    
    const response = await client.send(new GetSecretValueCommand({
      SecretId: secretId
    }));
    
    if (!response.SecretString) {
      throw new Error('Secret not found or empty');
    }
    
    const credentials = JSON.parse(response.SecretString);
    const { host, username, password, schema } = credentials;
    
    console.log('\n=== Database Connection Details ===');
    console.log(`Host: ${host}`);
    console.log(`Username: ${username}`);
    console.log(`Schema: ${schema}`);
    console.log(`Password: [hidden]`);
    
    console.log('\n=== MySQL CLI Commands ===');
    console.log('\n1. Connect with password prompt (recommended):');
    console.log(`mysql -h ${host} -u ${username} -p ${schema}`);
    
    console.log('\n2. Connect directly (password visible in history):');
    console.log(`mysql -h ${host} -u ${username} -p'${password}' ${schema}`);
    
    console.log('\n3. Execute SQL file:');
    console.log(`mysql -h ${host} -u ${username} -p ${schema} < your-script.sql`);
    
    console.log('\n=== Environment Variables (for scripts) ===');
    console.log(`export MYSQL_HOST='${host}'`);
    console.log(`export MYSQL_USER='${username}'`);
    console.log(`export MYSQL_PASSWORD='${password}'`);
    console.log(`export MYSQL_DATABASE='${schema}'`);
    
    console.log('\n=== For Act76 Data Updates ===');
    console.log('After running the suppression script and generating new SQL:');
    console.log(`mysql -h ${host} -u ${username} -p ${schema} < scripts/act76-child-inserts-$(date +%Y%m%d).sql`);
    
    return credentials;
    
  } catch (error) {
    console.error('Error getting database credentials:', error.message);
    
    if (error.name === 'UnrecognizedClientException') {
      console.error('\nMake sure you have AWS CLI configured with the BBF profile:');
      console.error('aws configure --profile BBF');
    }
    
    process.exit(1);
  }
}

// Get environment from command line argument or default to 'qa'
const environment = process.argv[2] || 'qa';
getDBCredentials(environment);