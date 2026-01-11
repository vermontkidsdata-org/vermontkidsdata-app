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

# Set DynamoDB table name based on environment
if [ "$ENVIRONMENT" = "prod" ]; then
    TABLE_NAME="master-LocalDevBranch-SingleServiceTableABC698C2-FNHLW4FT8XVJ"  # Update with actual prod table name
else
    TABLE_NAME="qa-LocalDevBranch-SingleServiceTableABC698C2-3Z52F7FCI8WH"
fi

# Validate that the DynamoDB table exists
echo "Validating DynamoDB table: $TABLE_NAME"
TABLE_CHECK=$(aws dynamodb describe-table \
    --table-name "$TABLE_NAME" \
    --profile BBF \
    --region us-east-1 \
    --output json 2>&1)

if [ $? -ne 0 ]; then
    echo "ERROR: DynamoDB table '$TABLE_NAME' does not exist or is not accessible."
    echo "Table check output: $TABLE_CHECK"
    echo "Please verify the table name and AWS credentials."
    exit 1
fi

echo "DynamoDB table validated successfully."

# Function to check upload status
check_upload_status() {
    local identifier=$1
    local max_attempts=60  # Maximum attempts (10 minutes with 10-second intervals)
    local attempt=0
    
    echo "Monitoring upload status for identifier: $identifier"
    
    while [ $attempt -lt $max_attempts ]; do
        # Query DynamoDB for the upload status
        STATUS_JSON=$(aws dynamodb get-item \
            --table-name "$TABLE_NAME" \
            --key "{\"PK\":{\"S\":\"UPLOADSTATUS#$identifier\"},\"SK\":{\"S\":\"UPLOADSTATUS#$identifier\"}}" \
            --profile BBF \
            --region us-east-1 \
            --output json 2>&1)
        
        
        if [ $? -eq 0 ] && [ "$STATUS_JSON" != "null" ] && [ "$STATUS_JSON" != "" ]; then
            # Check if item exists in the response
            if echo "$STATUS_JSON" | grep -q '"Item"'; then
                # Use Node.js to parse the DynamoDB JSON response
                PARSED_VALUES=$(echo "$STATUS_JSON" | node -e "
                    const stdin = process.stdin;
                    let data = '';
                    stdin.on('readable', () => {
                        const chunk = stdin.read();
                        if (chunk !== null) data += chunk;
                    });
                    stdin.on('end', () => {
                        try {
                            const json = JSON.parse(data);
                            const status = json.Item?.status?.S || '';
                            const percent = json.Item?.percent?.N || '0';
                            const errors = json.Item?.errors?.L || [];
                            const errorMessages = errors.map(e => e.S || '').join('; ');
                            console.log(status + '|' + percent + '|' + errorMessages);
                        } catch (e) {
                            console.log('|0');
                        }
                    });
                ")
                
                STATUS=$(echo "$PARSED_VALUES" | cut -d'|' -f1)
                PERCENT=$(echo "$PARSED_VALUES" | cut -d'|' -f2)
                ERRORS=$(echo "$PARSED_VALUES" | cut -d'|' -f3-)
                
                echo "Status: $STATUS, Progress: ${PERCENT}%"
            else
                echo "Upload record not found yet (attempt $((attempt + 1))/$max_attempts)"
                attempt=$((attempt + 1))
                sleep 10
                continue
            fi
            
            # Check if upload is complete
            if [ "$STATUS" = "Complete" ]; then
                echo "Upload completed successfully!"
                return 0
            elif [ "$STATUS" = "Error" ] || [ "$STATUS" = "Failed" ]; then
                echo "Upload failed with status: $STATUS"
                if [ -n "$ERRORS" ]; then
                    echo "Error details: $ERRORS"
                else
                    echo "No error details available"
                fi
                return 1
            else
                # Status is in progress, sleep briefly and check again
                sleep 2
            fi
        else
            echo "Status not yet available (attempt $((attempt + 1))/$max_attempts)"
            # Add some debugging for the first few attempts to see what's happening
            if [ $attempt -lt 3 ]; then
                echo "DEBUG: AWS CLI exit code: $?, Response: '$STATUS_JSON'"
            fi
            sleep 1
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo "Timeout waiting for upload to complete"
    return 1
}

# Loop through all remaining arguments (data files)
for DATA_FILE in "$@"; do
    # Extract upload type from data file (remove .csv extension if present)
    UPLOAD_TYPE=${DATA_FILE%.csv}
    
    # Run the upload command (from data directory, so we need to go up one level)
    COMMAND="node ../scripts/upload-csv.js $UPLOAD_TYPE $ENVIRONMENT -d ."
    echo "Running upload for file: $DATA_FILE, environment: $ENVIRONMENT"
    echo "Command: $COMMAND"
    
    # Capture the output to extract the identifier
    OUTPUT=$($COMMAND 2>&1)
    echo "$OUTPUT"
    
    # Extract the identifier from the output
    IDENTIFIER=$(echo "$OUTPUT" | grep -o 'identifier: [^,]*' | sed 's/identifier: //' | tr -d "'" | tr -d '"')
    
    if [ -z "$IDENTIFIER" ]; then
        echo "ERROR: Could not extract identifier from upload command output"
        echo "Skipping status monitoring for this file"
    else
        echo "Extracted identifier: $IDENTIFIER"
        
        # Monitor the upload status
        if ! check_upload_status "$IDENTIFIER"; then
            echo "Upload failed or timed out. Stopping processing."
            exit 1
        fi
    fi
    
    echo ""  # Add blank line between uploads
done

echo "All uploads completed successfully!"