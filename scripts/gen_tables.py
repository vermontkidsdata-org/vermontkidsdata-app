#!/usr/bin/env python3
"""
Script to generate MySQL DDL statements from Excel spreadsheets.
Takes an XLSX filename as a command line argument and generates DDL statements
for each sheet in the file.

The script creates a single table for each type of data (the part of the worksheet name
before "by"). For example, if there are worksheets "Family Size by County" and
"Family Size by AHSD", they will both be mapped to a single table "data_act76_family_size".

The output is written to a file named "act76-XXXX-tables.sql", where XXXX is either
"child" or "family" based on the input filename.
"""

import argparse
import os
import re
import pandas as pd
import sys
import traceback
from collections import defaultdict


def extract_data_type(worksheet_name):
    """
    Extract the data type from a worksheet name (the part before "by").
    
    Args:
        worksheet_name (str): The name of the worksheet
        
    Returns:
        str: The data type
        
    Raises:
        ValueError: If the worksheet name does not contain "by"
    """
    # Check if the worksheet name contains "by"
    if "by" not in worksheet_name.lower():
        raise ValueError(f"Worksheet name '{worksheet_name}' does not contain 'by'")
    
    # Get the part before "by"
    return worksheet_name.split("by")[0].strip()


def data_type_to_table_name(data_type):
    """
    Convert a data type to a table name.
    
    The table name should be "data_act76" plus the data type,
    turned to lower-snake-case with any special characters not legal in table names removed.
    Replace "%" with "pct".
    
    Args:
        data_type (str): The data type
        
    Returns:
        str: The table name
    """
    # Replace "%" with "pct"
    name_part = data_type.replace("%", "pct")
    
    # Convert to lower case
    name_part = name_part.lower()
    
    # Replace spaces and special characters with underscores
    name_part = re.sub(r'[^a-z0-9_]', '_', name_part)
    
    # Replace multiple underscores with a single underscore
    name_part = re.sub(r'_+', '_', name_part)
    
    # Remove leading and trailing underscores
    name_part = name_part.strip('_')
    
    # Prefix with "data_act76_"
    return f"data_act76_{name_part}"


def column_to_field_name(column_name):
    """
    Convert a column name to a field name.
    
    The field name should be prefixed with "value_" and follow the same rules
    as the table name conversion.
    
    Args:
        column_name: The name of the column (can be string, float, or other type)
        
    Returns:
        str: The field name
    """
    # Convert to string to handle non-string column names (like floats)
    column_name_str = str(column_name)
    
    # Replace "%" with "pct"
    name_part = column_name_str.replace("%", "pct")
    
    # Convert to lower case
    name_part = name_part.lower()
    
    # Replace spaces and special characters with underscores
    name_part = re.sub(r'[^a-z0-9_]', '_', name_part)
    
    # Replace multiple underscores with a single underscore
    name_part = re.sub(r'_+', '_', name_part)
    
    # Remove leading and trailing underscores
    name_part = name_part.strip('_')
    
    # Prefix with "value_"
    return f"value_{name_part}"


def validate_sheet_format(sheet_name, df):
    """
    Validate that the sheet has the expected format.
    
    Args:
        sheet_name (str): The name of the sheet
        df (pandas.DataFrame): The dataframe containing the sheet data
        
    Returns:
        bool: True if the sheet has the expected format, False otherwise
    """
    try:
        # Check if the sheet has at least 2 columns
        if len(df.columns) < 2:
            print(f"Error: Sheet '{sheet_name}' has less than 2 columns", file=sys.stderr)
            return False
        
        # Extract data type from sheet name
        extract_data_type(sheet_name)
        
        return True
    
    except ValueError as e:
        print(f"Error validating sheet '{sheet_name}': {str(e)}", file=sys.stderr)
        return False


