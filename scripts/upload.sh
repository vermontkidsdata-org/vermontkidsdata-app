#!/bin/bash

# Check if both arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <prod|qa> <data_file>"
    echo "Example: $0 qa capacity"
    echo "Example: $0 qa capacity.csv"
    exit 1
fi

ENVIRONMENT=$1
DATA_FILE=$2

# Validate environment argument
if [ "$ENVIRONMENT" != "prod" ] && [ "$ENVIRONMENT" != "qa" ]; then
    echo "Error: Environment must be 'prod' or 'qa'"
    echo "Usage: $0 <prod|qa> <data_file>"
    exit 1
fi

# Extract upload type from data file (remove .csv extension if present)
UPLOAD_TYPE=${DATA_FILE%.csv}

# Run the upload command
echo "Running upload for file: $DATA_FILE, environment: $ENVIRONMENT"
node scripts/upload-csv.js $UPLOAD_TYPE $ENVIRONMENT -d data