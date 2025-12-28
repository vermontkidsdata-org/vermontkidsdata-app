python ./suppression/suppression.py "suppression/Act 76 Family Data FY 23-25.xlsx" suppression/family-fy23-fy25.xlsx
./scripts/gen_tables.py suppression/family-fy23-fy25.xlsx
./scripts/gen_inserts.py "suppression/Act 76 Family Data FY 23-25.xlsx" suppression/family-fy23-fy25.xlsx
