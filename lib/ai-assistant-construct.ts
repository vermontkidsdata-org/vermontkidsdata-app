import { Duration, NestedStack, NestedStackProps } from "aws-cdk-lib";
import { MethodOptions, RestApi } from "aws-cdk-lib/aws-apigateway";
import { ITable } from "aws-cdk-lib/aws-dynamodb";
import { ISecret, Secret } from "aws-cdk-lib/aws-secretsmanager";
import { StateMachine } from "aws-cdk-lib/aws-stepfunctions";
import { LambdaInvoke } from "aws-cdk-lib/aws-stepfunctions-tasks";
import { Construct } from "constructs";
import { IN_PROGRESS_ERROR } from "../src/ai-utils";
import { AuthInfo, OnAddCallback, addLambdaResource, makeLambda } from "./cdk-utils";
import { ManagedPolicy, Role, ServicePrincipal } from "aws-cdk-lib/aws-iam";
import { Bucket } from "aws-cdk-lib/aws-s3";

interface AIAssistantProps extends NestedStackProps {
  api: RestApi;
  methodOptions?: MethodOptions;
  auth?: AuthInfo;
  commonEnv: Record<string, string>;
  onAdd?: OnAddCallback;
  serviceTable: ITable;
  secret: ISecret;
  ns: string;
  bucketName: string;
}
export const VKD_API_KEY = '09848734-8745-afrt-8745-8745873487';

export class AIAssistantConstruct extends NestedStack {
  _props: AIAssistantProps;

  constructor(scope: Construct, id: string, props: AIAssistantProps) {
    super(scope, id);
    this._props = props;

    const { api, commonEnv, onAdd, methodOptions, auth, serviceTable, secret, ns, bucketName } = props;
    const aiAssistantRoot = api.root.addResource('ai');

    const aiSecret = Secret.fromSecretNameV2(this, 'AI Secret', `openai-config/${ns}`);
    // const { assistantId } = getAssistantInfo(ns);

    const aiCommonEnv = {
      ...commonEnv,
      // ASSISTANT_ID: assistantId,
      VKD_STATE_MACHINE_ARN: '',
      SERVICE_TABLE: serviceTable.tableName,
      AI_SECRET_NAME: aiSecret.secretName,
      VKD_API_KEY,
      S3_BUCKET_NAME: bucketName,
    };

    const bucket = Bucket.fromBucketName(this, 'AI Assistant Bucket', bucketName);

    // Get the role for all the lambdas
    const role = new Role(this, 'AI Assistant Lambda Role', {
      assumedBy: new ServicePrincipal('lambda.amazonaws.com'),
      managedPolicies: [
        ManagedPolicy.fromAwsManagedPolicyName('service-role/AWSLambdaBasicExecutionRole'),
      ],
    });
    serviceTable.grantReadWriteData(role);
    aiSecret.grantRead(role);
    secret.grantRead(role);

    const startOpenAICompletion = makeLambda({
      scope: this,
      name: 'Start OpenAI Completion',
      entry: 'ai-start-openai-completion.ts',
      timeout: Duration.minutes(15),
      commonEnv: aiCommonEnv,
      onAdd,
      role,
    });
    ((fn) => {
      // Grant the Lambda function access to the S3 bucket
      bucket.grantReadWrite(fn);
    })(startOpenAICompletion);

    const checkOpenAICompletion = makeLambda({
      scope: this,
      name: 'Check OpenAI Completion',
      entry: 'ai-check-openai-completion.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      role,
    });
    ((fn) => {
    })(checkOpenAICompletion);

    const generateTitle = makeLambda({
      scope: this,
      name: 'Generate Title',
      entry: 'ai-generate-title.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      role,
    });
    ((fn) => {
    })(generateTitle);

    const checkComplete = new LambdaInvoke(this, 'Invoke Check OpenAI Completion', {
      lambdaFunction: checkOpenAICompletion,
      outputPath: '$.Payload',
    });
    checkComplete.addRetry({
      errors: [IN_PROGRESS_ERROR],
      interval: Duration.seconds(5),
      maxAttempts: 120,
      backoffRate: 1.0,
    });

    const generateTitleStep = new LambdaInvoke(this, 'Invoke Generate Title', {
      lambdaFunction: generateTitle,
      outputPath: '$.Payload',
    });

    const definition =
      new LambdaInvoke(this, 'Invoke Start OpenAI Completion', {
        lambdaFunction: startOpenAICompletion,
        outputPath: '$.Payload',
      }).next(checkComplete).next(generateTitleStep);

    const sf = new StateMachine(this, `${ns}-AIAssistant`, {
      tracingEnabled: true,
      definition,
    });
    startOpenAICompletion.grantInvoke(sf);
    checkOpenAICompletion.grantInvoke(sf);
    generateTitle.grantInvoke(sf);

    aiCommonEnv.VKD_STATE_MACHINE_ARN = sf.stateMachineArn;

    // Mix in the auth (POST endpoints only)
    const methodOptionsWithAuth = {
      ...methodOptions,
      // ...auth,
    };

    (({ fn }) => {
      sf.grantStartExecution(fn);
      aiSecret.grantRead(fn);
      bucket.grantReadWrite(fn);
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'completion',
      entry: 'ai-post-completion.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      serviceTable,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'completion/{id}/{sortKey}',
      entry: 'ai-get-completion.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // Get all completions for a conversation by id
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'completion/{id}',
      entry: 'ai-get-completions-by-id.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'completion/{id}/{sortKey}',
      entry: 'ai-post-update.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
      sf.grantStartExecution(fn);
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'completions',
      entry: 'ai-get-completions.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      serviceTable,
    }));

