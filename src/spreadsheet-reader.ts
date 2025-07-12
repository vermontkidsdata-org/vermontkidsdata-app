import { readGoogleSheets } from './read-google-sheets';
import { readExcelFile, readCsvFile } from './read-excel-file';
import * as fs from 'fs';
import * as path from 'path';
import * as XLSX from 'xlsx';

/**
 * Interface for worksheet data
 */
export interface WorksheetData {
  worksheet: string;
  columns: string[];
  rows: any[][];
}

/**
 * Unified function to read spreadsheet data from various sources
 * 
 * @param source - Source of the spreadsheet data (file path or Google Sheets ID)
 * @param options - Options for reading the spreadsheet
 * @returns Promise resolving to an array of worksheet data objects
 */
export async function readSpreadsheet(
  source: string,
  options?: {
    type?: 'google' | 'excel' | 'csv';
    credentials?: {
      client_email: string;
      private_key: string;
      [key: string]: any;
    };
    sheetName?: string;
  }
): Promise<WorksheetData[]> {
  // Determine the type of source if not specified
  const type = options?.type || determineSourceType(source);
  
  switch (type) {
    case 'google':
      if (!options?.credentials) {
        throw new Error('Google Sheets credentials are required');
      }
      return readGoogleSheets(source, options.credentials);
    
    case 'excel':
      return readExcelFile(source);
    
    case 'csv':
      return [readCsvFile(source, options?.sheetName)];
    
    default:
      throw new Error(`Unsupported spreadsheet type: ${type}`);
  }
}

/**
 * Determine the type of spreadsheet source based on the source string
 * 
 * @param source - Source of the spreadsheet data
 * @returns The determined type of the source
 */
function determineSourceType(source: string): 'google' | 'excel' | 'csv' {
  // Check if it's a file path
  if (fs.existsSync(source)) {
    const ext = path.extname(source).toLowerCase();
    if (ext === '.csv') {
      return 'csv';
    } else if (['.xlsx', '.xls', '.xlsm', '.xlsb'].includes(ext)) {
      return 'excel';
    }
  }
  
  // If it's not a file path or not a recognized extension,
  // assume it's a Google Sheets ID
  return 'google';
}

/**
 * Example usage
 */
async function example() {
  try {
    // Example 1: Read local Excel file
    console.log('Example 1: Reading local Excel file');
    const excelData = await readSpreadsheet('./data/example.xlsx');
    console.log(JSON.stringify(excelData, null, 2));
    
    // Example 2: Read local CSV file
    console.log('\nExample 2: Reading local CSV file');
    const csvData = await readSpreadsheet('./data/example.csv');
    console.log(JSON.stringify(csvData, null, 2));
    
    // Example 3: Read Google Sheets document
    console.log('\nExample 3: Reading Google Sheets document');
    const credentials = {
      "client_email": "your-service-account@your-project-id.iam.gserviceaccount.com",
      "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
      // Add other required fields
    };
    
    const googleData = await readSpreadsheet(
      'YOUR_SPREADSHEET_ID',
      {
        type: 'google',
        credentials
      }
    );
    console.log(JSON.stringify(googleData, null, 2));
    
  } catch (error) {
    console.error('Error in example:', error);
  }
}

// Uncomment to run the example
// example().catch(console.error);

/**
 * Create a sample Excel file for testing
 * 
 * @param filePath - Path to save the sample Excel file
 */
export function createSampleExcelFile(filePath: string): void {
  try {
    // Create a new workbook
    const workbook = XLSX.utils.book_new();
    
    // Create data for Sheet1
    const sheet1Data = [
      { Name: 'John', Age: 30, City: 'New York' },
      { Name: 'Alice', Age: 25, City: 'Boston' },
      { Name: 'Bob', Age: 35, City: 'Chicago' }
    ];
    
    // Create data for Sheet2
    const sheet2Data = [
      { Product: 'Laptop', Price: 1200, Stock: 50 },
      { Product: 'Phone', Price: 800, Stock: 100 },
      { Product: 'Tablet', Price: 500, Stock: 75 }
    ];
    
    // Convert data to worksheets
    const sheet1 = XLSX.utils.json_to_sheet(sheet1Data);
    const sheet2 = XLSX.utils.json_to_sheet(sheet2Data);
    
    // Add worksheets to workbook
    XLSX.utils.book_append_sheet(workbook, sheet1, 'People');
    XLSX.utils.book_append_sheet(workbook, sheet2, 'Products');
    
    // Write to file
    XLSX.writeFile(workbook, filePath);
    
    console.log(`Sample Excel file created at: ${filePath}`);
  } catch (error) {
    console.error('Error creating sample Excel file:', error);
    throw error;
  }
}

/**
 * Create a sample CSV file for testing
 * 
 * @param filePath - Path to save the sample CSV file
 */
export function createSampleCsvFile(filePath: string): void {
  try {
    // Create data
    const data = [
      { Name: 'John', Age: 30, City: 'New York' },
      { Name: 'Alice', Age: 25, City: 'Boston' },
      { Name: 'Bob', Age: 35, City: 'Chicago' }
    ];
    
    // Convert data to worksheet
    const sheet = XLSX.utils.json_to_sheet(data);
    
    // Create a new workbook and add the worksheet
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, sheet, 'Sheet1');
    
    // Write to file
    XLSX.writeFile(workbook, filePath);
    
    console.log(`Sample CSV file created at: ${filePath}`);
  } catch (error) {
    console.error('Error creating sample CSV file:', error);
    throw error;
  }
}