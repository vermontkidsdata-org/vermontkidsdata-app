# Act76 County Filtering Analysis - CRITICAL DATA INTEGRITY ISSUE

**Date:** 2026-02-07  
**Issue:** CATASTROPHIC SUPPRESSION PROCESSING ERROR  
**Status:** 663 Vermont records incorrectly suppressed across all Act76 child tables  

## Executive Summary

**CATASTROPHIC FINDING**: 100% of Vermont records with geo_type="county" are incorrectly suppressed across ALL Act76 child tables, causing widespread data visualization errors. This is not a SQL query logic issue - it's a systematic suppression processing error that treats Vermont state totals as suppressible county-level data.

## Problem Summary

### Affected Charts
- [`act76_child_race:bar`](https://ui.vtkidsdata.org/columnchartfiltered/act76_child_race:bar) - Default page shows 503 instead of 7,692 for White children
- [`act76_child_ethnicity_ccfap:bar`](https://ui.qa.vtkidsdata.org/columnchartfiltered/act76_child_ethnicity_ccfap:bar) - Default page shows 540 instead of 9,250 for Non-Hispanic children
- County selection shows wrong data (Washington County showing Windham data)

### Impact Scale - COMPLETE DATA CORRUPTION
- **Race table**: 351/351 Vermont county records incorrectly suppressed (100%)
- **Ethnicity table**: 117/117 Vermont county records incorrectly suppressed (100%)  
- **Age table**: 195/195 Vermont county records incorrectly suppressed (100%)
- **Total affected**: 663 records across all Act76 child tables

## Root Cause Analysis

### Initial Misdiagnosis ❌
**My Initial Hypothesis**: SQL query logic issue with geo_type filtering  
**My Proposed Fix**: Change 18 SQL queries to use "AHS district" instead of "county" for Vermont totals  
**User Correction**: "This tells me the data is wrong!" - correctly identified as data integrity issue

### Actual Root Cause: Suppression Processing Logic Error ✅

The suppression script ([`suppression/suppression.py`](suppression/suppression.py)) identifies Vermont records purely by geography name without considering geo_type context:

```python
# Line 444: Identifies ALL Vermont records the same way
geo = df[key_var].astype(str).str.strip().str.lower()
vermont_rows = df.index[geo == "vermont"]
```

**Critical Flaw**: The script doesn't distinguish between:
1. **Vermont state totals** (geo_type="AHS district") - should NEVER be suppressed
2. **Vermont county records** (geo_type="county") - incorrectly treated as suppressible data

## Data Evidence

### Source Data Integrity ✅
Excel source file shows Vermont exists in both County and AHSD sheets with **identical values**, confirming suppression processing is the culprit, not source data.

### Database Evidence - Massive Suppression Error
```sql
-- CORRECT: Vermont AHS district data (unsuppressed)
geography = "Vermont", geo_type = "AHS district", race = "White", value = 7692, value_suppressed = 7692

-- INCORRECT: Vermont county data (massively suppressed)  
geography = "Vermont", geo_type = "county", race = "White", value = 7692, value_suppressed = 503
```

**Example of Suppression Damage**:
- Original value: 7,692 children
- Suppressed value: 503 children  
- **Data loss**: 93.5% of actual data suppressed incorrectly

## Suppression Logic Analysis

### Current Flawed Logic
```python
# Lines 467-477: Vermont records processed in "VERMONT_ONLY" block
if len(vermont_rows) > 0 and len(detail_cols) > 0:
    blockB = BlockSpec(
        rows=vermont_rows,           # ALL Vermont records, regardless of geo_type
        cols=detail_cols,
        apply_row_rules=True,        # ❌ Applies suppression rules to state totals
        apply_col_rules=False,
        name="VERMONT_ONLY"
    )
```

### Required Fix Logic
Vermont state totals should be **exempt from suppression** regardless of how they're classified in geo_type. The suppression script needs to distinguish between:
- Vermont records representing **state aggregates** (never suppress)
- Vermont records representing **county-level detail** (apply normal suppression rules)

## Impact on Data Visualization

### API Behavior
```bash
# Current incorrect behavior
curl "https://api.qa.vtkidsdata.org/chart/bar/act76_child_race:bar?race_filter=White&county_filter=--%20All%20--&month_filter=9&year_filter=2025"
# Returns: {"series":[{"name":"Vermont","data":[503]}]} ❌

# Should return: {"series":[{"name":"Vermont","data":[7692]}]} ✅
```

### UI Impact
- Default charts show drastically underreported Vermont totals
- County filtering returns wrong county data due to incorrect Vermont baseline
- All Act76 child data visualizations compromised

## Solution Options

### Option 1: Data Cleanup (Quick Fix)
**Approach**: Remove all Vermont records with geo_type="county" from database
```sql
DELETE FROM data_act76_child_race WHERE geography = 'Vermont' AND geo_type = 'county';
DELETE FROM data_act76_child_ethnicity WHERE geography = 'Vermont' AND geo_type = 'county';  
DELETE FROM data_act76_child_age WHERE geography = 'Vermont' AND geo_type = 'county';
```
**Pros**: Immediate fix, simple implementation  
**Cons**: Doesn't prevent future occurrences, may mask other suppression issues

### Option 2: Suppression Logic Fix (Proper Fix)
**Approach**: Modify [`suppression/suppression.py`](suppression/suppression.py) to exempt Vermont state totals
```python
# Add geo_type awareness to Vermont processing
def _is_vermont_state_total(row, geo_type_col):
    return (_is_vermont(row['geography']) and 
            row[geo_type_col] in ['AHS district', 'state'])

# Exempt state totals from suppression
vermont_suppressible_rows = df.index[
    (geo == "vermont") & 
    (~df.apply(lambda row: _is_vermont_state_total(row, 'geo_type'), axis=1))
]
```
**Pros**: Addresses root cause, prevents future occurrences  
**Cons**: More complex, requires testing across all suppression scenarios

### Option 3: Hybrid Approach (Recommended)
1. **Immediate**: Data cleanup for current crisis
2. **Long-term**: Suppression logic improvement for future data processing
3. **Validation**: Comprehensive testing of both fixes

## Files Investigated

### Modified (REVERTED per user request)
- ~~[`scripts/20250924-act76.sql`](scripts/20250924-act76.sql)~~ - All 18 query modifications reverted

### Analyzed
- [`suppression/suppression.py`](suppression/suppression.py) - Suppression processing logic
- [`suppression/Child Data FY 23-25.xlsx`](suppression/Child Data FY 23-25.xlsx) - Source data validation
- Database tables: `data_act76_child_race`, `data_act76_child_ethnicity`, `data_act76_child_age`

### Created
- [`docs/act76-county-filtering-analysis.md`](docs/act76-county-filtering-analysis.md) - This comprehensive analysis

## Next Steps - URGENT

1. **Immediate Decision Required**: Choose solution approach (data cleanup vs logic fix vs hybrid)
2. **Data Recovery**: Restore correct Vermont totals across all Act76 child visualizations  
3. **Root Cause Investigation**: Examine how Vermont county records were created in source processing
4. **Testing Protocol**: Verify fix doesn't impact other data tables or suppression logic
5. **Validation**: Ensure all Act76 visualizations display correct Vermont totals
6. **Prevention**: Implement safeguards to prevent future Vermont state total suppression

## Key Lessons Learned

1. **Always investigate data integrity first** before assuming query logic issues
2. **User insight was critical**: "This tells me the data is wrong!" correctly identified the real problem
3. **Suppression logic must distinguish between state totals and county details** even when geography names are identical
4. **Source data validation is essential** - identical Excel values should never result in different suppressed values
5. **Systematic data corruption requires systematic investigation** - checking all related tables revealed the full scope

## Technical Debt Created

This suppression error has created significant technical debt:
- 663 corrupted records requiring cleanup or reprocessing
- All Act76 child visualizations showing incorrect data
- User trust in data accuracy compromised
- Potential impact on policy decisions based on incorrect Vermont child data

**Priority**: CRITICAL - Immediate action required to restore data integrity