# Suppression Script Analysis: Original vs Rewritten

## Executive Summary

This analysis compares two Python scripts for data suppression in Excel worksheets:
- [`suppression/Original script July 2025.py`](suppression/Original%20script%20July%202025.py) (184 lines)
- [`suppression/suppression_rewritten.py`](suppression/suppression_rewritten.py) (748 lines)

The rewritten version represents a complete architectural overhaul with significantly enhanced suppression logic, better code organization, and more robust handling of edge cases.

## 1. Architectural Differences

### Original Script Architecture
- **Monolithic approach**: Single script with functions called sequentially
- **Simple suppression model**: Basic primary + iterative secondary suppression
- **Limited separation of concerns**: Mixed data processing, suppression logic, and I/O
- **Global variables**: Uses global `P_SUPP` and `S_SUPP` variables set at runtime

### Rewritten Script Architecture
- **Modular design**: Clear separation into distinct functional blocks
- **Three-block suppression model**: Detail, Vermont-only, and Total-column blocks
- **Object-oriented approach**: Uses `@dataclass` for `BlockSpec` configuration
- **Constants**: Hardcoded `P_SUPP = "***"` and `S_SUPP = "***"`
- **Comprehensive validation**: Built-in audit functions for verification

## 2. Suppression Algorithm Differences

### Original Algorithm
```python
# Simple approach: suppress if value <= threshold
def primary_suppression(df, threshold):
    for col in num_cols:
        def suppress(x):
            if pd.isna(x) or x > threshold:
                return x
            else:
                return P_SUPP
```

**Secondary suppression logic:**
- Single ILP problem for entire data block
- Basic row/column constraints (≥2 suppressions if any primary exists)
- Iterative approach until no new suppressions needed

### Rewritten Algorithm
```python
# More sophisticated: separate numeric processing from suppression marking
def primary_suppression(df, threshold, key_var, date_col="Month.Year"):
    # Returns: numeric_df, primary_mask, pcount
    primary_mask = (numeric_df[num_cols] <= threshold) & numeric_df[num_cols].notna()
```

**Advanced secondary suppression:**
- **Three independent ILP problems** per sheet-month block:
  1. **Detail block**: Non-Vermont rows × non-Total columns (row + column rules)
  2. **Vermont block**: Vermont rows × detail columns (row rules only)
  3. **Total block**: All rows × Total columns (column rules only)

- **Enhanced constraints:**
  - Minimum count rule: ≥2 suppressions per affected row/column
  - **Strength rule**: Suppressed mass ≥ threshold (when primary_sum < threshold)
  - Feasibility guards: Only enforce rules when ≥2 numeric cells available

## 3. Data Handling Improvements

### Original Data Processing
```python
def load_as_dict(path):
    return pd.read_excel(path, engine='openpyxl', sheet_name=None)

def forward_date(df):
    df["Month.Year"]= df['Month.Year'].ffill()
    keep_cols = df.columns.difference(['Month.Year'])
    df = df.dropna(subset=keep_cols, how='all')
```

### Rewritten Data Processing
```python
def detect_key_var(df: pd.DataFrame) -> str:
    """Pick the geography key column (County or AHS District) in a case-insensitive way."""
    cols = { _norm(c): c for c in df.columns }
    if "county" in cols:
        return cols["county"]
    # ... more robust detection logic

def forward_date(df: pd.DataFrame, date_col: str = "Month.Year") -> pd.DataFrame:
    """Forward fill Month.Year and drop all-empty non-date rows."""
    # More explicit parameter handling
```

**Key improvements:**
- **Type hints** throughout for better code documentation
- **Robust column detection** with case-insensitive matching
- **Better error handling** for missing or malformed data
- **Explicit parameter passing** instead of hardcoded assumptions

## 4. Command-Line Interface Changes

### Original CLI
```python
parser.add_argument('-l', '--log', default=default_log, help='Log filename')
parser.add_argument('-t', '--threshold', default=5, type=int, help="Threshold")
parser.add_argument('-p', '--primary', default="***", help="Primary suppression string")
parser.add_argument('-s', '--secondary', default="***", help="Secondary suppression string")
parser.add_argument('inputfile', help='Input filename')
parser.add_argument('outputfile', help='Output filename')
```

**Features:**
- Configurable suppression markers
- Logging support
- Default threshold of 5

### Rewritten CLI
```python
parser.add_argument("inputfile")
parser.add_argument("outputfile")
parser.add_argument("-t", "--threshold", type=float, default=10)
```

**Changes:**
- **Simplified interface**: Removed logging and marker customization
- **Higher default threshold**: Changed from 5 to 10
- **Float threshold**: More flexible numeric handling
- **Fixed markers**: Hardcoded to "***" for both primary and secondary

## 5. Code Structure and Organization

