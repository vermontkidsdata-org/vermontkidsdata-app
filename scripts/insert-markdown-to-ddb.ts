#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import {
  DynamoDBClient,
  ConditionalCheckFailedException
} from '@aws-sdk/client-dynamodb';
import {
  DynamoDBDocumentClient,
  PutCommand,
  PutCommandInput,
  UpdateCommand,
  UpdateCommandInput
} from '@aws-sdk/lib-dynamodb';

// Define the DynamoDB tables based on environment
const TABLES: Record<string, string> = {
  qa: 'qa-LocalDevBranch-SingleServiceTableABC698C2-3Z52F7FCI8WH',
  master: 'master-LocalDevBranch-SingleServiceTableABC698C2-FNHLW4FT8XVJ'
};

// Get the environment from the VKD_ENVIRONMENT variable, default to 'qa' if not set
const environment: string = process.env.VKD_ENVIRONMENT || 'qa';

// Determine which table to use
const tableName: string = TABLES[environment] || TABLES.qa;

console.log(`Using environment: ${environment}`);
console.log(`Using DynamoDB table: ${tableName}`);

// Initialize DynamoDB client
const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

// Define interfaces
interface MarkdownItem {
  fileName: string;
  message?: string;  // Changed from content to message
}

// No need for a custom DynamoDB item type as we're using the Document client

// Function to get all markdown files in a directory
function getMarkdownFiles(dirPath: string): string[] {
  const files = fs.readdirSync(dirPath);
  return files.filter(file => path.extname(file).toLowerCase() === '.md');
}

// Function to insert or update an item in DynamoDB
async function insertOrUpdateItemToDynamoDB(tableName: string, item: MarkdownItem): Promise<boolean> {
  const fileName = item.fileName;
  // Use the filename without the .md extension as the itemId
  const itemId = fileName.replace(/\.md$/, '');
  const timestamp = new Date().toISOString();
  
  // We'll use the Document client which handles the attribute conversion for us
  
  try {
    // First try to put the item with a condition that it doesn't exist
    const putParams: PutCommandInput = {
      TableName: tableName,
      Item: {
        PK: `CONV#${itemId}`,
        SK: `SORT#0`,
        id: itemId,
        fileName: fileName,
        envName: environment,
        query: `Do a needs assessment for ${itemId}`,
        sortKey: 0,
        status: "success",
        type: "needs-assessment",
        _ct: timestamp,
        _md: timestamp,
        _et: "Completion",
        stream: "false",  // Added stream property
        GSI3PK: `TYPE#needs-assessment`,
        GSI3SK: `CONV#${itemId}#SORT#0`,
        ...(item.message && { message: item.message })  // Changed from content to message
      },
      ConditionExpression: "attribute_not_exists(PK)"
    };
    
    try {
      // Try to insert as new item
      await docClient.send(new PutCommand(putParams));
      console.log(`Successfully inserted new item for file: ${fileName}`);
      return true;
    } catch (error) {
      // If the item already exists, update it instead
      if (error instanceof ConditionalCheckFailedException) {
        // Item exists, update it
        const updateParams: UpdateCommandInput = {
          TableName: tableName,
          Key: {
            PK: `CONV#${itemId}`,
            SK: `SORT#0`
          },
          UpdateExpression: "SET #id = :id, #fileName = :fileName, #envName = :envName, " +
                           "#query = :query, #sortKey = :sortKey, #status = :status, " +
                           "#type = :type, #md = :md, #et = :et, #stream = :stream, " +
                           "#gsi3pk = :gsi3pk, #gsi3sk = :gsi3sk" +
                           (item.message ? ", #message = :message" : ""),
          ExpressionAttributeValues: {
            ":id": itemId,
            ":fileName": fileName,
            ":envName": environment,
            ":query": `Do a needs assessment for ${itemId}`,
            ":sortKey": 0,
            ":status": "success",
            ":type": "needs-assessment",
            ":md": timestamp,
            ":et": "Completion",
            ":stream": "false",  // Added stream property
            ...(item.message && { ":message": item.message }),  // Changed from content to message
            ":gsi3pk": "TYPE#needs-assessment",
            ":gsi3sk": `CONV#${itemId}#SORT#0`
          },
          ExpressionAttributeNames: {
            "#id": "id",
            "#fileName": "fileName",
            "#envName": "envName",
            "#sortKey": "sortKey",
            "#md": "_md",
            "#et": "_et",
            "#query": "query",
            "#status": "status",
            "#type": "type",
            "#stream": "stream",
            "#message": "message",
            "#gsi3pk": "GSI3PK",
            "#gsi3sk": "GSI3SK"
          },
          ReturnValues: "NONE"
        };
        
        await docClient.send(new UpdateCommand(updateParams));
        console.log(`Successfully updated existing item for file: ${fileName}`);
        return true;
      } else {
        // Some other error occurred
        throw error;
      }
    }
  } catch (error) {
    console.error(`Error processing item for file: ${fileName}`, error);
    return false;
  }
}

// Main function
async function main(): Promise<void> {
  const dataDir = path.join(__dirname, '..', 'data');
  const markdownFiles = getMarkdownFiles(dataDir);
  
  console.log(`Found ${markdownFiles.length} markdown files in the data directory:`);
  markdownFiles.forEach(file => console.log(`- ${file}`));
  
  console.log('\nInserting/updating files in DynamoDB...');
  
  let successCount = 0;
  
  // Process files sequentially to avoid overwhelming DynamoDB
  for (const file of markdownFiles) {
    const filePath = path.join(dataDir, file);
    
    // Read file content
    const content = fs.readFileSync(filePath, 'utf8');
    
    const item: MarkdownItem = {
      fileName: file,
      message: content  // Changed from content to message
    };
    
    if (await insertOrUpdateItemToDynamoDB(tableName, item)) {
      successCount++;
    }

    // Don't exit early - this would prevent processing all files
  }
  
  console.log(`\nSummary: Processed ${successCount} out of ${markdownFiles.length} files into DynamoDB table ${tableName}`);
}

// Run the main function
main().catch(error => {
  console.error('An error occurred:', error);
  process.exit(1);
});