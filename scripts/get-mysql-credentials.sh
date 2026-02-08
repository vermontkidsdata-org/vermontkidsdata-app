#!/bin/bash

# Script to get MySQL credentials from AWS Secrets Manager and provide MySQL CLI access
# Usage: bash scripts/get-mysql-credentials.sh [environment]

set -e

# Default to qa environment if not specified
ENVIRONMENT=${1:-qa}

echo "Getting MySQL credentials for environment: $ENVIRONMENT"

# Get the secret from AWS Secrets Manager
SECRET_ID="vkd/$ENVIRONMENT/dbcreds"
echo "Fetching secret: $SECRET_ID"

# Retrieve the secret
SECRET_JSON=$(aws secretsmanager get-secret-value \
    --secret-id "$SECRET_ID" \
    --region us-east-1 \
    --profile BBF \
    --query SecretString \
    --output text)

if [ -z "$SECRET_JSON" ]; then
    echo "Error: Could not retrieve secret $SECRET_ID"
    exit 1
fi

# Parse the JSON to extract credentials
HOST=$(echo "$SECRET_JSON" | jq -r '.host')
USERNAME=$(echo "$SECRET_JSON" | jq -r '.username')
PASSWORD=$(echo "$SECRET_JSON" | jq -r '.password')
SCHEMA=$(echo "$SECRET_JSON" | jq -r '.schema')

echo "Database connection details:"
echo "Host: $HOST"
echo "Username: $USERNAME"
echo "Schema: $SCHEMA"
echo "Password: [hidden]"
echo ""

# Provide different options for MySQL access
echo "=== MySQL CLI Access Options ==="
echo ""
echo "1. Direct mysql command:"
echo "mysql -h $HOST -u $USERNAME -p$PASSWORD $SCHEMA"
echo ""
echo "2. Interactive mysql with password prompt (more secure):"
echo "mysql -h $HOST -u $USERNAME -p $SCHEMA"
echo "   (then enter password when prompted)"
echo ""
echo "3. Create a temporary .my.cnf file:"
cat << EOF > /tmp/mysql-$ENVIRONMENT.cnf
[client]
host=$HOST
user=$USERNAME
password=$PASSWORD
database=$SCHEMA
EOF
echo "mysql --defaults-file=/tmp/mysql-$ENVIRONMENT.cnf"
echo ""
echo "4. Export as environment variables:"
echo "export MYSQL_HOST='$HOST'"
echo "export MYSQL_USER='$USERNAME'"
echo "export MYSQL_PASSWORD='$PASSWORD'"
echo "export MYSQL_DATABASE='$SCHEMA'"
echo ""
echo "=== Quick Actions ==="
echo ""
echo "To connect directly (will prompt for password):"
echo "mysql -h $HOST -u $USERNAME -p $SCHEMA"
echo ""
echo "To execute SQL files:"
echo "mysql -h $HOST -u $USERNAME -p $SCHEMA < your-script.sql"
echo ""
echo "To execute the generated Act76 insert statements:"
echo "mysql -h $HOST -u $USERNAME -p $SCHEMA < scripts/act76-child-inserts-$(date +%Y%m%d).sql"