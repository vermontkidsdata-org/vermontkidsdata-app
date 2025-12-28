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


def parse_worksheet_title(sheet_name):
    """
    Parse worksheet title to detect primary-only annotation and return clean name.
    
    Detects primary-only suppression in two ways:
    1. "- primary" (with dash): "Ethnicity by County - primary"
    2. Just "primary" (without dash): "Ethnicity by County primary"
    
    Args:
        sheet_name (str): Original worksheet name
        
    Returns:
        tuple: (clean_name, is_primary_only)
            clean_name: Sheet name with primary annotation stripped
            is_primary_only: Boolean indicating if primary-only suppression should be used
    """
    # Convert to string and strip whitespace
    name = str(sheet_name).strip()
    
    import re
    
    # First check for "- primary" pattern (with dash)
    # This pattern ensures "primary" is the last word after a dash
    dash_pattern = r'\s*-\s*primary\s*$'
    dash_match = re.search(dash_pattern, name, re.IGNORECASE)
    
    if dash_match:
        # Strip the "- primary" part and any trailing whitespace
        clean_name = name[:dash_match.start()].strip()
        return clean_name, True
    
    # Then check for just "primary" at the end (without dash)
    # Require at least two words before "primary" to avoid matching "Just primary"
    # This pattern matches: <word> <word>+ primary (at least 2 words before primary)
    word_pattern = r'^(.+\S\s+\S.*?)\s+primary\s*$'
    word_match = re.search(word_pattern, name, re.IGNORECASE)
    
    if word_match:
        # Extract the clean name (everything before the space+primary)
        clean_name = word_match.group(1).strip()
        return clean_name, True
    
    # No primary annotation found
    return name, False


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


