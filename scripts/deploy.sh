#!/bin/bash
set -e
# Echo commands before executing them
set -x

echo do we have jq?
jq --version
echo do we have aws?
aws --version

npm run deploy:ci

echo env=/${VKD_ENVIRONMENT}/
echo AWS_ACCESS_KEY_ID=/${AWS_ACCESS_KEY_ID}/
echo get secret?
aws secretsmanager get-secret-value --secret-id "openai-config/${VKD_ENVIRONMENT}"

echo set openai key?
export OPENAI_API_KEY=$(aws secretsmanager get-secret-value --secret-id "openai-config/${VKD_ENVIRONMENT}" | jq -r '.SecretString' | jq -r ".OPENAI_API_KEY")

echo key=/$OPENAI_API_KEY/
npx ts-node src/sync-assistant.ts
