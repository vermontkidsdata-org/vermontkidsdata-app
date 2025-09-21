#!/usr/bin/env python3
"""
Script to generate MySQL INSERT statements from Excel spreadsheets.
Takes an XLSX filename as a command line argument and generates INSERT statements
for each row in each sheet of the file.

The script validates the worksheet format and generates one INSERT statement per row.
The output is written to a file named "act76-XXXX-data.sql", where XXXX is either
"child" or "family" based on the input filename.
"""

import argparse
import os
import re
import pandas as pd
import sys
import traceback
from datetime import datetime
from collections import defaultdict


def extract_month_year(date_value):
    """
    Extract month and year from a date value.
    
    Args:
        date_value: The date value (can be string, datetime, or other format)
        
    Returns:
        tuple: (month, year) as integers
    """
    try:
        # If it's already a datetime object
        if isinstance(date_value, datetime):
            return date_value.month, date_value.year
        
        # Try to parse as a datetime
        try:
            date_obj = pd.to_datetime(date_value)
            return date_obj.month, date_obj.year
        except:
            # If parsing fails, try to extract from string formats like "6/1/2023"
            if isinstance(date_value, str):
                parts = date_value.split('/')
                if len(parts) >= 2:
                    month = int(parts[0])
                    # Year might be in the third position or second position
                    year = int(parts[2]) if len(parts) > 2 else int(parts[1])
                    return month, year
            
            # If all else fails, return None values
            print(f"Warning: Could not extract month and year from '{date_value}'", file=sys.stderr)
            return None, None
    except Exception as e:
        print(f"Error extracting month and year from '{date_value}': {str(e)}", file=sys.stderr)
        return None, None


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


