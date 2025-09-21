"""
Author: Fitz Koch
Created: 2025-07-19
Description: A script to suppress data in worksheets (one sheet at a time)
Notes: 
    * always run the script as a whole, don't access functions with imports
    * run the script with -h to see options
    * always quote file names
    * first filename = input, second filename=output
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
from datetime import datetime
from pathlib import Path


def load_as_dict(path):
    return pd.read_excel(path, engine='openpyxl', sheet_name=None)

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

## carry forward date columns for easier separation
def forward_date(df):
    df["Month.Year"]= df['Month.Year'].ffill()
    keep_cols = df.columns.difference(['Month.Year'])
    df = df.dropna(subset=keep_cols, how='all')
    return df

## primary engine for secondary suppression
def secondary_suppression(df, key_var='County'):

    ## remove the totals as we don't want to suppress them.
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
def iterative_supression(group, count, key_var):
    total_count = 0
    while True:
        df, count = secondary_suppression(group, key_var)
        group = group.astype(object)
        group.update(df)
        total_count += count
        if count == 0:
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
def suppress_blocks(df, key_var, threshold):
    f.write(f'Suppressing {key_var}\n')
    blocks = []
    count, pcount = 0, 0 
    for _, group in df.groupby("Month.Year"):
        workgroup = group.copy()
        workgroup, t_pcount = primary_suppression(workgroup, threshold)
        workgroup, t_count = iterative_supression(workgroup, 10, key_var)
        blocks.append(workgroup)
        count += t_count
        pcount += t_pcount
    return pd.concat(blocks), count, pcount 


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
    dfs = load_as_dict(args.inputfile)
    dfs = {name: forward_date(df) for name, df in dfs.items()}
    
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
                for name, df in dfs.items():
                    try:
                        f.write(f"Starting {name}...\n")

                        # Check if "State" is in the dataframe columns, otherwise use the original logic
                        if "State" in df.columns:
                            key_var = "State"
                        else:
                            key_var = "County" if "County" in name else "AHS District"
                        f.write(f"Starting {name} : Threshold = {args.threshold}, key_var = {key_var}\n")

                        df, count, pcount = suppress_blocks(df, key_var, args.threshold)

                        f.write(f"{name} : Primary Suppressed {pcount}, Secondary Suppressed {count}. Threshold = {args.threshold}, key_var = {key_var}\n")

                        df = df.assign(
                            is_vermont=df[key_var].eq("Vermont")
                        ).sort_values(
                            by=['Month.Year', 'is_vermont', key_var],
                            ascending=(False, True, True)
                        ).drop(columns='is_vermont')

                        df.to_excel(writer, sheet_name=name, index=False)
                        processed_count += 1
                    except Exception as e:
                        f.write(f"Error processing sheet {name}: {str(e)}\n")
                        print(f"Error processing sheet {name}: {str(e)}")
                
                # If no sheets were successfully processed, create a dummy sheet
                if processed_count == 0:
                    pd.DataFrame({'Note': ['No data could be processed']}).to_excel(writer, sheet_name='Info', index=False)
                    print("Warning: Created an Info sheet because no data sheets could be processed")