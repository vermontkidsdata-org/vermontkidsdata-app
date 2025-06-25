# Vermont Kids' Data project

# CloudWatch log groups

Download function QA
https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#logsV2:log-groups/log-group/%2Faws%2Flambda%2Fqa-LocalDevBranch-DownloadFunction40EABBE7-JcC66wrB9mfM

Need to create some secrets first.

aws secretsmanager create-secret --name VKDPipelineGitHubToken --description "The GitHub access token for the VKD pipeline." --secret-string "{\"access-token\":\"XXXXXXXXXXXX\"}"
aws secretsmanager create-secret --name "vkd/prod/dbcreds" --secret-string "{\"username\":\"XXXXXXXXXXXX\", \"password\":\"XXXXXXXXXXXX\", \"host\": \"XXXXXXXX\"}"

Ditto for vkd/qa/dbcreds

# To deploy to personal cloud environment

1. Create a branch that starts with `dev/` and is unique to what you're doing. E.g. `dev/census-bar-chart`. Nobody else should
generally be using the same exact name.
2. `cdk deploy --profile vkd` assuming you have an AWS profile set up called `vkd`.

# To run lambdas locally
1. Create a local file called `.env.json` like this:
```
{
    "port": 3000,
    "apiurl": "https://jrnkzrwp0l.execute-api.us-east-1.amazonaws.com/prod"   <-- wherever the data API lambda is
}
```
2. `npm run watch`
3. In browser go to `http://localhost:3000/render/chart/bar/1234`

## Useful CDK commands

 * `npm run build`   compile typescript to js
 * `npm run watch`   watch for changes and compile
 * `npm run test`    perform the jest unit tests
 * `cdk deploy`      deploy this stack to your default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk synth`       emits the synthesized CloudFormation template

## AI Completion API

### POST /ai/completion

This endpoint allows you to send queries to the AI assistant and receive completions. It supports both standard JSON requests and file uploads via multipart/form-data.

#### Basic JSON Request

```json
POST /ai/completion
Content-Type: application/json

{
  "key": "your-api-key",
  "id": "conversation-id",
  "sortKey": 0,
  "query": "Your question to the AI assistant",
  "stream": true,
  "type": "assistant-type",
  "sandbox": "optional-sandbox-name"
}
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| key | string | Yes | Your API key for authentication |
| id | string | Yes | Conversation ID (unique identifier for the conversation) |
| sortKey | number | Yes | Message number in the conversation (0 for first message) |
| query | string | Yes | The question or prompt for the AI assistant |
| stream | boolean | No | Whether to stream the response (default: false) |
| type | string | No | The type of assistant to use (default: VKD) |
| sandbox | string | No | Optional sandbox environment name |

#### File Upload Request

To upload a file along with your query, use multipart/form-data:

```
POST /ai/completion
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="key"

your-api-key
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="id"

conversation-id
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="sortKey"

0
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="query"

Analyze the content of this file
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="document.pdf"
Content-Type: application/pdf

[Binary PDF data]
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

The file will be uploaded to OpenAI and made available to the assistant for the completion. Supported file types include text files and PDFs.

#### Response

```json
{
  "message": "Processing request",
  "id": "conversation-id",
  "sortKey": 0,
  "uploadedFile": {
    "name": "document.pdf",
    "mime": "application/pdf"
  }
}
```

To retrieve the completion result, use the GET /ai/completion/{id}/{sortKey} endpoint.

### Example Usage with curl

#### JSON Request
```bash
curl -X POST https://api.example.com/ai/completion \
  -H "Content-Type: application/json" \
  -d '{
    "key": "your-api-key",
    "id": "conversation-123",
    "sortKey": 0,
    "query": "What is the capital of Vermont?",
    "stream": false
  }'
```

#### File Upload
```bash
curl -X POST https://api.example.com/ai/completion \
  -H "Content-Type: multipart/form-data" \
  -F "key=your-api-key" \
  -F "id=conversation-123" \
  -F "sortKey=0" \
  -F "query=Analyze this document" \
  -F "file=@/path/to/document.pdf"
```
