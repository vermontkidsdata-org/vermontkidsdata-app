import { GoogleSpreadsheet, GoogleSpreadsheetRow, GoogleSpreadsheetWorksheet } from 'google-spreadsheet';
import { JWT } from 'google-auth-library';

/**
 * Interface for worksheet data
 */
interface WorksheetData {
  worksheet: string;
  columns: string[];
  rows: any[][];
}

/**
 * Read Google Sheets document and convert each worksheet to structured data
 * 
 * @param spreadsheetId - The ID of the Google Sheets document (from the URL)
 * @param credentials - Google Service Account credentials JSON object
 * @returns Array of worksheet data objects
 */
export async function readGoogleSheets(
  spreadsheetId: string,
  credentials: {
    client_email: string;
    private_key: string;
    [key: string]: any;
  }
): Promise<WorksheetData[]> {
  try {
    // Create JWT client for authentication
    const auth = new JWT({
      email: credentials.client_email,
      key: credentials.private_key,
      scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });

    // Initialize the Google Spreadsheet
    const doc = new GoogleSpreadsheet(spreadsheetId, auth);
    
    // Load document properties and worksheets
    await doc.loadInfo();
    console.log(`Successfully loaded document: ${doc.title}`);

    const worksheetData: WorksheetData[] = [];

    // Process each worksheet
    for (let i = 0; i < doc.sheetCount; i++) {
      const worksheet = doc.sheetsByIndex[i];
      console.log(`Processing worksheet: ${worksheet.title}`);
      
      // Load all cells in the worksheet
      await worksheet.loadCells();
      
      // Load all rows to get the data
      const rows = await worksheet.getRows();
      
      if (rows.length === 0) {
        console.log(`Worksheet ${worksheet.title} is empty, skipping`);
        continue;
      }

      // Get column headers from the first row
      const headerRow = rows[0];
      const columns = Object.keys(headerRow).filter(key => 
        !key.startsWith('_') && key !== 'rowIndex' && key !== 'rowNumber'
      );

      // Extract row data
      const rowData = rows.map(row => {
        return columns.map(column => row.get(column));
      });

      // Create worksheet data object
      worksheetData.push({
        worksheet: worksheet.title,
        columns,
        rows: rowData
      });
    }

    return worksheetData;
  } catch (error) {
    console.error('Error reading Google Sheets:', error);
    throw error;
  }
}

/**
 * Alternative method using API key instead of service account
 * Note: API key has limited access and may not work for private sheets
 */
export async function readGoogleSheetsWithApiKey(
  spreadsheetId: string,
  apiKey: string
): Promise<WorksheetData[]> {
  try {
    // Initialize the Google Spreadsheet with API key
    const auth = new JWT({
      email: 'unused@example.com',
      key: 'unused-key',
      scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });
    
    const doc = new GoogleSpreadsheet(spreadsheetId, auth);
    
    // Set API key for authentication
    // Note: The current version of the library doesn't support API key directly
    // This is a workaround - in practice, you should use a service account
    (doc as any).apiKey = apiKey;
    
    // Load document properties and worksheets
    await doc.loadInfo();
    console.log(`Successfully loaded document: ${doc.title}`);

    const worksheetData: WorksheetData[] = [];

    // Process each worksheet
    for (let i = 0; i < doc.sheetCount; i++) {
      const worksheet = doc.sheetsByIndex[i];
      console.log(`Processing worksheet: ${worksheet.title}`);
      
      // Load all rows to get the data
      const rows = await worksheet.getRows();
      
      if (rows.length === 0) {
        console.log(`Worksheet ${worksheet.title} is empty, skipping`);
        continue;
      }

      // Get column headers from the first row
      const headerRow = rows[0];
      const columns = Object.keys(headerRow).filter(key => 
        !key.startsWith('_') && key !== 'rowIndex' && key !== 'rowNumber'
      );

      // Extract row data
      const rowData = rows.map(row => {
        return columns.map(column => row.get(column));
      });

      // Create worksheet data object
      worksheetData.push({
        worksheet: worksheet.title,
        columns,
        rows: rowData
      });
    }

    return worksheetData;
  } catch (error) {
    console.error('Error reading Google Sheets:', error);
    throw error;
  }
}

/**
 * Example usage
 */
async function example() {
  // Replace with your Google Sheets ID (from the URL)
  const spreadsheetId = 'YOUR_SPREADSHEET_ID';
  
  // Option 1: Using Service Account (recommended for server applications)
  // Replace with your service account credentials
  const credentials = {
    "type": "service_account",
    "project_id": "your-project-id",
    "private_key_id": "your-private-key-id",
    "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
    "client_email": "your-service-account@your-project-id.iam.gserviceaccount.com",
    "client_id": "your-client-id",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-service-account%40your-project-id.iam.gserviceaccount.com"
  };

  try {
    // Read worksheets using service account
    const worksheetData = await readGoogleSheets(spreadsheetId, credentials);
    
    // Print the results
    console.log('Worksheet Data:');
    console.log(JSON.stringify(worksheetData, null, 2));
    
    // Option 2: Using API Key (limited access, works for public sheets)
    // const apiKey = 'YOUR_API_KEY';
    // const worksheetData = await readGoogleSheetsWithApiKey(spreadsheetId, apiKey);
  } catch (error) {
    console.error('Failed to read Google Sheets:', error);
  }
}

// Uncomment to run the example
// example().catch(console.error);