#!/bin/bash
set -e

echo do we have jq?
jq --version
echo do we have aws?
aws --version

npm run deploy:ci

echo env=/${VKD_ENVIRONMENT}/
aws secretsmanager get-secret-value --secret-id "openai-config/${VKD_ENVIRONMENT}"
export OPENAI_API_KEY=$(aws secretsmanager get-secret-value --secret-id "openai-config/${VKD_ENVIRONMENT}" | jq -r '.SecretString' | jq -r ".OPENAI_API_KEY")
echo key=$OPENAI_API_KEY
npx ts-node src/sync-assistant.ts
