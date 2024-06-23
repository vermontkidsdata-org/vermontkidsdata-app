#!/bin/sh
npm run deploy:ci
export OPENAI_API_KEY=`aws secretsmanager get-secret-value --secret-id openai-config/$VKD_ENVIRONMENT | jq -r '.SecretString' | jq -r ".OPENAI_API_KEY"`
echo key=$OPENAI_API_KEY
npx ts-node src/sync-assistant.ts
