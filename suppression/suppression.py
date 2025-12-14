"""
Author: Fitz Koch
Created: 2025-07-19
Modified: 2025-12-14 (Added primary-only suppression support)
Description: A script to suppress data in worksheets (one sheet at a time)
Notes:
    * always run the script as a whole, don't access functions with imports
    * run the script with -h to see options
    * always quote file names
    * first filename = input, second filename=output
    * to perform only primary suppression on a worksheet, add "primary" to the worksheet title
      (case insensitive, tolerant of spacing). Examples:
      - "Ethnicity by County - primary" (with dash)
      - "Ethnicity by County primary" (without dash)
    * the primary annotation will be stripped from the output worksheet name
    *example usage: python src/suppression.py "child.xlsx" "clean_child.xlsx" -p "PRIM" -s "SEC"
        *python
        *script name
        * input file in quotes
        * output file in quotes
        * -p flag to set the string for primary suppression (default=***)
        * -s flag to set the string for secondary suppression
"""

import pandas as pd
import pulp
import numpy as np
import argparse
import logging
import os
from datetime import datetime
from pathlib import Path

# Set up logging to file
debug_log_path = os.path.abspath('debug-suppression.log')
logging.basicConfig(
    filename=debug_log_path,
    filemode='w',
    format='%(asctime)s - %(levelname)s - %(message)s',
    level=logging.DEBUG
)
logger = logging.getLogger('suppression')

# Print message about debug log location
print(f"Debug logs are being written to: {debug_log_path}")


def load_as_dict(path):
    return pd.read_excel(path, engine='openpyxl', sheet_name=None)

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

## replace all cells with P_SUPP value if suppressed
def primary_suppression(df, threshold):
    num_cols = df.select_dtypes(include=[np.number]).columns
    df[num_cols] = df[num_cols].astype(object)
    df_suppressed = df.copy()
    df_suppressed[num_cols] = df_suppressed[num_cols].astype(object)
    suppressed_count = 0

    for col in num_cols:
        def suppress(x):
            nonlocal suppressed_count
            if pd.isna(x) or x > threshold:
                return x
            else:
                suppressed_count += 1
                return P_SUPP

        df_suppressed[col] = df[col].apply(suppress)

    return df_suppressed, suppressed_count

## check if a sheet is a "Total by <geography type>" worksheet
def is_total_worksheet(sheet_name):
    return sheet_name.lower().startswith("total by")

## carry forward date columns for easier separation
def forward_date(df, sheet_name=""):
    logger.debug(f"Before forward_date: shape={df.shape}, duplicated rows={df.duplicated().sum()}")
    
    # Check if this is a "Total by <geography type>" worksheet
    if is_total_worksheet(sheet_name):
        # For "Total by <geography type>" worksheets, there's no 'Month.Year' column to forward-fill
        # The first column is the geography itself
        logger.debug(f"Skipping forward_date for 'Total by' worksheet: {sheet_name}")
        # Just drop rows where all columns (except the first) are NA
        first_col = df.columns[0]
        keep_cols = df.columns.difference([first_col])
        df = df.dropna(subset=keep_cols, how='all')
    else:
        # For regular worksheets, forward-fill the 'Month.Year' column
        df["Month.Year"]= df['Month.Year'].ffill()
        keep_cols = df.columns.difference(['Month.Year'])
        df = df.dropna(subset=keep_cols, how='all')
    
    logger.debug(f"After forward_date: shape={df.shape}, duplicated rows={df.duplicated().sum()}")
    if df.duplicated().sum() > 0:
        logger.warning("Duplicated rows found after forward_date!")
        logger.warning(df[df.duplicated(keep=False)].sort_values(by=df.columns.tolist()).to_string())
    return df

