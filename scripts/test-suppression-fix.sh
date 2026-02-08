#!/bin/bash

# Script to test the fixed suppression processing and update the database
# Usage: bash scripts/test-suppression-fix.sh

set -e

echo "=== Testing Fixed Suppression Processing Script ==="
echo ""

# Step 1: Run suppression processing on child data
echo "Step 1: Running suppression processing on Child Data FY 23-25..."
cd suppression
python suppression.py "Child Data FY 23-25.xlsx" "child-data-fy-23-25.xlsx"

if [ $? -eq 0 ]; then
    echo "✓ Suppression processing completed successfully"
else
    echo "✗ Suppression processing failed"
    exit 1
fi

# Step 2: Generate SQL insert statements
echo ""
echo "Step 2: Generating SQL insert statements..."
cd ..
python scripts/gen_inserts.py \
    "suppression/Child Data FY 23-25.xlsx" \
    "suppression/child-data-fy-23-25.xlsx" \
    "scripts/act76-child-inserts-$(date +%Y%m%d).sql"

if [ $? -eq 0 ]; then
    echo "✓ SQL generation completed successfully"
    echo "Generated file: scripts/act76-child-inserts-$(date +%Y%m%d).sql"
else
    echo "✗ SQL generation failed"
    exit 1
fi

# Step 3: Get database credentials
echo ""
echo "Step 3: Getting database credentials..."
DB_CREDS=$(node scripts/get-mysql-credentials.js qa 2>/dev/null | grep -E "^export" || true)

if [ -z "$DB_CREDS" ]; then
    echo "✗ Could not get database credentials"
    echo "Please run: node scripts/get-mysql-credentials.js"
    echo "And manually execute the generated SQL file"
    exit 1
fi

# Export the credentials
eval "$DB_CREDS"

echo "✓ Database credentials retrieved"

# Step 4: Ask user for confirmation before updating database
echo ""
echo "Step 4: Ready to update database..."
echo "This will:"
echo "  - Truncate existing Act76 child data tables"
echo "  - Insert corrected suppressed data"
echo ""
read -p "Do you want to proceed with database update? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Database update cancelled. You can manually run:"
    echo "mysql -h $MYSQL_HOST -u $MYSQL_USER -p $MYSQL_DATABASE < scripts/act76-child-inserts-$(date +%Y%m%d).sql"
    exit 0
fi

# Step 5: Execute SQL script
echo ""
echo "Step 5: Executing SQL script..."
mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "scripts/act76-child-inserts-$(date +%Y%m%d).sql"

if [ $? -eq 0 ]; then
    echo "✓ Database update completed successfully"
else
    echo "✗ Database update failed"
    exit 1
fi

# Step 6: Verify the fix
echo ""
echo "Step 6: Verifying the fix..."
echo "Testing a few key queries to verify data integrity..."

# Test query 1: Check Vermont totals for race data
echo ""
echo "Checking Vermont race data totals..."
mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "
SELECT geography, geo_type, race, value_suppressed 
FROM data_act76_child_race 
WHERE geography = 'Vermont' AND race = 'White' 
ORDER BY geo_type;"

# Test query 2: Check Washington County data
echo ""
echo "Checking Washington County race data..."
mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "
SELECT geography, geo_type, race, value_suppressed 
FROM data_act76_child_race 
WHERE geography = 'Washington' AND race = 'White' 
ORDER BY geo_type;"

echo ""
echo "=== Test Complete ==="
echo ""
echo "Next steps:"
echo "1. Test the charts in the browser:"
echo "   - https://ui.qa.vtkidsdata.org/columnchartfiltered/act76_child_race:bar"
echo "   - https://ui.qa.vtkidsdata.org/columnchartfiltered/act76_child_ethnicity_ccfap:bar"
echo ""
echo "2. Verify that:"
echo "   - Default page shows correct Vermont totals"
echo "   - County selection shows correct county data"
echo "   - No more data shuffle between counties"
echo ""
echo "3. If everything looks good, run the same process for family data:"
echo "   bash scripts/test-suppression-fix.sh family"