import re
import pandas as pd
import os
import numpy as np
import glob
from scipy.optimize import linprog

def primary_suppress(values):
    """
    Apply primary suppression: values between 1 and 9 become '*'.
    Values of 0 are not suppressed.
    """
    return ['*' if (isinstance(v, (int, float)) and 1 <= v < 10) else v for v in values]

def secondary_suppress_row(values, total=None):
    """
    Apply secondary suppression for a row.
    If exactly one value is primary suppressed, suppress the smallest non-suppressed value.
    """
    # Apply primary suppression first
    suppressed = primary_suppress(values)
    
    # Count primary suppressed values
    primary_suppressed_count = suppressed.count('*')
    
    # If exactly one value is suppressed, apply secondary suppression
    if primary_suppressed_count == 1:
        # Find numeric values (non-suppressed)
        numeric_values = [v for v in values if isinstance(v, (int, float)) and v >= 10]
        
        if numeric_values:
            # Find the smallest non-suppressed value
            min_val = min(numeric_values)
            
            # Replace one instance of the smallest value with '*'
            new_suppressed = []
            replaced = False
            for i, (orig, sup) in enumerate(zip(values, suppressed)):
                if not replaced and sup != '*' and isinstance(orig, (int, float)) and orig == min_val:
                    new_suppressed.append('*')
                    replaced = True
                else:
                    new_suppressed.append(sup)
            
            return new_suppressed
    
    return suppressed

def apply_column_secondary_suppression(df, date_col=None, geo_col=None, category_cols=None):
    """
    Apply column-level secondary suppression.
    For each column with exactly one primary suppressed value, suppress the smallest non-suppressed value.
    """
    # Make a copy to avoid modifying the original
    result_df = df.copy()
    
    # For each data column
    for col in category_cols:
        # Get the column values
        col_values = df[col].tolist()
        
        # Count primary suppressed values
        primary_suppressed = col_values.count('*')
        
        # If exactly one value is suppressed, apply secondary suppression
        if primary_suppressed == 1:
            # Find numeric values (non-suppressed)
            numeric_indices = [i for i, v in enumerate(col_values) 
                              if v != '*' and isinstance(v, (int, float)) and v >= 10]
            
            if numeric_indices:
                # Find the smallest non-suppressed value
                numeric_values = [col_values[i] for i in numeric_indices]
                min_val = min(numeric_values)
                
                # Find the index of the smallest value
                min_idx = col_values.index(min_val)
                
                # Replace with '*'
                result_df.at[min_idx, col] = '*'
    
    return result_df

def process_excel_file_with_suppression(file_path):
    """
    Process Excel file to create CSV files with the same shape as the original worksheets,
    but with both primary and secondary suppression applied.
    """
    # Extract year and quarter from the file name
    base_file_name = os.path.basename(file_path)
    match = re.search(r"SFY\s*(\d+\s*(?:Q\d+)?)", base_file_name, re.IGNORECASE)
    year_quarter = match.group(1).strip().lower().replace(' ', '_') if match else "unknown"
    
    # Read the Excel file
    xls = pd.ExcelFile(file_path)
    
    for sheet_name in xls.sheet_names:
        # Read the worksheet
        df = pd.read_excel(xls, sheet_name=sheet_name)
        
        # Fill missing dates with the previous row's date
        df.iloc[:, 0] = df.iloc[:, 0].ffill()
        
        # Create a copy for suppression
        df_suppressed = df.copy()
        
        # Apply primary suppression to all numeric cells in data columns (columns 2+)
        for i, row in df.iterrows():
            data_values = row.iloc[2:].tolist()
            suppressed_values = primary_suppress(data_values)
            df_suppressed.iloc[i, 2:] = suppressed_values
        
        # Apply row-level secondary suppression
        for i, row in df_suppressed.iterrows():
            data_values = row.iloc[2:].tolist()
            if '*' in data_values:  # Only process rows with primary suppression
                suppressed_values = secondary_suppress_row(data_values)
                df_suppressed.iloc[i, 2:] = suppressed_values
        
        # Apply column-level secondary suppression
        data_cols = df_suppressed.columns[2:]
        df_suppressed = apply_column_secondary_suppression(
            df_suppressed, 
            date_col=df_suppressed.columns[0], 
            geo_col=df_suppressed.columns[1], 
            category_cols=data_cols
        )
        
        # Generate snake_cased worksheet name
        sheet_snake = sheet_name.strip().lower().replace(' ', '_')
        csv_file_name = f"ccfap_child_data_{year_quarter}_{sheet_snake}.csv"
        csv_file_path = os.path.join('data', csv_file_name)
        
        # Write CSV preserving original shape
        df_suppressed.to_csv(csv_file_path, index=False)