## primary engine for secondary suppression
def secondary_suppression(df, key_var='County', sheet_name=""):
    ## remove the totals as we don't want to suppress them.
    # Check if this is a "Total by <geography type>" worksheet
    if is_total_worksheet(sheet_name):
        # For "Total by <geography type>" worksheets, the first column is the geography
        # Handle both "AHSD" and "AHS District" variations
        if key_var.lower() == "ahs district":
            if "AHSD" in df.columns:
                key_var = "AHSD"
            elif "AHS District" not in df.columns and df.columns[0].lower() == "ahsd":
                # If the first column is "ahsd" (case insensitive), use that
                key_var = df.columns[0]
        elif key_var.lower() == "ahsd":
            if "AHS District" in df.columns:
                key_var = "AHS District"
            elif "AHSD" not in df.columns and df.columns[0].lower() == "ahs district":
                # If the first column is "ahs district" (case insensitive), use that
                key_var = df.columns[0]
        
        # For debugging
        print(f"Using key_var: '{key_var}' for sheet: '{sheet_name}'")
        print(f"Available columns: {list(df.columns)}")
        
        # Make sure key_var is actually in the dataframe columns
        if key_var not in df.columns:
            # Try to find a matching column (case insensitive)
            for col in df.columns:
                if col.lower() == key_var.lower():
                    key_var = col
                    print(f"Found matching column: '{key_var}'")
                    break
            else:
                # If no match found, use the first column as a fallback
                key_var = df.columns[0]
                print(f"No matching column found for '{key_var}', using first column: '{key_var}'")
        
        id_cols = [key_var]  # Use key_var instead of df.columns[0]
        supp_cols = [col for col in df.columns.difference(id_cols) if col != "Total"]
    else:
        # For regular worksheets
        id_cols = ["Month.Year"] + [key_var]
        supp_cols = [col for col in df.columns.difference(id_cols) if col != "Total"]

    ## setup problem and df to work in
    suppress_df = df.loc[df[key_var] != 'Vermont', supp_cols]
    suppress_vars = {}
    prob = pulp.LpProblem("SecondarySuppression", pulp.LpMinimize)

    ## setup variables (and constants for previously suppressed)
    for i in suppress_df.index:
        for j in suppress_df.columns:
            val = suppress_df.at[i, j]
            if val == P_SUPP or val == S_SUPP:
                suppress_vars[(i, j)] = 1
            else:
                suppress_vars[(i, j)] = pulp.LpVariable(f"supp_{i}_{j}", cat='Binary')

    prob += pulp.lpSum([v for v in suppress_vars.values() if isinstance(v, pulp.LpVariable)])
    
    # Row constraints: at least 2 suppressions if any present
    for i in suppress_df.index:
        if any(suppress_df.loc[i].astype(str).isin([P_SUPP, S_SUPP])):
            prob += pulp.lpSum([
                suppress_vars.get((i, j), 1) for j in supp_cols
            ]) >= 2

    # Column constraints
    for j in supp_cols:
        if any(suppress_df[j].astype(str).isin([P_SUPP, S_SUPP])):
            prob += pulp.lpSum([
                suppress_vars.get((i, j), 1) for i in suppress_df.index
            ]) >= 2

    ## solve and merge to new df
    prob.solve(pulp.PULP_CBC_CMD(msg=False))
    final_df, count=  apply_suppression(suppress_df, suppress_vars)
    return final_df, count


## iterate suppressing until a round of suppressing fails to suppress
def iterative_supression(group, count, key_var, sheet_name=""):
    logger.debug(f"Before iterative_supression: shape={group.shape}, duplicated rows={group.duplicated().sum()}")
    total_count = 0
    iteration = 0
    while True:
        iteration += 1
        logger.debug(f"Iteration {iteration} start")
        df, count = secondary_suppression(group, key_var, sheet_name)
        logger.debug(f"After secondary_suppression: shape={df.shape}, duplicated rows={df.duplicated().sum()}")
        group = group.astype(object)
        group.update(df)
        logger.debug(f"After update: shape={group.shape}, duplicated rows={group.duplicated().sum()}")
        total_count += count
        if count == 0:
            logger.debug(f"After iterative_supression: shape={group.shape}, duplicated rows={group.duplicated().sum()}")
            if group.duplicated().sum() > 0:
                logger.warning("WARNING: Duplicated rows found after iterative_supression!")
                logger.warning(group[group.duplicated(keep=False)].sort_values(by=group.columns.tolist()).to_string())
            return group, total_count

