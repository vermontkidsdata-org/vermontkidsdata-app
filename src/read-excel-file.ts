import * as XLSX from 'xlsx';
import * as fs from 'fs';
import * as path from 'path';

/**
 * Interface for worksheet data
 */
interface WorksheetData {
  worksheet: string;
  columns: string[];
  rows: any[][];
}

/**
 * Read Excel file and convert each worksheet to structured data
 * 
 * @param filePath - Path to the Excel file
 * @returns Array of worksheet data objects
 */
export function readExcelFile(filePath: string): WorksheetData[] {
  try {
    // Check if file exists
    if (!fs.existsSync(filePath)) {
      throw new Error(`File not found: ${filePath}`);
    }

    // Read the Excel file
    const workbook = XLSX.readFile(filePath);
    console.log(`Successfully loaded Excel file: ${path.basename(filePath)}`);
    
    const worksheetData: WorksheetData[] = [];

    // Process each worksheet
    workbook.SheetNames.forEach(sheetName => {
      console.log(`Processing worksheet: ${sheetName}`);
      
      // Get the worksheet
      const worksheet = workbook.Sheets[sheetName];
      
      // Convert worksheet to JSON
      const jsonData = XLSX.utils.sheet_to_json(worksheet) as Record<string, any>[];
      
      if (jsonData.length === 0) {
        console.log(`Worksheet ${sheetName} is empty, skipping`);
        return;
      }

      // Get column headers from the first row
      const firstRow = jsonData[0] as Record<string, any>;
      const columns = Object.keys(firstRow);

      // Extract row data
      const rowData = jsonData.map(row => {
        const typedRow = row as Record<string, any>;
        return columns.map(column => typedRow[column] ?? null);
      });

      // Create worksheet data object
      worksheetData.push({
        worksheet: sheetName,
        columns,
        rows: rowData
      });
    });

    return worksheetData;
  } catch (error) {
    console.error('Error reading Excel file:', error);
    throw error;
  }
}

/**
 * Read CSV file and convert to structured data
 * 
 * @param filePath - Path to the CSV file
 * @param sheetName - Optional name for the worksheet (defaults to filename without extension)
 * @returns Worksheet data object
 */
export function readCsvFile(filePath: string, sheetName?: string): WorksheetData {
  try {
    // Check if file exists
    if (!fs.existsSync(filePath)) {
      throw new Error(`File not found: ${filePath}`);
    }

    // Read the CSV file
    const workbook = XLSX.readFile(filePath);
    const worksheet = workbook.Sheets[workbook.SheetNames[0]];
    
    // Use provided sheet name or extract from filename
    const wsName = sheetName || path.basename(filePath, path.extname(filePath));
    console.log(`Processing CSV as worksheet: ${wsName}`);
    
    // Convert worksheet to JSON
    const jsonData = XLSX.utils.sheet_to_json(worksheet);
    
    if (jsonData.length === 0) {
      throw new Error(`CSV file ${filePath} is empty`);
    }

    // Get column headers from the first row
    const firstRow = jsonData[0] as Record<string, any>;
    const columns = Object.keys(firstRow);

    // Extract row data
    const rowData = jsonData.map(row => {
      const typedRow = row as Record<string, any>;
      return columns.map(column => typedRow[column] ?? null);
    });

    // Create worksheet data object
    return {
      worksheet: wsName,
      columns,
      rows: rowData
    };
  } catch (error) {
    console.error('Error reading CSV file:', error);
    throw error;
  }
}

/**
 * Example usage
 */
function example() {
  try {
    // Example 1: Read Excel file with multiple worksheets
    const excelFilePath = './data/example.xlsx';
    const worksheetData = readExcelFile(excelFilePath);
    
    // Print the results
    console.log('Excel Worksheet Data:');
    console.log(JSON.stringify(worksheetData, null, 2));
    
    // Example 2: Read CSV file
    const csvFilePath = './data/example.csv';
    const csvData = readCsvFile(csvFilePath);
    
    console.log('CSV Data:');
    console.log(JSON.stringify(csvData, null, 2));
  } catch (error) {
    console.error('Failed to read file:', error);
  }
}

// Uncomment to run the example
// example();