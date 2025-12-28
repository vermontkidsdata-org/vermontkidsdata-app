#!/usr/bin/env python3
"""
suppression.py

Implements primary + secondary suppression for tabular counts.

Rules (as clarified):
- Primary suppression: any cell <= threshold is suppressed (P_SUPP), INCLUDING:
    - Detail cells (e.g., age group by county/district)
    - Vermont row cells
    - Total column cells
- Secondary suppression is applied to protect primary suppressions.
- Detail cells:
    - For any ROW with >=1 primary suppressed detail cell:
        (1) at least 2 suppressed cells in that row (primary+secondary)
        (2) suppressed mass (sum of suppressed numeric values in that row) >= threshold,
            but only if primary_sum < threshold
    - For any COLUMN with >=1 primary suppressed detail cell:
        (1) at least 2 suppressed cells in that column (primary+secondary)
        (2) suppressed mass in that column >= threshold, but only if primary_sum < threshold
- Vermont row:
    - Secondary suppression may use Vermont cells ONLY to protect OTHER Vermont cells.
    - Therefore we apply ONLY row-wise constraints within the Vermont row (across detail columns).
- Total column:
    - Secondary suppression may use Total cells ONLY to protect OTHER Total cells.
    - Therefore we apply ONLY column-wise constraints within the Total column (down the geography rows).

Design:
We solve up to 3 independent ILPs per sheet-month block:
  (A) Detail block (non-Vermont rows, non-Total cols) with row+col constraints.
  (B) Vermont row block (Vermont row, non-Total cols) with row constraints only.
  (C) Total col block (non-Vermont rows, Total col only) with col constraints only.
We DO NOT use Vermont totals or Total column to protect detail cells (and vice versa).
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from typing import Iterable, List, Tuple, Optional, Dict

import numpy as np
import pandas as pd
import pulp

P_SUPP = "***"
S_SUPP = "***"


# ----------------------------
# Helpers
# ----------------------------

def _norm(s: object) -> str:
    return str(s).strip().lower()

def _is_total_col(col: str) -> bool:
    c = str(col).strip().lower()
    return ("total" in c) or (c == "all") or (c.endswith(" all"))

def _is_vermont(x: object) -> bool:
    return _norm(x) == "vermont"

def is_total_worksheet(sheet_name: str) -> bool:
    """Check if this is a "Total by <geography type>" worksheet."""
    return str(sheet_name).lower().startswith("total by")

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
    import re
    
    # Convert to string and strip whitespace
    name = str(sheet_name).strip()
    
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

def forward_date(df: pd.DataFrame, date_col: str = "Month.Year", sheet_name: str = "") -> pd.DataFrame:
    """Forward fill Month.Year and drop all-empty non-date rows."""
    df = df.copy()
    
    # Check if this is a "Total by <geography type>" worksheet
    if is_total_worksheet(sheet_name):
        # For "Total by <geography type>" worksheets, there's no 'Month.Year' column
        # The first column is the geography itself
        first_col = df.columns[0]
        keep_cols = df.columns.difference([first_col])
        df = df.dropna(subset=keep_cols, how='all')
    else:
        # For regular worksheets, forward-fill the 'Month.Year' column
        if date_col in df.columns:
            df[date_col] = df[date_col].ffill()
        keep_cols = [c for c in df.columns if c != date_col]
        if keep_cols:
            df = df.dropna(subset=keep_cols, how="all")
    return df

def detect_key_var(df: pd.DataFrame, sheet_name: str = "") -> str:
    """Pick the geography key column (County or AHS District) in a case-insensitive way."""
    # Check if "State" is in the dataframe columns first
    if "State" in df.columns:
        return "State"
    
    # For "Total by" worksheets, use more specific logic
    if is_total_worksheet(sheet_name):
        # Handle both "AHSD" and "AHS District" variations
        if "AHSD" in df.columns:
            return "AHSD"
        elif "AHS District" in df.columns:
            return "AHS District"
        elif "County" in df.columns:
            return "County"
        else:
            # Try case-insensitive matching
            for col in df.columns:
                col_lower = col.lower()
                if col_lower in ["county", "ahsd", "ahs district"]:
                    return col
            # If no match found, use the first column as a fallback
            return df.columns[0]
    
    # For regular worksheets, use the original logic
    cols = { _norm(c): c for c in df.columns }
    if "county" in cols:
        return cols["county"]
    if "ahs district" in cols or "ahsdistrict" in cols:
        return cols.get("ahs district", cols.get("ahsdistrict"))
    
    # Additional fallback logic similar to original script
    if "AHSD" in df.columns:
        return "AHSD"
    elif "AHS District" in df.columns:
        return "AHS District"
    elif "County" in df.columns:
        return "County"
    
    # Final fallback: second column if it exists
    if len(df.columns) >= 2:
        return df.columns[1]
    raise ValueError("Could not detect geography key column (County / AHS District).")


# ----------------------------
# Primary suppression
# ----------------------------

def primary_suppression(
    df: pd.DataFrame,
    threshold: float,
    key_var: str,
    date_col: str = "Month.Year",
    sheet_name: str = "",
) -> Tuple[pd.DataFrame, pd.DataFrame, int]:
    """
    Compute numeric_df and primary_mask WITHOUT replacing values.

    Returns:
      numeric_df: df with numeric cells coerced (non-numeric -> NaN)
      primary_mask: True where numeric value <= threshold (eligible for primary suppression)
      pcount: number of True cells in primary_mask
    """
    df = df.copy()
    df.columns = [str(c).strip() for c in df.columns]
    key_var = str(key_var).strip()

    # Handle "Total by" worksheets differently - they don't have Month.Year column
    if is_total_worksheet(sheet_name):
        id_cols = [key_var]
    else:
        id_cols = [date_col, key_var]
    
    num_cols = [c for c in df.columns if c not in id_cols]  # include Total on purpose

    numeric_df = df.copy()
    numeric_df[num_cols] = numeric_df[num_cols].apply(pd.to_numeric, errors="coerce")

    primary_mask = (numeric_df[num_cols] <= threshold) & numeric_df[num_cols].notna()
    pcount = int(primary_mask.sum().sum())
    return numeric_df, primary_mask, pcount


# ----------------------------
# Generic ILP secondary suppression engine
# ----------------------------

from dataclasses import dataclass
from typing import List, Optional

@dataclass
class BlockSpec:
    rows: pd.Index
    cols: List[str]
    apply_row_rules: bool
    apply_col_rules: bool
    name: str = ""   # optional label for debugging


def _solve_secondary_block(
    numeric_df: pd.DataFrame,
    primary_mask: pd.DataFrame,
    threshold: float,
    block: BlockSpec,
) -> Tuple[pd.DataFrame, int]:
    """
    Solve secondary suppression on a sub-block of numeric_df.
    Returns (suppressed_block_df_as_object, secondary_count).
    """

    work = numeric_df.loc[block.rows, block.cols].copy()
    work = work.apply(pd.to_numeric, errors="coerce")

    pm = (
        primary_mask
        .reindex(index=work.index, columns=work.columns)
        .fillna(False)
        .astype(bool)
    )

    # If no primaries in this block, nothing to do.
    if not pm.any().any():
        return work.astype(object), 0

    prob = pulp.LpProblem("SecondarySuppression", pulp.LpMinimize)

    suppress_vars: Dict[Tuple[object, str], object] = {}

    for i in work.index:
        for j in work.columns:
            if bool(pm.at[i, j]):
                suppress_vars[(i, j)] = 1
            else:
                suppress_vars[(i, j)] = pulp.LpVariable(f"suppress_{i}_{j}", cat="Binary")

    # --------------------------
    # ROW constraints
    # --------------------------
    if block.apply_row_rules:
        for i in work.index:
            # only apply if this row has a primary
            if not bool(pm.loc[i].any()):
                continue

            # feasibility: need at least 2 numeric cells in row
            available_cells = int(work.loc[i].notna().sum())
            if available_cells < 2:
                # cannot ever satisfy >=2 suppressed, so skip row rules entirely
                continue

            row_terms = []
            for j in work.columns:
                if pd.isna(work.at[i, j]):
                    continue  # can't suppress missing
                v = suppress_vars[(i, j)]
                row_terms.append(v if not isinstance(v, int) else 1)

            # again check: do we even have 2 suppressible cells?
            if len(row_terms) < 2:
                continue

            prob += pulp.lpSum(row_terms) >= 2

            # strength constraint: only enforce if primary_sum < threshold
            primary_sum = 0.0
            strength_terms = []
            non_primary_exists = False

            for j in work.columns:
                val = work.at[i, j]
                if pd.isna(val):
                    continue

                if bool(pm.at[i, j]):
                    primary_sum += float(val)
                else:
                    non_primary_exists = True
                    v = suppress_vars[(i, j)]
                    strength_terms.append(float(val) * v)

            # If no non-primary numeric cells exist, strength cannot be achieved, so skip
            if primary_sum < threshold and non_primary_exists:
                prob += (primary_sum + pulp.lpSum(strength_terms)) >= threshold

    # --------------------------
    # COLUMN constraints
    # --------------------------
    if block.apply_col_rules:
        for j in work.columns:
            if not bool(pm[j].any()):
                continue

            # feasibility: need at least 2 numeric cells in column
            available_cells = int(work[j].notna().sum())
            if available_cells < 2:
                continue

            col_terms = []
            for i in work.index:
                if pd.isna(work.at[i, j]):
                    continue
                v = suppress_vars[(i, j)]
                col_terms.append(v if not isinstance(v, int) else 1)

            if len(col_terms) < 2:
                continue

            prob += pulp.lpSum(col_terms) >= 2

            primary_sum = 0.0
            strength_terms = []
            non_primary_exists = False

            for i in work.index:
                val = work.at[i, j]
                if pd.isna(val):
                    continue

                if bool(pm.at[i, j]):
                    primary_sum += float(val)
                else:
                    non_primary_exists = True
                    v = suppress_vars[(i, j)]
                    strength_terms.append(float(val) * v)

            if primary_sum < threshold and non_primary_exists:
                prob += (primary_sum + pulp.lpSum(strength_terms)) >= threshold

    # Objective: minimize secondary suppressed mass
    objective_terms = []
    for i in work.index:
        for j in work.columns:
            v = suppress_vars[(i, j)]
            if isinstance(v, pulp.LpVariable):
                val = work.at[i, j]
                if pd.isna(val):
                    objective_terms.append(10**9 * v)
                else:
                    objective_terms.append(float(val) * v)

    prob += pulp.lpSum(objective_terms)

    status = prob.solve(pulp.PULP_CBC_CMD(msg=False))

    # If infeasible, apply only primaries
    if pulp.LpStatus[status] not in ("Optimal", "Feasible"):
        out = work.astype(object)
        for i in out.index:
            for j in out.columns:
                if bool(pm.at[i, j]):
                    out.at[i, j] = P_SUPP
        return out, 0

    # Apply markers
    out = work.astype(object)
    secondary_count = 0

    for i in out.index:
        for j in out.columns:
            if pd.isna(work.at[i, j]):
                continue
            v = suppress_vars[(i, j)]
            chosen = v if isinstance(v, int) else int(pulp.value(v) or 0)
            if chosen == 1:
                if bool(pm.at[i, j]):
                    out.at[i, j] = P_SUPP
                else:
                    out.at[i, j] = S_SUPP
                    secondary_count += 1

    return out, secondary_count




# ----------------------------
# Full secondary suppression (3 blocks)
# ----------------------------

def secondary_suppression(
    numeric_df: pd.DataFrame,
    primary_mask: pd.DataFrame,
    threshold: float,
    key_var: str,
    date_col: str = "Month.Year",
    sheet_name: str = "",
) -> Tuple[pd.DataFrame, int]:
    """
    Apply secondary suppression to:
      (A) detail block (row+col rules)
      (B) Vermont row across detail cols (row rules only)
      (C) Total col down non-Vermont rows (col rules only)
    """
    df = numeric_df.copy()
    df.columns = [str(c).strip() for c in df.columns]
    key_var = str(key_var).strip()

    # Handle "Total by" worksheets differently - they don't have Month.Year column
    if is_total_worksheet(sheet_name):
        id_cols = [key_var]
    else:
        id_cols = [date_col, key_var]
    
    all_cols = list(df.columns)

    detail_cols = [c for c in all_cols if c not in id_cols and not _is_total_col(c)]
    total_cols = [c for c in all_cols if c not in id_cols and _is_total_col(c)]

    # Identify Vermont rows
    geo = df[key_var].astype(str).str.strip().str.lower()
    vermont_rows = df.index[geo == "vermont"]
    non_vermont_rows = df.index[geo != "vermont"]

    total_secondary = 0
    out_df = df.copy().astype(object)

    # (A) DETAIL block: non-Vermont rows, NON-total columns
    if len(non_vermont_rows) > 0 and len(detail_cols) > 0:
        blockA = BlockSpec(
            rows=non_vermont_rows,
            cols=detail_cols,
            apply_row_rules=True,
            apply_col_rules=True,
            name="DETAIL"
        )
        outA, scA = _solve_secondary_block(numeric_df, primary_mask, threshold, blockA)
        out_df.loc[blockA.rows, blockA.cols] = outA
        total_secondary += scA


    # (B) VERMONT ONLY block: Vermont rows, NON-total columns
    # IMPORTANT: Vermont secondary only protects other Vermont cells
    # so we only enforce ROW rules, and we do NOT enforce column rules here.
    if len(vermont_rows) > 0 and len(detail_cols) > 0:
        blockB = BlockSpec(
            rows=vermont_rows,
            cols=detail_cols,
            apply_row_rules=True,
            apply_col_rules=False,
            name="VERMONT_ONLY"
        )
        outB, scB = _solve_secondary_block(numeric_df, primary_mask, threshold, blockB)
        out_df.loc[blockB.rows, blockB.cols] = outB
        total_secondary += scB

    # (C) TOTAL COLUMN ONLY block: ALL rows (including Vermont), TOTAL column(s)
    # IMPORTANT: Total cells only protect other Total cells,
    # so we enforce ONLY column rules here.
    if len(total_cols) > 0:
        blockC = BlockSpec(
            rows=df.index,            # include Vermont here
            cols=total_cols,
            apply_row_rules=False,
            apply_col_rules=True,
            name="TOTAL_ONLY"
        )
        outC, scC = _solve_secondary_block(numeric_df, primary_mask, threshold, blockC)
        out_df.loc[blockC.rows, blockC.cols] = outC
        total_secondary += scC

    # Ensure PRIMARY markers are applied everywhere they are True, but never overwrite secondary.
    pm_all = primary_mask.reindex(index=df.index, columns=primary_mask.columns).fillna(False).astype(bool)
    for i in df.index:
        for j in pm_all.columns:
            if bool(pm_all.at[i, j]) and out_df.at[i, j] != S_SUPP:
                out_df.at[i, j] = P_SUPP

    return out_df, total_secondary

# ----------------------------
# Audit
# ----------------------------

def audit_suppression_block(
    out_df: pd.DataFrame,
    numeric_df: pd.DataFrame,
    key_var: str,
    threshold: float,
    primary_mask: pd.DataFrame | None = None,
    date_col: str = "Month.Year",
    p_supp: str = P_SUPP,
    s_supp: str = S_SUPP,
    verbose: bool = True,
) -> bool:
    """
    Audits suppression output against the policy:
      (A) DETAIL block (non-Vermont rows x detail cols): row+col rules
      (B) VERMONT_ONLY block (Vermont rows x detail cols): row rules only
      (C) TOTAL_ONLY block (all rows x total cols): col rules only

    Rules within a block apply ONLY if the row/col contains >=1 PRIMARY in that block:
      - >=2 suppressed cells in that row/col (within the block)
      - if primary_sum < threshold, suppressed numeric mass >= threshold

    Returns True if PASS, False if FAIL.
    """
    df = out_df.copy()
    df.columns = [str(c).strip() for c in df.columns]
    key_var = str(key_var).strip()

    id_cols = [date_col, key_var]
    detail_cols = [c for c in df.columns if c not in id_cols and not _is_total_col(c)]
    total_cols  = [c for c in df.columns if c not in id_cols and _is_total_col(c)]

    geo = df[key_var].astype(str).str.strip().str.lower()
    vermont_rows = df.index[geo == "vermont"]
    non_vermont_rows = df.index[geo != "vermont"]

    issues: list[str] = []

    def suppressed_mask(rows, cols):
        sub = df.loc[rows, cols]
        return sub.isin([p_supp, s_supp])

    def get_primary_mask(rows, cols):
        """
        Block-aligned primary mask (True where primary suppression applies).
        Prefer explicit primary_mask; otherwise infer using numeric_df <= threshold.
        """
        if primary_mask is not None:
            pm = (
                primary_mask
                .reindex(index=rows, columns=cols)
                .fillna(False)
                .astype(bool)
            )
            return pm

        # fallback inference (not preferred)
        num = numeric_df.loc[rows, cols].apply(pd.to_numeric, errors="coerce")
        return (num <= threshold) & num.notna()

    def get_numeric(rows, cols):
        return numeric_df.loc[rows, cols].apply(pd.to_numeric, errors="coerce")

    # ----------------------------
    # (A) DETAIL checks
    # ----------------------------
    if len(non_vermont_rows) > 0 and len(detail_cols) > 0:
        sm = suppressed_mask(non_vermont_rows, detail_cols)
        num = get_numeric(non_vermont_rows, detail_cols)
        pm  = get_primary_mask(non_vermont_rows, detail_cols)

        # Row rules: only for rows that contain a PRIMARY in detail block
        for i in sm.index:
            if not pm.loc[i].any():
                continue

            # FEASIBILITY GUARD: only enforce if >=2 numeric cells exist in the row
            available_numeric = int(num.loc[i].notna().sum())
            if available_numeric >= 2:
                suppressed_ct = int(sm.loc[i].sum())
                if suppressed_ct < 2:
                    issues.append(
                        f"DETAIL ROW violation at index={i}: only {suppressed_ct} suppressed cell(s)."
                    )

            # Strength rule: only enforce if primary_sum < threshold AND there exists a non-primary numeric cell
            primary_sum = float(num.loc[i][pm.loc[i]].sum())

            non_primary_available = int(num.loc[i][(~pm.loc[i])].notna().sum())
            if primary_sum < threshold and non_primary_available > 0:
                suppressed_mass = float(num.loc[i][sm.loc[i]].sum())
                if suppressed_mass + 1e-9 < threshold:
                    issues.append(
                        f"DETAIL ROW strength violation at index={i}: "
                        f"suppressed mass {suppressed_mass:.2f} < {threshold} (primary_sum={primary_sum:.2f})."
                    )

        # Column rules: only for cols that contain a PRIMARY in detail block
        for j in sm.columns:
            if not pm[j].any():
                continue

            # FEASIBILITY GUARD: only enforce if >=2 numeric cells exist in the column
            available_numeric = int(num[j].notna().sum())
            if available_numeric >= 2:
                suppressed_ct = int(sm[j].sum())
                if suppressed_ct < 2:
                    issues.append(
                        f"DETAIL COLUMN violation in '{j}': only {suppressed_ct} suppressed cell(s)."
                    )

            # Strength rule: only enforce if primary_sum < threshold AND there exists a non-primary numeric cell
            primary_sum = float(num.loc[pm[j], j].sum())

            non_primary_available = int(num.loc[(~pm[j]), j].notna().sum())
            if primary_sum < threshold and non_primary_available > 0:
                suppressed_mass = float(num.loc[sm[j], j].sum())
                if suppressed_mass + 1e-9 < threshold:
                    issues.append(
                        f"DETAIL COLUMN strength violation in '{j}': "
                        f"suppressed mass {suppressed_mass:.2f} < {threshold} (primary_sum={primary_sum:.2f})."
                    )

    # ----------------------------
    # (B) VERMONT row checks (row-only across detail cols)
    # ----------------------------
    if len(vermont_rows) > 0 and len(detail_cols) > 0:
        sm = suppressed_mask(vermont_rows, detail_cols)
        num = get_numeric(vermont_rows, detail_cols)
        pm  = get_primary_mask(vermont_rows, detail_cols)

        for i in sm.index:
            # Only enforce Vermont row rules if the row contains a PRIMARY in Vermont/detail block
            if not pm.loc[i].any():
                continue

            # FEASIBILITY GUARD: only enforce >=2 suppressed if >=2 numeric cells exist in the row
            available_numeric = int(num.loc[i].notna().sum())
            if available_numeric >= 2:
                suppressed_ct = int(sm.loc[i].sum())
                if suppressed_ct < 2:
                    issues.append(
                        f"VERMONT ROW violation at index={i}: only {suppressed_ct} suppressed cell(s)."
                    )

            # Strength rule: only enforce if primary_sum < threshold AND there exists a non-primary numeric cell
            primary_sum = float(num.loc[i][pm.loc[i]].sum())

            non_primary_available = int(num.loc[i][(~pm.loc[i])].notna().sum())
            if primary_sum < threshold and non_primary_available > 0:
                suppressed_mass = float(num.loc[i][sm.loc[i]].sum())
                if suppressed_mass + 1e-9 < threshold:
                    issues.append(
                        f"VERMONT ROW strength violation at index={i}: "
                        f"suppressed mass {suppressed_mass:.2f} < {threshold} (primary_sum={primary_sum:.2f})."
                    )

    # ----------------------------
    # (C) TOTAL column checks (col-only down non-Vermont rows)
    # ----------------------------
    if len(total_cols) > 0 and len(non_vermont_rows) > 0:
        sm = suppressed_mask(non_vermont_rows, total_cols)
        num = get_numeric(non_vermont_rows, total_cols)
        pm  = get_primary_mask(non_vermont_rows, total_cols)

        for j in sm.columns:
            # Only enforce Total column rules if the column contains a PRIMARY in total block
            if not pm[j].any():
                continue

            # FEASIBILITY GUARD: only enforce >=2 suppressed if >=2 numeric cells exist in the column
            available_numeric = int(num[j].notna().sum())
            if available_numeric >= 2:
                suppressed_ct = int(sm[j].sum())
                if suppressed_ct < 2:
                    issues.append(
                        f"TOTAL COLUMN violation in '{j}': only {suppressed_ct} suppressed cell(s)."
                    )

            # Strength rule: only enforce if primary_sum < threshold AND there exists a non-primary numeric cell
            primary_sum = float(num.loc[pm[j], j].sum())

            non_primary_available = int(num.loc[(~pm[j]), j].notna().sum())
            if primary_sum < threshold and non_primary_available > 0:
                suppressed_mass = float(num.loc[sm[j], j].sum())
                if suppressed_mass + 1e-9 < threshold:
                    issues.append(
                        f"TOTAL COLUMN strength violation in '{j}': "
                        f"suppressed mass {suppressed_mass:.2f} < {threshold} (primary_sum={primary_sum:.2f})."
                    )

    # ----------------------------
    # Final
    # ----------------------------
    if issues:
        if verbose:
            print("\n[AUDIT FAIL] Suppression audit found issues:")
            for it in issues:
                print(f"  - {it}")
        return False

    if verbose:
        print("[AUDIT PASS] Suppression audit passed.")
    return True

# ----------------------------
# Iterative suppression (one sheet)
# ----------------------------

def iterative_suppression(group: pd.DataFrame, threshold: float, key_var: str, sheet_name: str = "", primary_only: bool = False):
    """
    Iteratively apply secondary suppression until stable.

    IMPORTANT:
    - The ILP MUST always run on the ORIGINAL numeric values.
    - We keep a separate object df for suppressed output.
    """
    # Base numeric version (never changes)
    base_numeric_df, primary_mask, pcount = primary_suppression(group, threshold, key_var, sheet_name=sheet_name)

    # Output view (does change, carries *** markers)
    out_df = base_numeric_df.copy().astype(object)

    total_secondary = 0

    # Apply primary suppressions to output
    for i in base_numeric_df.index:
        for j in primary_mask.columns:
            if bool(primary_mask.at[i, j]):
                out_df.at[i, j] = P_SUPP

    # If primary-only mode, skip secondary suppression
    if primary_only:
        return out_df, total_secondary, pcount

    # columns that are eligible for suppression (non-id, includes Total)
    # Handle "Total by" worksheets differently - they don't have Month.Year column
    if is_total_worksheet(sheet_name):
        id_cols = [key_var]
    else:
        id_cols = ["Month.Year", key_var]
    
    candidate_cols = [c for c in base_numeric_df.columns if c not in id_cols]

    while True:
        # Build a fixed-suppression mask = primary OR existing secondary
        already_secondary = out_df[candidate_cols].isin([S_SUPP])
        fixed_mask = primary_mask.copy()
        fixed_mask = fixed_mask.reindex(index=base_numeric_df.index, columns=primary_mask.columns).fillna(False)

        # Only combine on numeric columns that exist in primary_mask
        for c in fixed_mask.columns:
            fixed_mask[c] = fixed_mask[c] | already_secondary[c]

        # Run secondary suppression ON BASE NUMERIC VALUES, using cumulative fixed mask
        df_out, scount = secondary_suppression(
            numeric_df=base_numeric_df,
            primary_mask=fixed_mask,
            threshold=threshold,
            key_var=key_var,
            sheet_name=sheet_name,
        )

        # Overlay the new suppressions into the output view
        out_df.update(df_out.astype(object))

        total_secondary += scount

        # Stop when no new secondaries were added
        if scount == 0:
            # Run audit once at the end
            numeric_df_for_audit = base_numeric_df.copy()
            audit_suppression_block(
                out_df=out_df,
                numeric_df=numeric_df_for_audit,
                key_var=key_var,
                threshold=threshold,
                verbose=True,
            )
            return out_df, total_secondary, pcount





# ----------------------------
# IO / CLI
# ----------------------------

def suppress_workbook(input_path: str, output_path: str, threshold: float) -> None:
    xls = pd.ExcelFile(input_path)

    results = []

    for original_sheet_name in xls.sheet_names:
        # Parse worksheet title to check for primary-only annotation
        clean_sheet_name, is_primary_only = parse_worksheet_title(original_sheet_name)
        
        df = pd.read_excel(xls, sheet_name=original_sheet_name)

        # basic cleanup
        df.columns = [str(c).strip() for c in df.columns]
        
        # Apply forward_date with clean_sheet_name for "Total by" worksheet detection
        df = forward_date(df, "Month.Year", clean_sheet_name)

        key_var = detect_key_var(df, clean_sheet_name)

        # Print processing information
        if is_primary_only:
            print(f"Processing '{original_sheet_name}' with PRIMARY-ONLY suppression (output: '{clean_sheet_name}')")
        else:
            print(f"Processing '{original_sheet_name}' with full suppression (primary + secondary)")

        # -----------------------------
        # SORT: Handle "Total by" worksheets differently
        # -----------------------------
        geo = df[key_var].astype(str).str.strip().str.lower()
        df["_is_vermont"] = (geo == "vermont").astype(int)

        if is_total_worksheet(clean_sheet_name):
            # For "Total by" worksheets, sort by geography only (no Month.Year)
            # Do NOT convert Month.Year to datetime for Total worksheets
            df = (
                df.sort_values(
                    by=["_is_vermont", key_var],
                    ascending=[True, True],
                    kind="mergesort"
                )
                .drop(columns="_is_vermont")
                .reset_index(drop=True)
            )
        else:
            # For regular worksheets, sort by Month.Year, Vermont, and geography
            # Only convert Month.Year to datetime for regular worksheets
            if "Month.Year" in df.columns:
                df["Month.Year"] = pd.to_datetime(df["Month.Year"], errors="coerce")
            df = (
                df.sort_values(
                    by=["Month.Year", "_is_vermont", key_var],
                    ascending=[False, True, True],   # Month DESC
                    kind="mergesort"
                )
                .drop(columns="_is_vermont")
                .reset_index(drop=True)
            )

        # -----------------------------
        # APPLY SUPPRESSION
        # -----------------------------
        all_out = []
        total_secondary = 0
        total_primary = 0

        if is_total_worksheet(clean_sheet_name):
            # For "Total by" worksheets, process entire dataframe as single group
            out_df, scount, pcount = iterative_suppression(df, threshold, key_var, clean_sheet_name, is_primary_only)
            all_out.append(out_df)
            total_secondary += scount
            total_primary += pcount
        else:
            # For regular worksheets, group by Month.Year
            for month_value, month_df in df.groupby("Month.Year", sort=False, dropna=False):
                out_month, scount, pcount = iterative_suppression(month_df, threshold, key_var, clean_sheet_name, is_primary_only)
                all_out.append(out_month)
                total_secondary += scount
                total_primary += pcount

        out_df = pd.concat(all_out, ignore_index=True)
        
        # Ensure column order matches the original dataframe
        if len(all_out) > 0:
            original_columns = df.columns.tolist()
            if list(out_df.columns) != original_columns:
                # Reorder columns to match original order
                out_df = out_df[original_columns]

        if is_primary_only:
            print(f"  -> '{clean_sheet_name}': Primary suppressed {total_primary} values (secondary suppression skipped)")
        else:
            print(f"  -> '{clean_sheet_name}': Primary suppressed {total_primary}, Secondary suppressed {total_secondary} values")

        # Use clean name for the output sheet name
        results.append((clean_sheet_name, out_df))

    # Only open writer once we have at least one successful sheet
    with pd.ExcelWriter(output_path, engine="openpyxl") as writer:
        for clean_sheet_name, out_df in results:
            out_df.to_excel(writer, sheet_name=clean_sheet_name, index=False)



def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("inputfile")
    parser.add_argument("outputfile")
    parser.add_argument("-t", "--threshold", type=float, default=10)
    args = parser.parse_args()

    suppress_workbook(args.inputfile, args.outputfile, args.threshold)

if __name__ == "__main__":
    main()