def generate_ddl_for_data_type(data_type, sheets_data, file_type):
    """
    Generate DDL statements for a data type.
    
    Args:
        data_type (str): The data type
        sheets_data (list): List of tuples (sheet_name, dataframe)
        file_type (str): The file type ("child" or "family")
        
    Returns:
        str: The DDL statements for the data type
    """
    try:
        # Generate table name with file type included
        table_name = f"data_act76_{file_type}_{data_type_to_table_name(data_type).replace('data_act76_', '')}"
        
        # Collect worksheet names for this data type
        worksheet_names = [sheet_name for sheet_name, _ in sheets_data]
        worksheet_list = ", ".join(f"'{name}'" for name in worksheet_names)
        
        # Start building the DDL
        ddl = f"-- DDL for {data_type}\n"
        ddl += f"-- Source worksheets: {worksheet_list}\n"
        ddl += f"CREATE TABLE IF NOT EXISTS `{table_name}` (\n"
        
        # Add id column
        ddl += "  `id` INT AUTO_INCREMENT,\n"
        
        # Add month_year column
        ddl += "  `month_year` VARCHAR(255),\n"
        
        # Add month and year columns
        ddl += "  `month` INT COMMENT 'Month (1-12)',\n"
        ddl += "  `year` INT COMMENT 'Year (e.g., 2023)',\n"
        
        # Add geo_type column
        ddl += "  `geo_type` VARCHAR(50),\n"
        
        # Add geography column
        ddl += "  `geography` VARCHAR(255),\n"
        
        # Get all unique column names from all sheets for this data type
        all_columns = set()
        for _, df in sheets_data:
            # Skip the first column (month_year) and the geography column
            for col in df.columns[2:]:
                # Skip geography-specific columns like "County" or "AHS District"
                # Convert column name to string to handle non-string column names (like floats)
                col_str = str(col).lower()
                if col_str not in ["county", "ahs district"]:
                    # Store the original column name, not the string version
                    all_columns.add(col)
        
        # Convert all column names to strings for sorting
        all_columns_str = [str(col) for col in all_columns]
        
        # Sort columns for consistent output
        all_columns_str = sorted(all_columns_str)
        
        # Add category column based on data_type
        category_column = data_type.lower().replace(" ", "_").replace("%", "pct")
        ddl += f"  `{category_column}` VARCHAR(100) COMMENT 'Category value (e.g., infant, white, hispanic)',\n"
        
        # Add value and value_suppressed columns
        ddl += "  `value` DOUBLE COMMENT 'The actual count/number',\n"
        ddl += "  `value_suppressed` DOUBLE COMMENT 'Suppressed version of the value',\n"
        
        # Add primary key
        ddl += "  PRIMARY KEY (`id`),\n"
        
        # Add unique key that includes the category column
        ddl += f"  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`, `{category_column}`),\n"
        
        # Add index on month and year for better query performance
        ddl += "  INDEX `idx_month_year` (`year`, `month`)\n"
        
        # Close the DDL
        ddl += ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\n\n"
        
        return ddl
    
    except Exception as e:
        print(f"Error generating DDL for data type '{data_type}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)  # Immediately halt processing on error


def process_excel_file(file_path):
    """
    Process an Excel file and generate DDL statements for each data type.
    
    Args:
        file_path (str): The path to the Excel file
        
    Returns:
        tuple: (ddl_statements, file_type)
            - ddl_statements: The DDL statements for all data types
            - file_type: "child" or "family" based on the input filename
    """
    # Determine file type (child or family)
    file_name = os.path.basename(file_path).lower()
    if "child" in file_name:
        file_type = "child"
    elif "family" in file_name:
        file_type = "family"
    else:
        print(f"Warning: Could not determine file type (child or family) from filename '{file_name}'", file=sys.stderr)
        file_type = "unknown"
    
    # Read all sheets from the Excel file
    try:
        print(f"Opening file: {file_path}")
        xls = pd.ExcelFile(file_path, engine='openpyxl')
        
        print(f"Found sheets: {xls.sheet_names}")
        
        # Initialize the DDL
        ddl = f"-- DDL for {os.path.basename(file_path)}\n\n"
        
        # Group sheets by data type
        data_types = defaultdict(list)
        
        # First pass: validate all sheets and group by data type
        for sheet_name in xls.sheet_names:
            print(f"Processing sheet: {sheet_name}")
            
            # Read the sheet
            df = pd.read_excel(xls, sheet_name=sheet_name)
            
            # Print column names for debugging
            print(f"Sheet '{sheet_name}' has columns: {df.columns.tolist()}")
            
            # Validate sheet format
            if not validate_sheet_format(sheet_name, df):
                print(f"Skipping sheet '{sheet_name}' due to validation errors", file=sys.stderr)
                continue
            
            # Fill missing dates with the previous row's date
            df.iloc[:, 0] = df.iloc[:, 0].ffill()
            
            # Extract data type from sheet name
            data_type = extract_data_type(sheet_name)
            
            # Add to the appropriate group
            data_types[data_type].append((sheet_name, df))
        
        # Second pass: generate DDL for each data type
        for data_type, sheets_data in data_types.items():
            print(f"Generating DDL for data type: {data_type}")
            
            # Generate DDL for the data type
            data_type_ddl = generate_ddl_for_data_type(data_type, sheets_data, file_type)
            
            # Add the data type DDL to the overall DDL
            ddl += data_type_ddl
        
        return ddl, file_type
    
    except Exception as e:
        print(f"Error processing file '{file_path}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)  # Immediately halt processing on error


def main():
    """
    Main function to parse command line arguments and process the Excel file.
    """
    parser = argparse.ArgumentParser(description="Generate MySQL DDL statements from Excel spreadsheets")
    parser.add_argument("xlsx_file", help="Path to the Excel file")
    args = parser.parse_args()
    
    # Check if the file exists
    if not os.path.isfile(args.xlsx_file):
        print(f"Error: File '{args.xlsx_file}' does not exist", file=sys.stderr)
        sys.exit(1)
    
    print(f"Starting to process file: {args.xlsx_file}")
    
    # Process the Excel file
    ddl, file_type = process_excel_file(args.xlsx_file)
    
    # Generate output filename in the scripts directory
    output_file = f"scripts/act76-{file_type}-tables.sql"
    
    # Write the DDL to the output file
    if ddl:
        print(f"\nWriting DDL statements to {output_file}")
        with open(output_file, "w") as f:
            f.write(ddl)
        print(f"Successfully wrote DDL statements to {output_file}")
        
        # Also print the DDL to the console
        print("\nGenerated DDL statements:")
        print(ddl)
    else:
        print("No DDL statements were generated.")


if __name__ == "__main__":
    main()