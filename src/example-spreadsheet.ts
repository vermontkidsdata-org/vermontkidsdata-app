import { readSpreadsheet, createSampleExcelFile, createSampleCsvFile, WorksheetData } from './spreadsheet-reader';
import * as path from 'path';
import * as fs from 'fs';

/**
 * Main function to demonstrate spreadsheet reading
 */
async function main() {
  try {
    // Create data directory if it doesn't exist
    const dataDir = path.join(__dirname, '..', 'data');
    if (!fs.existsSync(dataDir)) {
      fs.mkdirSync(dataDir, { recursive: true });
    }
    
    // Create sample files for testing
    const excelFilePath = path.join(dataDir, 'sample.xlsx');
    const csvFilePath = path.join(dataDir, 'sample.csv');
    
    console.log('Creating sample files for testing...');
    createSampleExcelFile(excelFilePath);
    createSampleCsvFile(csvFilePath);
    
    // Read Excel file
    console.log('\nReading Excel file...');
    const excelData = await readSpreadsheet(excelFilePath);
    
    // Display the results
    console.log('\nExcel Data:');
    displayWorksheetData(excelData);
    
    // Read CSV file
    console.log('\nReading CSV file...');
    const csvData = await readSpreadsheet(csvFilePath);
    
    // Display the results
    console.log('\nCSV Data:');
    displayWorksheetData(csvData);
    
    console.log('\nDone!');
  } catch (error) {
    console.error('Error:', error);
  }
}

/**
 * Display worksheet data in a readable format
 * 
 * @param worksheetDataArray - Array of worksheet data objects
 */
function displayWorksheetData(worksheetDataArray: WorksheetData[]) {
  worksheetDataArray.forEach(worksheetData => {
    console.log(`\nWorksheet: ${worksheetData.worksheet}`);
    console.log('Columns:', worksheetData.columns);
    
    console.log('Rows:');
    worksheetData.rows.forEach((row, index) => {
      console.log(`  Row ${index + 1}:`, row);
    });
    
    // Create a more readable representation with objects
    console.log('\nData as objects:');
    const objects = worksheetData.rows.map(row => {
      const obj: Record<string, any> = {};
      worksheetData.columns.forEach((col, i) => {
        obj[col] = row[i];
      });
      return obj;
    });
    
    objects.forEach((obj, index) => {
      console.log(`  Object ${index + 1}:`, obj);
    });
  });
}

// Run the example
main().catch(console.error);