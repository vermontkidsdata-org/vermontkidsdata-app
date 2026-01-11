#!/bin/bash

# Check if at least 2 arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <prod|qa> <data_file1> [data_file2] [data_file3] ..."
    echo "Example: $0 qa capacity"
    echo "Example: $0 qa capacity.csv building_broadband_access.csv"
    exit 1
fi

ENVIRONMENT=$1
shift  # Remove first argument, leaving only file arguments

# Validate environment argument
if [ "$ENVIRONMENT" != "prod" ] && [ "$ENVIRONMENT" != "qa" ]; then
    echo "Error: Environment must be 'prod' or 'qa'"
    echo "Usage: $0 <prod|qa> <data_file1> [data_file2] [data_file3] ..."
    exit 1
fi

# Loop through all remaining arguments (data files)
for DATA_FILE in "$@"; do
    # Extract upload type from data file (remove .csv extension if present)
    UPLOAD_TYPE=${DATA_FILE%.csv}
    
    # Run the upload command (from data directory, so we need to go up one level)
    COMMAND="node ../scripts/upload-csv.js $UPLOAD_TYPE $ENVIRONMENT -d ."
    echo "Running upload for file: $DATA_FILE, environment: $ENVIRONMENT"
    echo "Command: $COMMAND"
    $COMMAND
    echo ""  # Add blank line between uploads
done