def apply_suppression(df, suppress):
    count = 0

    # Get columns to be suppressed and convert to object type
    cols_to_suppress = {j for (i, j), var in suppress.items() if isinstance(var, pulp.LpVariable) and pulp.value(var) == 1}
    df = df.copy()
    df[list(cols_to_suppress)] = df[list(cols_to_suppress)].astype(object)

    for (i, j), var in suppress.items():
        if isinstance(var, pulp.LpVariable) and pulp.value(var) == 1:
            df.loc[i, j] = S_SUPP
            count += 1
    return df, count

## iterate through all the date blocks as we want to suppress within them
def suppress_blocks(df, key_var, threshold, sheet_name="", primary_only=False):
    f.write(f'Suppressing {key_var} (primary_only={primary_only})\n')
    logger.debug(f"Before suppress_blocks: shape={df.shape}, duplicated rows={df.duplicated().sum()}")
    blocks = []
    count, pcount = 0, 0
    
    # Check if this is a "Total by <geography type>" worksheet
    if is_total_worksheet(sheet_name):
        # For "Total by <geography type>" worksheets, there's no Month.Year column
        # Process the entire dataframe as a single group
        logger.debug(f"\nProcessing 'Total by' worksheet: {sheet_name}")
        logger.debug(f"DataFrame shape: {df.shape}, duplicated rows={df.duplicated().sum()}")
        
        # Handle both "AHSD" and "AHS District" variations
        if key_var.lower() == "ahs district":
            if "AHSD" in df.columns:
                key_var = "AHSD"
            elif "AHS District" not in df.columns and df.columns[0].lower() == "ahsd":
                # If the first column is "ahsd" (case insensitive), use that
                key_var = df.columns[0]
        elif key_var.lower() == "ahsd":
            if "AHS District" in df.columns:
                key_var = "AHS District"
            elif "AHSD" not in df.columns and df.columns[0].lower() == "ahs district":
                # If the first column is "ahs district" (case insensitive), use that
                key_var = df.columns[0]
        
        # For debugging
        print(f"Using key_var: '{key_var}' for sheet: '{sheet_name}'")
        print(f"Available columns: {list(df.columns)}")
        
        # Make sure key_var is actually in the dataframe columns
        if key_var not in df.columns:
            # Try to find a matching column (case insensitive)
            for col in df.columns:
                if col.lower() == key_var.lower():
                    key_var = col
                    print(f"Found matching column: '{key_var}'")
                    break
            else:
                # If no match found, use the first column as a fallback
                key_var = df.columns[0]
                print(f"No matching column found for '{key_var}', using first column: '{key_var}'")
            
        workgroup = df.copy()
        logger.debug(f"After copy: shape={workgroup.shape}, duplicated rows={workgroup.duplicated().sum()}")
        workgroup, t_pcount = primary_suppression(workgroup, threshold)
        pcount += t_pcount
        logger.debug(f"After primary_suppression: shape={workgroup.shape}, duplicated rows={workgroup.duplicated().sum()}")
        
        # Only perform secondary suppression if not primary_only
        if not primary_only:
            workgroup, t_count = iterative_supression(workgroup, 0, key_var, sheet_name)
            count += t_count
            logger.debug(f"After iterative_supression: shape={workgroup.shape}, duplicated rows={workgroup.duplicated().sum()}")
        else:
            logger.debug(f"Skipping secondary suppression for primary-only sheet: {sheet_name}")
        
        blocks.append(workgroup)
    else:
        # For regular worksheets, group by Month.Year
        for month_year, group in df.groupby("Month.Year"):
            logger.debug(f"\nProcessing Month.Year: {month_year}")
            logger.debug(f"Group shape: {group.shape}, duplicated rows={group.duplicated().sum()}")
            workgroup = group.copy()
            logger.debug(f"After copy: shape={workgroup.shape}, duplicated rows={workgroup.duplicated().sum()}")
            workgroup, t_pcount = primary_suppression(workgroup, threshold)
            pcount += t_pcount
            logger.debug(f"After primary_suppression: shape={workgroup.shape}, duplicated rows={workgroup.duplicated().sum()}")
            
            # Only perform secondary suppression if not primary_only
            if not primary_only:
                workgroup, t_count = iterative_supression(workgroup, 0, key_var, sheet_name)
                count += t_count
                logger.debug(f"After iterative_supression: shape={workgroup.shape}, duplicated rows={workgroup.duplicated().sum()}")
            else:
                logger.debug(f"Skipping secondary suppression for primary-only sheet: {sheet_name}")
            
            blocks.append(workgroup)
    
    result = pd.concat(blocks)
    logger.debug(f"After pd.concat: shape={result.shape}, duplicated rows={result.duplicated().sum()}")
    if result.duplicated().sum() > 0:
        logger.warning("WARNING: Duplicated rows found after concat!")
        logger.warning(result[result.duplicated(keep=False)].sort_values(by=result.columns.tolist()).to_string())
    return result, count, pcount


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Suppression Script")

    ## flagged arguments
    default_log = f"{datetime.now():%Y-%m-%d}_suppression"
    parser.add_argument('-l', '--log', default=default_log, help='The .log filename with path, EG: suppression_date.log')
    parser.add_argument('-t', '--threshold', default=10, type=int, help="The threshold below which (inclusive) to suppress the data")
    parser.add_argument('-p',  '--primary', default="***", type=str, help="The string to indicate primary suppression cells")
    parser.add_argument('-s',  '--secondary', default="***", type=str, help="The string to indicate secondary suppression cells")

    ## required positional arguments
    parser.add_argument('inputfile', help='Input filename  with path')
    parser.add_argument('outputfile', help='Output filename with path')
    args = parser.parse_args() 

    ## set logfile to append to
    if args.log == default_log:
        input_stem = Path(args.inputfile).stem
        logfile = f"{args.log} for {input_stem}.log"
    else:
        logfile = args.log

    P_SUPP = args.primary
    S_SUPP = args.secondary

    ## begin loading -> suppression -> output loop
    logger.info(f"Loading file: {args.inputfile}")
    dfs = load_as_dict(args.inputfile)
    logger.info(f"Loaded {len(dfs)} sheets: {list(dfs.keys())}")
    
    # Log shape of each dataframe before forward_date
    for name, df in dfs.items():
        logger.debug(f"\nSheet {name} before forward_date: shape={df.shape}, duplicated rows={df.duplicated().sum()}")
        print(f"Sheet {name} initial row count: {df.shape[0]}")
    
    # Store row counts before forward_date for comparison
    before_forward_counts = {name: df.shape[0] for name, df in dfs.items()}
    
    dfs = {name: forward_date(df, name) for name, df in dfs.items()}
    
    # Check if forward_date removed any rows
    for name, df in dfs.items():
        if df.shape[0] != before_forward_counts[name]:
            logger.warning(f"forward_date() changed row count in {name}: {before_forward_counts[name]} -> {df.shape[0]}")
            print(f"Note: forward_date() changed row count in {name}: {before_forward_counts[name]} -> {df.shape[0]}")
    
    # Log shape of each dataframe after forward_date
    for name, df in dfs.items():
        logger.debug(f"Sheet {name} after forward_date: shape={df.shape}, duplicated rows={df.duplicated().sum()}")
    
    # Check if there are any dataframes to process
    if not dfs:
        print(f"Error: No sheets found in {args.inputfile}")
        exit(1)
        
    with open(logfile, 'w') as f:
            f.write(f"Data from file: {args.inputfile} \n-----------\n")
            
            # Create a dummy sheet if needed to ensure at least one sheet is visible
            with pd.ExcelWriter(args.outputfile, engine='openpyxl') as writer:
                # Process each dataframe
                processed_count = 0
                for original_name, df in dfs.items():
                    try:
                        # Parse worksheet title to check for primary-only annotation
                        clean_name, is_primary_only = parse_worksheet_title(original_name)
                        
                        f.write(f"Starting {original_name}...\n")
                        if is_primary_only:
                            f.write(f"  -> Detected primary-only suppression for sheet: {original_name}\n")
                            f.write(f"  -> Using clean name for processing: {clean_name}\n")
                            print(f"Processing '{original_name}' with PRIMARY-ONLY suppression (output: '{clean_name}')")
                        else:
                            print(f"Processing '{original_name}' with full suppression (primary + secondary)")

                        # Check if "State" is in the dataframe columns, otherwise use the original logic
                        if "State" in df.columns:
                            key_var = "State"
                        else:
                            # Determine key_var based on sheet name
                            if "county" in name.lower():
                                key_var = "County"
                            elif "ahsd" in name.lower() or "ahs district" in name.lower():
                                # Check if "AHSD" or "AHS District" is in the dataframe columns
                                if "AHSD" in df.columns:
                                    key_var = "AHSD"
                                elif "AHS District" in df.columns:
                                    key_var = "AHS District"
                                else:
                                    # Use the first column as a fallback
                                    key_var = df.columns[0]
                                    print(f"Using first column as key_var: '{key_var}'")
                            else:
                                key_var = "County"  # Default to County
                        f.write(f"Starting {clean_name} : Threshold = {args.threshold}, key_var = {key_var}, primary_only = {is_primary_only}\n")

                        df, count, pcount = suppress_blocks(df, key_var, args.threshold, clean_name, is_primary_only)

                        if is_primary_only:
                            f.write(f"{clean_name} : Primary Suppressed {pcount} (secondary suppression skipped). Threshold = {args.threshold}, key_var = {key_var}\n")
                            print(f"  -> '{clean_name}': Primary suppressed {pcount} values (secondary suppression skipped)")
                        else:
                            f.write(f"{clean_name} : Primary Suppressed {pcount}, Secondary Suppressed {count}. Threshold = {args.threshold}, key_var = {key_var}\n")
                            print(f"  -> '{clean_name}': Primary suppressed {pcount}, Secondary suppressed {count} values")

                        # Check if this is a "Total by <geography type>" worksheet (use clean name)
                        if is_total_worksheet(clean_name):
                            # For "Total by <geography type>" worksheets, sort by geography only
                            df = df.assign(
                                is_vermont=df[key_var].eq("Vermont")
                            ).sort_values(
                                by=['is_vermont', key_var],
                                ascending=(True, True)
                            ).drop(columns='is_vermont')
                        else:
                            # For regular worksheets, sort by Month.Year, is_vermont, and key_var
                            df = df.assign(
                                is_vermont=df[key_var].eq("Vermont")
                            ).sort_values(
                                by=['Month.Year', 'is_vermont', key_var],
                                ascending=(False, True, True)
                            ).drop(columns='is_vermont')

                        # Use clean name for the output sheet name
                        df.to_excel(writer, sheet_name=clean_name, index=False)
                        processed_count += 1
                    except Exception as e:
                        f.write(f"Error processing sheet {original_name}: {str(e)}\n")
                        print(f"Error processing sheet {original_name}: {str(e)}")
                
                # If no sheets were successfully processed, create a dummy sheet
                if processed_count == 0:
                    pd.DataFrame({'Note': ['No data could be processed']}).to_excel(writer, sheet_name='Info', index=False)
                    print("Warning: Created an Info sheet because no data sheets could be processed")