def data_type_to_table_name(data_type, file_type):
    """
    Convert a data type to a table name.
    
    The table name should be "data_act76_{file_type}" plus the data type,
    turned to lower-snake-case with any special characters not legal in table names removed.
    Replace "%" with "pct".
    
    Args:
        data_type (str): The data type
        file_type (str): The file type ("child" or "family")
        
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
    
    # Prefix with "data_act76_{file_type}_"
    return f"data_act76_{file_type}_{name_part}"


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
        sys.exit(1)  # Immediately halt processing on error


def validate_geo_type(geo_type):
    """
    Validate that the geo_type is one of the allowed values.
    
    Args:
        geo_type (str): The geo_type to validate
        
    Returns:
        bool: True if the geo_type is valid, False otherwise
    """
    valid_geo_types = ["state", "county", "ahs district"]
    return geo_type.lower() in valid_geo_types


def format_value_for_sql(value):
    """
    Format a value for use in an SQL INSERT statement.
    
    Args:
        value: The value to format
        
    Returns:
        str: The formatted value
    """
    if pd.isna(value):
        return "NULL"
    elif isinstance(value, (int, float)):
        return str(value)
    elif isinstance(value, datetime):
        return f"'{value.strftime('%Y-%m-%d')}'"
    else:
        # Escape single quotes in string values
        return f"'{str(value).replace('\'', '\'\'')}'"


def generate_insert_statements(data_type, sheet_name, df, file_type):
    """
    Generate INSERT statements for a sheet.
    
    Args:
        data_type (str): The data type
        sheet_name (str): The name of the sheet
        df (pandas.DataFrame): The dataframe containing the sheet data
        file_type (str): The file type ("child" or "family")
        
    Returns:
        list: The INSERT statements for the sheet
    """
    try:
        # Generate table name
        table_name = data_type_to_table_name(data_type, file_type)
        
        # Determine geo_type from sheet name
        if "county" in sheet_name.lower():
            geo_type = "county"
        elif "ahsd" in sheet_name.lower() or "ahs district" in sheet_name.lower():
            geo_type = "AHS district"
        else:
            geo_type = "unknown"
        
        # Validate geo_type
        if not validate_geo_type(geo_type):
            print(f"Error: Invalid geo_type '{geo_type}' in sheet '{sheet_name}'", file=sys.stderr)
            sys.exit(1)  # Immediately halt processing on error
        
        # Initialize the list of INSERT statements
        insert_statements = []
        
        # Get the category column name based on data_type
        category_column = data_type.lower().replace(" ", "_").replace("%", "pct")
        
        # Group rows by month_year and geography
        grouped_data = defaultdict(list)
        
        # Process each row
        for _, row in df.iterrows():
            # Skip rows with no data
            if pd.isna(row.iloc[0]) and pd.isna(row.iloc[1]):
                continue
            
            # Get month_year and geography
            month_year = row.iloc[0]
            geography = row.iloc[1]
            
            # Skip rows with no month_year or geography
            if pd.isna(month_year) or pd.isna(geography):
                continue
            
            # Create a key for grouping
            key = (month_year, geography)
            
            # Process each column (except month_year and geography)
            for col in df.columns[2:]:
                # Skip geography-specific columns like "County" or "AHS District"
                col_str = str(col).lower()
                if col_str not in ["county", "ahs district", "total"]:
                    # Get the value for this column
                    value = row[col]
                    
                    # Skip if value is NaN
                    if pd.isna(value):
                        continue
                    
                    # Create a category value from the column name
                    category_value = str(col)
                    
                    # Add to grouped data
                    grouped_data[key].append((category_value, value))
            
            # Add a row for the total if it exists
            total_col = None
            for col in df.columns[2:]:
                if str(col).lower() == "total":
                    total_col = col
                    break
            
            if total_col is not None:
                total_value = row[total_col]
                if not pd.isna(total_value):
                    grouped_data[key].append(("total", total_value))
            else:
                # Calculate total if it doesn't exist in the data
                value_sum = 0.0
                has_valid_values = False
                
                for col in df.columns[2:]:
                    col_str = str(col).lower()
                    if col_str not in ["county", "ahs district"]:
                        value = row[col]
                        if not pd.isna(value):
                            try:
                                value_sum += float(value)
                                has_valid_values = True
                            except (ValueError, TypeError):
                                # Skip if value can't be converted to float
                                pass
                
                if has_valid_values:
                    grouped_data[key].append(("total", value_sum))
        
        # Generate INSERT statements for each group
        for (month_year, geography), values in grouped_data.items():
            # Extract month and year from month_year
            month, year = extract_month_year(month_year)
            
            # Start building the INSERT statement
            insert = f"INSERT INTO `{table_name}` (`month_year`, `month`, `year`, `geo_type`, `geography`, `{category_column}`, `value`, `value_suppressed`)\nVALUES\n"
            
            # Add values
            value_strings = []
            for category_value, value in values:
                value_str = f"({format_value_for_sql(month_year)}, {format_value_for_sql(month)}, {format_value_for_sql(year)}, "
                value_str += f"{format_value_for_sql(geo_type)}, {format_value_for_sql(geography)}, "
                value_str += f"{format_value_for_sql(category_value)}, {format_value_for_sql(value)}, NULL)"
                value_strings.append(value_str)
            
            # Join value strings with commas
            insert += ",\n".join(value_strings)
            
            # Add ON DUPLICATE KEY UPDATE clause
            insert += " AS new_data\nON DUPLICATE KEY UPDATE "
            insert += "`month` = new_data.`month`, `year` = new_data.`year`, "
            insert += "`value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;"
            
            # Add to the list of INSERT statements
            insert_statements.append(insert)
        
        return insert_statements
    
    except Exception as e:
        print(f"Error generating INSERT statements for sheet '{sheet_name}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)  # Immediately halt processing on error


def process_excel_file(file_path):
    """
    Process an Excel file and generate INSERT statements for each row in each sheet.
    
    Args:
        file_path (str): The path to the Excel file
        
    Returns:
        tuple: (insert_statements, file_type, first_date)
            - insert_statements: The INSERT statements for all sheets
            - file_type: "child" or "family" based on the input filename
            - first_date: The date of the first record in YYYY-MM format
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
        
        # Initialize the list of INSERT statements
        insert_statements = []
        
        # Variable to store the first date found
        first_date = None
        
        # Process each sheet
        for sheet_name in xls.sheet_names:
            print(f"Processing sheet: {sheet_name}")
            
            # Read the sheet
            df = pd.read_excel(xls, sheet_name=sheet_name)
            
            # Validate sheet format
            if not validate_sheet_format(sheet_name, df):
                print(f"Error: Sheet '{sheet_name}' has invalid format", file=sys.stderr)
                sys.exit(1)  # Immediately halt processing on error
            
            # Fill missing dates with the previous row's date
            df.iloc[:, 0] = df.iloc[:, 0].ffill()
            
            # If this is the first sheet and we haven't found a date yet, get the date from the first row
            if first_date is None and not df.empty and not pd.isna(df.iloc[0, 0]):
                # Get the date from the first row
                date_value = df.iloc[0, 0]
                
                # Format the date as YYYY-MM
                if isinstance(date_value, datetime):
                    first_date = date_value.strftime('%Y-%m')
                else:
                    # Try to parse the date if it's not already a datetime object
                    try:
                        first_date = pd.to_datetime(date_value).strftime('%Y-%m')
                    except:
                        print(f"Warning: Could not parse date from first record: {date_value}", file=sys.stderr)
                        first_date = "unknown-date"
            
            # Extract data type from sheet name
            data_type = extract_data_type(sheet_name)
            
            # Generate INSERT statements for the sheet
            sheet_inserts = generate_insert_statements(data_type, sheet_name, df, file_type)
            
            # Add the sheet INSERT statements to the overall list
            insert_statements.extend(sheet_inserts)
        
        # If we still don't have a date, use a default
        if first_date is None:
            first_date = "unknown-date"
            
        return insert_statements, file_type, first_date
    
    except Exception as e:
        print(f"Error processing file '{file_path}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        return [], file_type


def main():
    """
    Main function to parse command line arguments and process the Excel file.
    """
    parser = argparse.ArgumentParser(description="Generate MySQL INSERT statements from Excel spreadsheets")
    parser.add_argument("xlsx_file", help="Path to the Excel file")
    args = parser.parse_args()
    
    # Check if the file exists
    if not os.path.isfile(args.xlsx_file):
        print(f"Error: File '{args.xlsx_file}' does not exist", file=sys.stderr)
        sys.exit(1)
    
    print(f"Starting to process file: {args.xlsx_file}")
    
    # Process the Excel file
    insert_statements, file_type, first_date = process_excel_file(args.xlsx_file)
    
    # Extract fiscal year and optional quarter from the original file name
    file_name = os.path.basename(args.xlsx_file)
    fy_match = re.search(r'SFY\s*(\d+)(?:\s*Q(\d+))?', file_name, re.IGNORECASE)
    
    if fy_match:
        fiscal_year = fy_match.group(1)
        quarter = fy_match.group(2)
        
        # Generate output filename with fiscal year and optional quarter in the scripts directory
        if quarter:
            output_file = f"scripts/act76-{file_type}-data-fy{fiscal_year}-q{quarter}.sql"
        else:
            output_file = f"scripts/act76-{file_type}-data-fy{fiscal_year}.sql"
    else:
        # Fallback to using the date of the first record if FY not found
        print(f"Warning: Could not extract fiscal year from filename '{file_name}', using date from first record instead", file=sys.stderr)
        output_file = f"scripts/act76-{file_type}-data-{first_date}.sql"
    
    # Write the INSERT statements to the output file
    if insert_statements:
        print(f"\nWriting {len(insert_statements)} INSERT statements to {output_file}")
        with open(output_file, "w") as f:
            # Add a header comment
            f.write(f"-- INSERT statements for {os.path.basename(args.xlsx_file)}\n")
            f.write(f"-- Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            # Write each INSERT statement
            for insert in insert_statements:
                f.write(f"{insert}\n")
        
        print(f"Successfully wrote {len(insert_statements)} INSERT statements to {output_file}")
        
        # Print a sample of the INSERT statements
        print("\nSample INSERT statements:")
        for i, insert in enumerate(insert_statements[:5]):
            print(insert)
            if i >= 4:
                if len(insert_statements) > 5:
                    print(f"... ({len(insert_statements) - 5} more)")
                break
    else:
        print("No INSERT statements were generated.")


if __name__ == "__main__":
    main()