def is_total_worksheet(worksheet_name):
    """
    Check if a worksheet is a "Total by <geography type>" worksheet.
    
    Args:
        worksheet_name (str): The name of the worksheet
        
    Returns:
        bool: True if the worksheet is a "Total by <geography type>" worksheet, False otherwise
    """
    return worksheet_name.lower().startswith("total by")


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
        column_name: The name of the column (can be string, datetime, float, or other type)
        
    Returns:
        str: The field name
    """
    # Handle datetime objects by converting to string format
    if isinstance(column_name, datetime):
        column_name_str = column_name.strftime('%Y-%m-%d %H:%M:%S')
    else:
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
        
        # Check if this is a "Total by <geography type>" worksheet
        if is_total_worksheet(sheet_name):
            # For "Total by <geography type>" worksheets, we expect the first column to be the geography
            # and the other columns to be dates
            print(f"Validating 'Total by <geography type>' worksheet: {sheet_name}")
            
            # Check if the first column contains geography values
            # This is a basic check - we just ensure it's not empty
            if df.iloc[:, 0].isnull().all():
                print(f"Error: First column in sheet '{sheet_name}' is empty", file=sys.stderr)
                return False
                
            # Handle both "AHSD" and "AHS District" variations
            first_col = df.columns[0]
            if first_col.lower() == "ahsd":
                # Rename to "AHS District" for consistency
                df.rename(columns={first_col: "AHS District"}, inplace=True)
                print(f"Renamed column '{first_col}' to 'AHS District' for consistency")
            elif first_col.lower() == "ahs district" and first_col != "AHS District":
                # Ensure consistent capitalization
                df.rename(columns={first_col: "AHS District"}, inplace=True)
                print(f"Renamed column '{first_col}' to 'AHS District' for consistent capitalization")
        
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
    valid_geo_types = ["state", "county", "ahs district", "ahsd"]
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


def generate_insert_statements_for_total_worksheet(sheet_name, value_df, suppressed_df, file_type):
    """
    Generate INSERT statements for a "Total by <geography type>" worksheet.
    
    Args:
        sheet_name (str): The name of the sheet
        value_df (pandas.DataFrame): The dataframe containing the values for the 'value' column
        suppressed_df (pandas.DataFrame): The dataframe containing the values for the 'value_suppressed' column
        file_type (str): The file type ("child" or "family")
        
    Returns:
        tuple: (insert_statements, table_name) - The INSERT statements and table name for the sheet
    """
    try:
        # Generate table name
        table_name = f"data_act76_{file_type}_total"
        
        # Extract geo_type from sheet name (the part after "by")
        geo_type = sheet_name.split("by")[1].strip().lower()
        if "county" in geo_type:
            geo_type = "county"
        elif "ahsd" in geo_type or "ahs district" in geo_type:
            geo_type = "AHS district"
            
        # Handle both "AHSD" and "AHS District" variations in the first column
        first_col = value_df.columns[0]
        if first_col.lower() == "ahsd":
            # Rename to "AHS District" for consistency
            value_df.rename(columns={first_col: "AHS District"}, inplace=True)
            suppressed_df.rename(columns={first_col: "AHS District"}, inplace=True)
            print(f"Renamed column '{first_col}' to 'AHS District' for consistency")
        elif first_col.lower() == "ahs district" and first_col != "AHS District":
            # Ensure consistent capitalization
            value_df.rename(columns={first_col: "AHS District"}, inplace=True)
            suppressed_df.rename(columns={first_col: "AHS District"}, inplace=True)
            print(f"Renamed column '{first_col}' to 'AHS District' for consistent capitalization")
        
        # Validate geo_type
        if not validate_geo_type(geo_type):
            print(f"Error: Invalid geo_type '{geo_type}' in sheet '{sheet_name}'", file=sys.stderr)
            sys.exit(1)  # Immediately halt processing on error
        
        # Initialize the list of INSERT statements
        insert_statements = []
        
        # Process each row
        for i, (_, value_row) in enumerate(value_df.iterrows()):
            # Get the corresponding row from the suppressed dataframe
            suppressed_row = suppressed_df.iloc[i]
            
            # Skip rows with no data
            if pd.isna(value_row.iloc[0]):
                continue
            
            # Get geography (first column)
            geography = value_row.iloc[0]
            
            # Skip rows with no geography
            if pd.isna(geography):
                continue
            
            # Process each date column (all columns except the first one)
            for col_idx in range(1, len(value_df.columns)):
                col = value_df.columns[col_idx]
                suppressed_col = suppressed_df.columns[col_idx]
                
                # Get the value for this column from both dataframes
                value = value_row[col]
                suppressed_value = suppressed_row[suppressed_col]
                
                # Skip if both values are NaN
                if pd.isna(value) and pd.isna(suppressed_value):
                    continue
                
                # Normalize the column header to handle datetime vs string
                if isinstance(col, datetime):
                    month_year = col
                else:
                    # Try to parse string as datetime, fallback to original if it fails
                    try:
                        month_year = pd.to_datetime(col)
                    except (ValueError, TypeError):
                        month_year = col
                
                # Extract month and year from month_year
                month, year = extract_month_year(month_year)
                
                # Format the value_suppressed
                formatted_suppressed_value = format_value_for_sql(suppressed_value)
                
                # If suppressed_value is "***", substitute -1
                if isinstance(suppressed_value, str) and suppressed_value == "***":
                    formatted_suppressed_value = "-1"
                
                # Ensure value_suppressed is a number
                if formatted_suppressed_value == "NULL" or formatted_suppressed_value == "''":
                    formatted_suppressed_value = "NULL"
                elif formatted_suppressed_value.startswith("'") and formatted_suppressed_value.endswith("'"):
                    # Try to convert string to number
                    try:
                        # Remove quotes and convert to float
                        num_value = float(formatted_suppressed_value[1:-1])
                        formatted_suppressed_value = str(num_value)
                    except (ValueError, TypeError):
                        # If conversion fails, use -1
                        formatted_suppressed_value = "-1"
                
                # Start building the INSERT statement
                insert = f"INSERT INTO `{table_name}` (`month_year`, `month`, `year`, `geo_type`, `geography`, `total`)\nVALUES\n"
                
                # Add values
                value_str = f"({format_value_for_sql(month_year)}, {format_value_for_sql(month)}, {format_value_for_sql(year)}, "
                value_str += f"{format_value_for_sql(geo_type)}, {format_value_for_sql(geography)}, {format_value_for_sql(value)})"
                
                # Complete the INSERT statement
                insert += value_str
                
                # Add ON DUPLICATE KEY UPDATE clause
                insert += " AS new_data\nON DUPLICATE KEY UPDATE "
                insert += "`month` = new_data.`month`, `year` = new_data.`year`, "
                insert += "`total` = new_data.`total`;"
                
                # Add to the list of INSERT statements
                insert_statements.append(insert)
        
        return insert_statements, table_name
    
    except Exception as e:
        print(f"Error generating INSERT statements for sheet '{sheet_name}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)  # Immediately halt processing on error


def generate_insert_statements_with_suppression(data_type, sheet_name, value_df, suppressed_df, file_type):
    """
    Generate INSERT statements for a sheet using values from two dataframes.
    
    Args:
        data_type (str): The data type
        sheet_name (str): The name of the sheet
        value_df (pandas.DataFrame): The dataframe containing the values for the 'value' column
        suppressed_df (pandas.DataFrame): The dataframe containing the values for the 'value_suppressed' column
        file_type (str): The file type ("child" or "family")
        
    Returns:
        tuple: (insert_statements, table_name) - The INSERT statements and table name for the sheet
    """
    try:
        # Check if this is a "Total by <geography type>" worksheet
        if is_total_worksheet(sheet_name):
            return generate_insert_statements_for_total_worksheet(sheet_name, value_df, suppressed_df, file_type)
        
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
        for i, (_, value_row) in enumerate(value_df.iterrows()):
            # Get the corresponding row from the suppressed dataframe
            suppressed_row = suppressed_df.iloc[i]
            
            # Skip rows with no data
            if pd.isna(value_row.iloc[0]) and pd.isna(value_row.iloc[1]):
                continue
            
            # Get month_year and geography
            month_year = value_row.iloc[0]
            geography = value_row.iloc[1]
            
            # Skip rows with no month_year or geography
            if pd.isna(month_year) or pd.isna(geography):
                continue
            
            # Create a key for grouping
            key = (month_year, geography)
            
            # Process each column (except month_year and geography)
            for col_idx in range(2, len(value_df.columns)):
                col = value_df.columns[col_idx]
                suppressed_col = suppressed_df.columns[col_idx]
                
                # Skip geography-specific columns like "County" or "AHS District"
                col_str = str(col).lower()
                if col_str not in ["county", "ahs district", "total"]:
                    # Get the value for this column from both dataframes
                    value = value_row[col]
                    suppressed_value = suppressed_row[suppressed_col]
                    
                    # Skip if both values are NaN
                    if pd.isna(value) and pd.isna(suppressed_value):
                        continue
                    
                    # Create a category value from the column name
                    category_value = str(col)
                    
                    # Add to grouped data
                    grouped_data[key].append((category_value, value, suppressed_value))
            
            # Add a row for the total if it exists
            total_col_idx = None
            for col_idx in range(2, len(value_df.columns)):
                col = value_df.columns[col_idx]
                if str(col).lower() == "total":
                    total_col_idx = col_idx
                    break
            
            if total_col_idx is not None:
                total_col = value_df.columns[total_col_idx]
                total_suppressed_col = suppressed_df.columns[total_col_idx]
                total_value = value_row[total_col]
                total_suppressed_value = suppressed_row[total_suppressed_col]
                if not (pd.isna(total_value) and pd.isna(total_suppressed_value)):
                    grouped_data[key].append(("total", total_value, total_suppressed_value))
            else:
                # Calculate total if it doesn't exist in the data
                value_sum = 0.0
                suppressed_sum = 0.0
                has_valid_values = False
                
                for col_idx in range(2, len(value_df.columns)):
                    col = value_df.columns[col_idx]
                    suppressed_col = suppressed_df.columns[col_idx]
                    col_str = str(col).lower()
                    if col_str not in ["county", "ahs district"]:
                        value = value_row[col]
                        suppressed_value = suppressed_row[suppressed_col]
                        
                        if not pd.isna(value):
                            try:
                                value_sum += float(value)
                                has_valid_values = True
                            except (ValueError, TypeError):
                                # Skip if value can't be converted to float
                                pass
                        
                        if not pd.isna(suppressed_value):
                            try:
                                suppressed_sum += float(suppressed_value)
                            except (ValueError, TypeError):
                                # Skip if value can't be converted to float
                                pass
                
                if has_valid_values:
                    grouped_data[key].append(("total", value_sum, suppressed_sum))
        
        # Generate INSERT statements for each group
        for (month_year, geography), values in grouped_data.items():
            # Extract month and year from month_year
            month, year = extract_month_year(month_year)
            
            # Start building the INSERT statement
            insert = f"INSERT INTO `{table_name}` (`month_year`, `month`, `year`, `geo_type`, `geography`, `{category_column}`, `value`, `value_suppressed`)\nVALUES\n"
            
            # Add values
            value_strings = []
            for category_value, value, suppressed_value in values:
                # Format the value_suppressed
                formatted_suppressed_value = format_value_for_sql(suppressed_value)
                
                # If suppressed_value is "***", substitute -1
                if isinstance(suppressed_value, str) and suppressed_value == "***":
                    formatted_suppressed_value = "-1"
                
                # Ensure value_suppressed is a number
                if formatted_suppressed_value == "NULL" or formatted_suppressed_value == "''":
                    formatted_suppressed_value = "NULL"
                elif formatted_suppressed_value.startswith("'") and formatted_suppressed_value.endswith("'"):
                    # Try to convert string to number
                    try:
                        # Remove quotes and convert to float
                        num_value = float(formatted_suppressed_value[1:-1])
                        formatted_suppressed_value = str(num_value)
                    except (ValueError, TypeError):
                        # If conversion fails, use -1
                        formatted_suppressed_value = "-1"
                
                value_str = f"({format_value_for_sql(month_year)}, {format_value_for_sql(month)}, {format_value_for_sql(year)}, "
                value_str += f"{format_value_for_sql(geo_type)}, {format_value_for_sql(geography)}, "
                value_str += f"{format_value_for_sql(category_value)}, {format_value_for_sql(value)}, {formatted_suppressed_value})"
                value_strings.append(value_str)
            
            # Join value strings with commas
            insert += ",\n".join(value_strings)
            
            # Add ON DUPLICATE KEY UPDATE clause
            insert += " AS new_data\nON DUPLICATE KEY UPDATE "
            insert += "`month` = new_data.`month`, `year` = new_data.`year`, "
            insert += "`value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;"
            
            # Add to the list of INSERT statements
            insert_statements.append(insert)
        
        return insert_statements, table_name
    
    except Exception as e:
        print(f"Error generating INSERT statements for sheet '{sheet_name}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)  # Immediately halt processing on error


def normalize_column_headers(columns):
    """
    Normalize column headers to handle both datetime objects and string representations.
    
    Args:
        columns: List or Index of column headers (can contain datetime objects or strings)
        
    Returns:
        list: Normalized column headers as strings
    """
    normalized = []
    for col in columns:
        if isinstance(col, datetime):
            # Convert datetime to string format YYYY-MM-DD HH:MM:SS
            normalized.append(col.strftime('%Y-%m-%d %H:%M:%S'))
        elif pd.api.types.is_datetime64_any_dtype(type(col)):
            # Handle pandas datetime types
            normalized.append(pd.to_datetime(col).strftime('%Y-%m-%d %H:%M:%S'))
        else:
            # Convert to string and handle existing string datetime formats
            col_str = str(col)
            try:
                # Try to parse as datetime and normalize format
                dt = pd.to_datetime(col_str)
                normalized.append(dt.strftime('%Y-%m-%d %H:%M:%S'))
            except (ValueError, TypeError):
                # If not a datetime string, keep as is
                normalized.append(col_str)
    return normalized


def validate_spreadsheets_structure(value_file_path, suppressed_file_path):
    """
    Validate that both spreadsheets have identical structure.
    
    Args:
        value_file_path (str): The path to the Excel file for 'value' column
        suppressed_file_path (str): The path to the Excel file for 'value_suppressed' column
        
    Returns:
        bool: True if both spreadsheets have identical structure, False otherwise
    """
    try:
        # Read both Excel files
        value_xls = pd.ExcelFile(value_file_path, engine='openpyxl')
        suppressed_xls = pd.ExcelFile(suppressed_file_path, engine='openpyxl')
        
        # Parse sheet names to get clean names (strip primary annotations)
        value_clean_names = {parse_worksheet_title(name)[0]: name for name in value_xls.sheet_names}
        suppressed_clean_names = {parse_worksheet_title(name)[0]: name for name in suppressed_xls.sheet_names}
        
        # Check if both spreadsheets have the same worksheets (comparing clean names)
        if set(value_clean_names.keys()) != set(suppressed_clean_names.keys()):
            print(f"Error: Spreadsheets have different worksheets (after stripping primary annotations)", file=sys.stderr)
            print(f"Value spreadsheet clean names: {list(value_clean_names.keys())}", file=sys.stderr)
            print(f"Suppressed spreadsheet clean names: {list(suppressed_clean_names.keys())}", file=sys.stderr)
            print(f"Value spreadsheet original names: {value_xls.sheet_names}", file=sys.stderr)
            print(f"Suppressed spreadsheet original names: {suppressed_xls.sheet_names}", file=sys.stderr)
            return False
        
        # Check each worksheet (using clean names for matching)
        for clean_name in value_clean_names.keys():
            value_sheet_name = value_clean_names[clean_name]
            suppressed_sheet_name = suppressed_clean_names[clean_name]
            
            print(f"Validating structure for sheet: '{value_sheet_name}' vs '{suppressed_sheet_name}' (clean name: '{clean_name}')")
            
            # Read both sheets
            value_df = pd.read_excel(value_xls, sheet_name=value_sheet_name)
            suppressed_df = pd.read_excel(suppressed_xls, sheet_name=suppressed_sheet_name)
            
            # Normalize column headers to handle datetime vs string differences
            value_columns_normalized = normalize_column_headers(value_df.columns)
            suppressed_columns_normalized = normalize_column_headers(suppressed_df.columns)
            
            # Check if both sheets have the same columns after normalization
            if value_columns_normalized != suppressed_columns_normalized:
                print(f"Error: Sheets '{value_sheet_name}' vs '{suppressed_sheet_name}' have different columns", file=sys.stderr)
                print(f"Value sheet columns: {value_df.columns.tolist()}", file=sys.stderr)
                print(f"Suppressed sheet columns: {suppressed_df.columns.tolist()}", file=sys.stderr)
                print(f"Value sheet normalized: {value_columns_normalized}", file=sys.stderr)
                print(f"Suppressed sheet normalized: {suppressed_columns_normalized}", file=sys.stderr)
                return False
            
            # Check if both sheets have the same number of rows
            if len(value_df) != len(suppressed_df):
                print(f"Error: Sheets '{value_sheet_name}' vs '{suppressed_sheet_name}' have different number of rows", file=sys.stderr)
                print(f"Value sheet rows: {len(value_df)}", file=sys.stderr)
                print(f"Suppressed sheet rows: {len(suppressed_df)}", file=sys.stderr)
                return False
            
            # Fill missing dates with the previous row's date for both sheets
            value_df.iloc[:, 0] = value_df.iloc[:, 0].ffill()
            suppressed_df.iloc[:, 0] = suppressed_df.iloc[:, 0].ffill()
            
            # Check if both sheets have the same month/years in corresponding rows
            for i in range(len(value_df)):
                if pd.notna(value_df.iloc[i, 0]) and pd.notna(suppressed_df.iloc[i, 0]):
                    value_month_year = value_df.iloc[i, 0]
                    suppressed_month_year = suppressed_df.iloc[i, 0]
                    
                    # Convert to string for comparison if they are datetime objects
                    if isinstance(value_month_year, datetime):
                        value_month_year = value_month_year.strftime('%Y-%m-%d')
                    if isinstance(suppressed_month_year, datetime):
                        suppressed_month_year = suppressed_month_year.strftime('%Y-%m-%d')
                    
                    if str(value_month_year) != str(suppressed_month_year):
                        print(f"Error: Sheets '{value_sheet_name}' vs '{suppressed_sheet_name}' have different month/years in row {i+1}", file=sys.stderr)
                        print(f"Value sheet month/year: {value_month_year}", file=sys.stderr)
                        print(f"Suppressed sheet month/year: {suppressed_month_year}", file=sys.stderr)
                        
                        # Print the entire row for better comparison
                        print("\nValue sheet row:", file=sys.stderr)
                        for col_idx, col_name in enumerate(value_df.columns):
                            print(f"  {col_name}: {value_df.iloc[i, col_idx]}", file=sys.stderr)
                        
                        print("\nSuppressed sheet row:", file=sys.stderr)
                        for col_idx, col_name in enumerate(suppressed_df.columns):
                            print(f"  {col_name}: {suppressed_df.iloc[i, col_idx]}", file=sys.stderr)
                        
                        return False
        
        return True
    
    except Exception as e:
        print(f"Error validating spreadsheets structure: {str(e)}", file=sys.stderr)
        traceback.print_exc()
        return False


def process_excel_files(value_file_path, suppressed_file_path):
    """
    Process two Excel files and generate INSERT statements using values from both.
    
    Special handling is provided for worksheets named "Total by <geography type>":
    1. These worksheets will be mapped to a table named "data_act76_<family or child>_total"
    2. For these worksheets, the first column is the geography itself
    3. The other column headers are dates
    4. Only one "data" column is generated, the total
    
    Args:
        value_file_path (str): The path to the Excel file for 'value' column
        suppressed_file_path (str): The path to the Excel file for 'value_suppressed' column
        
    Returns:
        tuple: (insert_statements, file_type, first_date, table_names)
            - insert_statements: The INSERT statements for all sheets
            - file_type: "child" or "family" based on the input filename
            - first_date: The date of the first record in YYYY-MM format
            - table_names: Set of table names that will be inserted into
    """
    # Determine file type (child or family) from the first file
    file_name = os.path.basename(value_file_path).lower()
    if "child" in file_name:
        file_type = "child"
    elif "family" in file_name:
        file_type = "family"
    else:
        print(f"Warning: Could not determine file type (child or family) from filename '{file_name}'", file=sys.stderr)
        file_type = "unknown"
    
    # Validate that both spreadsheets have identical structure
    if not validate_spreadsheets_structure(value_file_path, suppressed_file_path):
        print("Error: Spreadsheets do not have identical structure", file=sys.stderr)
        sys.exit(1)
    
    # Read all sheets from both Excel files
    try:
        print(f"Opening files: {value_file_path} and {suppressed_file_path}")
        value_xls = pd.ExcelFile(value_file_path, engine='openpyxl')
        suppressed_xls = pd.ExcelFile(suppressed_file_path, engine='openpyxl')
        
        print(f"Found sheets: {value_xls.sheet_names}")
        
        # Initialize the list of INSERT statements and set of table names
        insert_statements = []
        table_names = set()
        
        # Variable to store the first date found
        first_date = None
        
        # Parse sheet names to get clean names for matching
        value_clean_names = {parse_worksheet_title(name)[0]: name for name in value_xls.sheet_names}
        suppressed_clean_names = {parse_worksheet_title(name)[0]: name for name in suppressed_xls.sheet_names}
        
        # Process each sheet (using clean names for matching)
        for clean_name in value_clean_names.keys():
            value_sheet_name = value_clean_names[clean_name]
            suppressed_sheet_name = suppressed_clean_names[clean_name]
            
            print(f"Processing sheet: '{value_sheet_name}' vs '{suppressed_sheet_name}' (clean name: '{clean_name}')")
            
            # Read both sheets
            value_df = pd.read_excel(value_xls, sheet_name=value_sheet_name)
            suppressed_df = pd.read_excel(suppressed_xls, sheet_name=suppressed_sheet_name)
            
            # Validate sheet format (use clean name for validation)
            if not validate_sheet_format(clean_name, value_df):
                print(f"Error: Sheet '{value_sheet_name}' in value file has invalid format", file=sys.stderr)
                sys.exit(1)
            
            if not validate_sheet_format(clean_name, suppressed_df):
                print(f"Error: Sheet '{suppressed_sheet_name}' in suppressed file has invalid format", file=sys.stderr)
                sys.exit(1)
            
            # Fill missing dates with the previous row's date
            value_df.iloc[:, 0] = value_df.iloc[:, 0].ffill()
            suppressed_df.iloc[:, 0] = suppressed_df.iloc[:, 0].ffill()
            
            # If this is the first sheet and we haven't found a date yet, get the date from the first row
            if first_date is None and not value_df.empty and not pd.isna(value_df.iloc[0, 0]):
                # Get the date from the first row
                date_value = value_df.iloc[0, 0]
                
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
            
            # Extract data type from clean sheet name
            data_type = extract_data_type(clean_name)
            
            # Generate INSERT statements for the sheet using both dataframes (use clean name)
            sheet_inserts, table_name = generate_insert_statements_with_suppression(data_type, clean_name, value_df, suppressed_df, file_type)
            
            # Add the table name to our set
            table_names.add(table_name)
            
            # Add the sheet INSERT statements to the overall list
            insert_statements.extend(sheet_inserts)
        
        # If we still don't have a date, use a default
        if first_date is None:
            first_date = "unknown-date"
            
        return insert_statements, file_type, first_date, table_names
    
    except Exception as e:
        print(f"Error processing files '{value_file_path}' and '{suppressed_file_path}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        return [], file_type, "unknown-date", set()


def generate_insert_statements(data_type, sheet_name, df, file_type):
    """
    Generate INSERT statements for a sheet.
    This function is kept for backward compatibility.
    
    Args:
        data_type (str): The data type
        sheet_name (str): The name of the sheet
        df (pandas.DataFrame): The dataframe containing the sheet data
        file_type (str): The file type ("child" or "family")
        
    Returns:
        list: The INSERT statements for the sheet
    """
    try:
        # Create a dummy suppressed dataframe with the same structure as df
        # but with NULL values for the value_suppressed column
        suppressed_df = df.copy()
        for col in suppressed_df.columns:
            if col not in [df.columns[0], df.columns[1]]:  # Keep month_year and geography columns
                suppressed_df[col] = None
        
        # Generate INSERT statements using the new function
        return generate_insert_statements_with_suppression(data_type, sheet_name, df, suppressed_df, file_type)
    
    except Exception as e:
        print(f"Error generating INSERT statements for sheet '{sheet_name}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)  # Immediately halt processing on error


def process_excel_file(file_path):
    """
    Process an Excel file and generate INSERT statements for each row in each sheet.
    This function is kept for backward compatibility.
    
    Args:
        file_path (str): The path to the Excel file
        
    Returns:
        tuple: (insert_statements, file_type, first_date)
            - insert_statements: The INSERT statements for all sheets
            - file_type: "child" or "family" based on the input filename
            - first_date: The date of the first record in YYYY-MM format
    """
    print(f"Warning: Using backward compatibility mode with NULL values for value_suppressed column")
    print(f"For full functionality, provide both value and suppressed spreadsheets")
    
    # Create a temporary copy of the file to use as the suppressed file
    try:
        # Process the Excel file using the new function
        return process_excel_files(file_path, file_path)
    
    except Exception as e:
        print(f"Error processing file '{file_path}': {str(e)}", file=sys.stderr)
        traceback.print_exc()
        file_type = "unknown"
        file_name = os.path.basename(file_path).lower()
        if "child" in file_name:
            file_type = "child"
        elif "family" in file_name:
            file_type = "family"
        return [], file_type, "unknown-date", set()


def main():
    """
    Main function to parse command line arguments and process the Excel files.
    """
    parser = argparse.ArgumentParser(description="Generate MySQL INSERT statements from Excel spreadsheets")
    parser.add_argument("value_xlsx_file", help="Path to the Excel file for 'value' column")
    parser.add_argument("suppressed_xlsx_file", help="Path to the Excel file for 'value_suppressed' column")
    args = parser.parse_args()
    
    # Check if the files exist
    if not os.path.isfile(args.value_xlsx_file):
        print(f"Error: File '{args.value_xlsx_file}' does not exist", file=sys.stderr)
        sys.exit(1)
    
    if not os.path.isfile(args.suppressed_xlsx_file):
        print(f"Error: File '{args.suppressed_xlsx_file}' does not exist", file=sys.stderr)
        sys.exit(1)
    
    print(f"Starting to process files: {args.value_xlsx_file} and {args.suppressed_xlsx_file}")
    
    # Process the Excel files
    insert_statements, file_type, first_date, table_names = process_excel_files(args.value_xlsx_file, args.suppressed_xlsx_file)
    
    # Extract fiscal year and optional quarter from the original file name
    file_name = os.path.basename(args.value_xlsx_file)
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
        print(f"\nWriting TRUNCATE and {len(insert_statements)} INSERT statements to {output_file}")
        with open(output_file, "w") as f:
            # Add a header comment
            f.write(f"-- TRUNCATE and INSERT statements for {os.path.basename(args.value_xlsx_file)} and {os.path.basename(args.suppressed_xlsx_file)}\n")
            f.write(f"-- Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            # Write TRUNCATE statements for all tables
            f.write("-- TRUNCATE TABLE statements\n")
            for table_name in sorted(table_names):
                f.write(f"TRUNCATE TABLE `{table_name}`;\n")
            f.write("\n")
            
            # Write each INSERT statement
            f.write("-- INSERT statements\n")
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