def process_excel_file_transformed(file_path):
    """
    Process Excel file to create transformed CSV files (one row per data field)
    with both row-level and column-level secondary suppression.
    """
    # Read the Excel file
    xls = pd.ExcelFile(file_path)
    
    for sheet_name in xls.sheet_names:
        # Determine geography type from sheet name
        geo_type = 'county' if 'county' in sheet_name.lower() else 'AHSD'
        
        # Read the worksheet
        df = pd.read_excel(xls, sheet_name=sheet_name)
        
        # Fill missing dates with the previous row's date
        df.iloc[:, 0] = df.iloc[:, 0].ffill()
        
        # Prepare output rows
        output_rows = []
        
        # Process each row
        for index, row in df.iterrows():
            date = row.iloc[0].strftime('%Y-%m')
            geography = row.iloc[1]
            data_values = row.iloc[2:].tolist()
            
            # Apply primary suppression
            suppressed_values = primary_suppress(data_values)
            
            # Create output rows
            for col, value in zip(df.columns[2:], suppressed_values):
                category = col
                output_rows.append([geo_type, geography, date, category, value])
        
        # Create totals rows
        dates = df.iloc[:, 0].dt.strftime('%Y-%m').unique()
        for date in dates:
            df_date = df[df.iloc[:, 0].dt.strftime('%Y-%m') == date]
            totals = df_date.iloc[:, 2:].sum()
            
            # Apply primary suppression to totals
            suppressed_totals = primary_suppress(totals.tolist())
            
            for col, value in zip(df.columns[2:], suppressed_totals):
                output_rows.append(['state', 'Vermont', date, col, value])
        
        # Convert to DataFrame
        output_df = pd.DataFrame(output_rows, columns=['geo type', 'geography', 'year', 'category', 'value'])
        
        # Apply row-level secondary suppression
        # Group by geography and date
        for (geo, geog, yr), group in output_df.groupby(['geo type', 'geography', 'year']):
            # Get indices for this group
            indices = group.index
            values = group['value'].tolist()
            
            # Skip if no primary suppression
            if '*' not in values:
                continue
                
            # Apply secondary suppression
            suppressed = secondary_suppress_row(values)
            
            # Update the DataFrame
            for idx, val in zip(indices, suppressed):
                output_df.at[idx, 'value'] = val
        
        # Apply column-level secondary suppression
        # Group by category and date
        for (cat, yr), group in output_df.groupby(['category', 'year']):
            # Skip if state row is suppressed
            state_row = group[group['geo type'] == 'state']
            if state_row.empty or state_row.iloc[0]['value'] == '*':
                continue
                
            # Get non-state rows
            non_state = group[group['geo type'] != 'state']
            
            # Count primary suppressed values
            primary_suppressed = (non_state['value'] == '*').sum()
            
            # If exactly one value is suppressed, apply secondary suppression
            if primary_suppressed == 1:
                # Find the smallest non-suppressed value
                numeric_rows = non_state[non_state['value'] != '*']
                if not numeric_rows.empty:
                    # Convert values to numeric
                    numeric_rows = numeric_rows.copy()
                    numeric_rows['numeric_value'] = pd.to_numeric(numeric_rows['value'], errors='coerce')
                    
                    # Find the smallest value (excluding zeros)
                    non_zero_rows = numeric_rows[numeric_rows['numeric_value'] > 0]
                    if not non_zero_rows.empty:
                        min_idx = non_zero_rows['numeric_value'].idxmin()
                        # Suppress this value
                        output_df.at[min_idx, 'value'] = '*'
        
        # Write to CSV
        csv_file_name = f"ccfap_child_{sheet_name.replace(' ', '_').lower()}.csv"
        csv_file_path = os.path.join('data', csv_file_name)
        
        if os.path.exists(csv_file_path):
            output_df.to_csv(csv_file_path, mode='a', header=False, index=False)
        else:
            output_df.to_csv(csv_file_path, mode='w', header=True, index=False)

def find_excel_files():
    """
    Find all Excel files in the data directory that match the pattern:
    - Start with "Act 76"
    - End with "SFY" followed by a year or year and quarter
    """
    # Pattern to match: Act 76 ... SFY <year> [Q<quarter>]
    pattern = os.path.join('data', 'Act 76*SFY*.xlsx')
    
    # Find all matching files
    files = glob.glob(pattern)
    
    # If no files found, try the sample file as fallback
    if not files:
        sample_file = os.path.join('data', 'Sample - Act 76 Child Demo Breakdown by County and AHS District SFY 25 Q2.xlsx')
        if os.path.exists(sample_file):
            files = [sample_file]
    
    return files

if __name__ == "__main__":
    # Find all matching Excel files
    excel_files = find_excel_files()
    
    # Process each Excel file
    for excel_file in excel_files:
        print(f"Processing file: {excel_file}")
        
        # Process Excel file to create CSV files with the same shape as the original worksheets
        process_excel_file_with_suppression(excel_file)
        
        # Process Excel file to create transformed CSV files
        process_excel_file_transformed(excel_file)