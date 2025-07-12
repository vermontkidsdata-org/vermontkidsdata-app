#!/usr/bin/env ts-node
import { readSpreadsheet, WorksheetData } from '../src/spreadsheet-reader';
import * as path from 'path';
import * as fs from 'fs';

/**
 * Simple command-line argument parser
 */
function parseArgs() {
  const args = process.argv.slice(2);
  const result: {
    file?: string;
    sheet?: string;
    format?: 'json' | 'table' | 'csv';
    output?: string;
    help?: boolean;
  } = {
    format: 'json'
  };

  // Parse arguments
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    
    if (arg === '--file' || arg === '-f') {
      result.file = args[++i];
    } else if (arg === '--sheet' || arg === '-s') {
      result.sheet = args[++i];
    } else if (arg === '--format') {
      const format = args[++i];
      if (['json', 'table', 'csv'].includes(format)) {
        result.format = format as 'json' | 'table' | 'csv';
      } else {
        console.error(`Invalid format: ${format}. Using default: json`);
      }
    } else if (arg === '--output' || arg === '-o') {
      result.output = args[++i];
    } else if (arg === '--help' || arg === '-h') {
      result.help = true;
    }
  }

  return result;
}

/**
 * Display help message
 */
function showHelp() {
  console.log(`
Usage: npx ts-node scripts/read-spreadsheet.ts --file <path> [options]

Options:
  --file, -f       Path to the spreadsheet file (required)
  --sheet, -s      Specific worksheet name to read (if not specified, all worksheets will be read)
  --format         Output format: json, table, csv (default: json)
  --output, -o     Output file path (if not specified, output will be printed to console)
  --help, -h       Show this help message

Examples:
  npx ts-node scripts/read-spreadsheet.ts --file data/example.xlsx
  npx ts-node scripts/read-spreadsheet.ts --file data/example.csv --format table
  npx ts-node scripts/read-spreadsheet.ts --file data/example.xlsx --sheet Sheet1 --output result.json
  `);
}

/**
 * Main function
 */
async function main() {
  // Parse command line arguments
  const argv = parseArgs();
  
  // Show help if requested or if no file is specified
  if (argv.help || !argv.file) {
    showHelp();
    process.exit(argv.help ? 0 : 1);
  }
  try {
    // Resolve the file path (handle relative paths)
    const filePath = path.resolve(argv.file);
    
    // Check if file exists
    if (!fs.existsSync(filePath)) {
      console.error(`Error: File not found: ${filePath}`);
      process.exit(1);
    }
    
    console.log(`Reading spreadsheet: ${filePath}`);
    
    // Read the spreadsheet
    const worksheetDataArray = await readSpreadsheet(filePath);
    
    // Filter to specific worksheet if requested
    let result: WorksheetData[] = worksheetDataArray;
    if (argv.sheet) {
      result = worksheetDataArray.filter(data => data.worksheet === argv.sheet);
      if (result.length === 0) {
        console.error(`Error: Worksheet "${argv.sheet}" not found in the spreadsheet.`);
        console.log(`Available worksheets: ${worksheetDataArray.map(data => data.worksheet).join(', ')}`);
        process.exit(1);
      }
    }
    
    // Format the output
    let output: string;
    switch (argv.format) {
      case 'json':
        output = formatAsJson(result);
        break;
      case 'table':
        output = formatAsTable(result);
        break;
      case 'csv':
        output = formatAsCsv(result);
        break;
      default:
        output = formatAsJson(result);
    }
    
    // Output the result
    if (argv.output) {
      const outputPath = path.resolve(argv.output);
      fs.writeFileSync(outputPath, output);
      console.log(`Output written to: ${outputPath}`);
    } else {
      console.log(output);
    }
    
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

/**
 * Format worksheet data as JSON
 */
function formatAsJson(worksheetDataArray: WorksheetData[]): string {
  return JSON.stringify(worksheetDataArray, null, 2);
}

/**
 * Format worksheet data as ASCII table
 */
function formatAsTable(worksheetDataArray: WorksheetData[]): string {
  let output = '';
  
  worksheetDataArray.forEach(worksheetData => {
    output += `\n=== Worksheet: ${worksheetData.worksheet} ===\n\n`;
    
    // Calculate column widths
    const columnWidths = worksheetData.columns.map((col, index) => {
      // Start with the column header length
      let maxWidth = col.length;
      
      // Check all values in this column
      worksheetData.rows.forEach(row => {
        const cellValue = String(row[index] ?? '');
        maxWidth = Math.max(maxWidth, cellValue.length);
      });
      
      // Add some padding
      return Math.min(maxWidth + 2, 40); // Cap at 40 chars
    });
    
    // Create header row
    let headerRow = '| ';
    let separator = '+-';
    
    worksheetData.columns.forEach((col, index) => {
      const width = columnWidths[index];
      headerRow += col.padEnd(width) + ' | ';
      separator += '-'.repeat(width) + '-+-';
    });
    
    // Output the header
    output += separator + '\n';
    output += headerRow + '\n';
    output += separator + '\n';
    
    // Output each row
    worksheetData.rows.forEach(row => {
      let rowOutput = '| ';
      
      row.forEach((cell, index) => {
        const width = columnWidths[index];
        const cellValue = String(cell ?? '');
        rowOutput += cellValue.padEnd(width) + ' | ';
      });
      
      output += rowOutput + '\n';
    });
    
    // Close the table
    output += separator + '\n\n';
  });
  
  return output;
}

/**
 * Format worksheet data as CSV
 */
function formatAsCsv(worksheetDataArray: WorksheetData[]): string {
  let output = '';
  
  worksheetDataArray.forEach(worksheetData => {
    // Add worksheet name as a comment
    output += `# Worksheet: ${worksheetData.worksheet}\n`;
    
    // Add header row
    output += worksheetData.columns.map(escapeCSV).join(',') + '\n';
    
    // Add data rows
    worksheetData.rows.forEach(row => {
      output += row.map(cell => escapeCSV(cell)).join(',') + '\n';
    });
    
    // Add a blank line between worksheets
    output += '\n';
  });
  
  return output;
}

/**
 * Escape a value for CSV output
 */
function escapeCSV(value: any): string {
  if (value === null || value === undefined) {
    return '';
  }
  
  const str = String(value);
  
  // If the value contains a comma, newline, or double quote, wrap it in quotes
  if (str.includes(',') || str.includes('\n') || str.includes('"')) {
    // Replace any double quotes with two double quotes
    return `"${str.replace(/"/g, '""')}"`;
  }
  
  return str;
}

// Run the script
main().catch(console.error);