### Original Structure (184 lines)
```
Functions (9):
├── load_as_dict()
├── primary_suppression()
├── forward_date()
├── secondary_suppression()
├── iterative_supression() [sic]
├── apply_suppression()
├── suppress_blocks()
└── __main__ execution

Global scope: Argument parsing and main execution loop
```

### Rewritten Structure (748 lines)
```
Sections:
├── Imports and constants (48 lines)
├── Helper functions (32 lines)
├── Primary suppression (28 lines)
├── Secondary suppression engine (186 lines)
├── Full secondary suppression (84 lines)
├── Audit functions (204 lines)
├── Iterative suppression (56 lines)
├── IO/CLI functions (74 lines)
└── Main execution (36 lines)

Classes:
└── BlockSpec (@dataclass)
```

**Organizational improvements:**
- **Clear section headers** with ASCII art separators
- **Comprehensive docstrings** explaining complex logic
- **Type annotations** throughout
- **Separation of concerns** with dedicated audit functions
- **Modular design** allowing easier testing and maintenance

## 6. Error Handling and Validation

### Original Error Handling
- **Minimal validation**: Basic pandas operations with default error handling
- **No audit functions**: No verification of suppression correctness
- **Silent failures**: Issues may not be detected until output review

### Rewritten Error Handling
```python
def audit_suppression_block(out_df, numeric_df, key_var, threshold, ...):
    """Audits suppression output against the policy"""
    # Comprehensive validation of:
    # - Detail block rules (row + column)
    # - Vermont-only block rules (row only)  
    # - Total-only block rules (column only)
    
    if issues:
        print("\n[AUDIT FAIL] Suppression audit found issues:")
        for it in issues:
            print(f"  - {it}")
        return False
```

**Validation improvements:**
- **Built-in audit system**: Automatic verification after suppression
- **Detailed error reporting**: Specific violation descriptions
- **Feasibility guards**: Prevents impossible constraint scenarios
- **Block-specific validation**: Different rules for different data regions

## 7. Performance and Maintainability

### Performance Considerations

**Original:**
- Single large ILP problem per month-block
- Simpler constraints = faster solving
- Less memory usage due to smaller codebase

**Rewritten:**
- Three separate ILP problems per month-block
- More complex constraints = potentially slower solving
- Higher memory usage due to comprehensive validation
- **Trade-off**: Accuracy vs. speed

### Maintainability Improvements

**Code Quality:**
- **Type hints**: Better IDE support and documentation
- **Docstrings**: Comprehensive function documentation
- **Modular design**: Easier to test individual components
- **Clear naming**: More descriptive function and variable names

**Extensibility:**
- **BlockSpec class**: Easy to add new suppression block types
- **Parameterized functions**: More flexible configuration options
- **Audit framework**: Easy to add new validation rules

## 8. Key Functional Differences

### Suppression Policy Changes

**Original Policy:**
- Suppress all cells ≤ threshold
- Apply secondary suppression to protect primaries
- Single constraint set for entire data block

**Rewritten Policy:**
- **Segregated protection**: Vermont cells only protect other Vermont cells, Total cells only protect other Total cells
- **Strength constraints**: Suppressed mass must meet threshold requirements
- **Block-specific rules**: Different constraint sets for different data regions

### Data Block Handling

**Original:**
```python
# Single block approach
suppress_df = df.loc[df[key_var] != 'Vermont', supp_cols]
# Excludes Vermont from secondary suppression entirely
```

**Rewritten:**
```python
# Three-block approach
# (A) Detail: non-Vermont × non-Total (row+col rules)
# (B) Vermont: Vermont × detail (row rules only)  
# (C) Total: all × Total (col rules only)
```

This represents a **fundamental policy change** in how suppression protection works across different data regions.

## 9. Recommendations

### When to Use Original Script
- **Simple suppression needs**: Basic primary + secondary suppression
- **Performance critical**: Faster execution for large datasets
- **Custom markers needed**: Configurable suppression strings
- **Legacy compatibility**: Existing workflows depend on specific behavior

### When to Use Rewritten Script  
- **Complex data structures**: Multiple data regions requiring different protection rules
- **Audit requirements**: Need verification of suppression correctness
- **Maintainability priority**: Long-term codebase maintenance
- **Enhanced accuracy**: More sophisticated suppression logic needed

### Migration Considerations
1. **Policy differences**: The rewritten version implements different suppression rules
2. **Output validation**: Results will differ between versions due to algorithmic changes
3. **Interface changes**: CLI parameters have been simplified
4. **Testing required**: Comprehensive validation needed before production use

## Conclusion

The rewritten script represents a **complete reimplementation** rather than an incremental improvement. It introduces:

- **Advanced suppression algorithms** with block-specific rules
- **Comprehensive validation framework** for quality assurance  
- **Better code organization** for long-term maintainability
- **Enhanced type safety** and documentation

However, it also introduces **breaking changes** in both interface and suppression behavior that require careful evaluation before adoption.