    // Assistant admin endpoints
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'assistant',
      entry: 'ai-get-assistants.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'assistant/{id}',
      entry: 'ai-get-assistant.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'assistant/{id}/function',
      entry: 'ai-get-assistant-functions.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'assistant/{id}/function/{functionId}',
      entry: 'ai-get-assistant-function.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'assistant/{id}/function/{functionId}/test',
      entry: 'ai-post-assistant-function-test.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'PUT',
      path: 'assistant/{id}/function/{functionId}',
      entry: 'ai-put-assistant-function.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'assistant/{id}/publish',
      entry: 'ai-post-assistant-publish.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'assistant/{id}/function',
      entry: 'ai-post-assistant-function.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // Clone an assistant, typically from the "main" assistant for the environment
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'assistant/{id}/clone',
      entry: 'ai-post-assistant-clone.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'assistant/{id}/enable',
      entry: 'ai-post-assistant-enable.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'document',
      entry: 'ai-get-documents.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // (({ fn }) => {
    // })(addLambdaResource({
    //   scope: this,
    //   root: aiAssistantRoot,
    //   method: 'GET',
    //   path: 'document/{id}',
    //   entry: 'ai-get-document.ts',
    //   commonEnv: aiCommonEnv,
    //   onAdd,
    //   methodOptions: methodOptionsWithAuth,
    //   role,
    // }));

    // PUT /ai/assisant/{id}
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'PUT',
      path: 'assistant/{id}',
      entry: 'ai-put-assistant.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // POST /ai/assistant
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'assistant',
      entry: 'ai-post-assistant.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // GET /ai/assistant/{id}/documents
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'assistant/{id}/documents',
      entry: 'ai-get-assistant-documents.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // POST /ai/assisant/{id}/documents
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'assistant/{id}/documents',
      entry: 'ai-post-assistant-documents.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // GET /ai/assistant/{id}/export - Export assistant definition
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'assistant/{id}/export',
      entry: 'ai-assistant-download.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // POST /ai/assistant/import - Import assistant definition
    (({ fn }) => {
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'assistant/import',
      entry: 'ai-assistant-upload.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

    // POST /ai/mcp - MCP server endpoint for tool calls
    (({ fn }) => {
      aiSecret.grantRead(fn);
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'mcp',
      entry: 'ai-mcp-server.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
      role,
    }));

  }

}

