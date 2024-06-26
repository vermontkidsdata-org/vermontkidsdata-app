import { Duration } from "aws-cdk-lib";
import { MethodOptions, RestApi } from "aws-cdk-lib/aws-apigateway";
import { ITable } from "aws-cdk-lib/aws-dynamodb";
import { ISecret, Secret } from "aws-cdk-lib/aws-secretsmanager";
import { StateMachine } from "aws-cdk-lib/aws-stepfunctions";
import { LambdaInvoke } from "aws-cdk-lib/aws-stepfunctions-tasks";
import { Construct } from "constructs";
import { IN_PROGRESS_ERROR } from "../src/ai-utils";
import { getAssistantInfo } from "../src/assistant-def";
import { AuthInfo, OnAddCallback, addLambdaResource, makeLambda } from "./cdk-utils";

interface AIAssistantProps {
  api: RestApi;
  methodOptions?: MethodOptions;
  auth?: AuthInfo;
  commonEnv: Record<string, string>;
  onAdd?: OnAddCallback;
  serviceTable: ITable;
  secret: ISecret;
  ns: string;
}
const VKD_API_KEY = '09848734-8745-afrt-8745-8745873487';

export class AIAssistantConstruct extends Construct {
  _props: AIAssistantProps;

  constructor(scope: Construct, id: string, props: AIAssistantProps) {
    super(scope, id);
    this._props = props;

    const { api, commonEnv, onAdd, methodOptions, auth, serviceTable, secret, ns, } = props;
    const aiAssistantRoot = api.root.addResource('ai');

    const aiSecret = Secret.fromSecretNameV2(this, 'AI Secret', `openai-config/${ns}`);
    const {assistantId} = getAssistantInfo(ns);

    const aiCommonEnv = {
      ...commonEnv,
      ASSISTANT_ID: assistantId,
      VKD_STATE_MACHINE_ARN: '',
      SERVICE_TABLE: serviceTable.tableName,
      AI_SECRET_NAME: aiSecret.secretName,
      VKD_API_KEY,
    };

    const startOpenAICompletion = makeLambda({
      scope: this,
      name: 'Start OpenAI Completion',
      entry: 'ai-start-openai-completion.ts',
      timeout: Duration.minutes(15),
      commonEnv: aiCommonEnv,
      onAdd,
    });
    ((fn) => {
      serviceTable.grantReadWriteData(fn);
      aiSecret.grantRead(fn);
      secret.grantRead(fn);
    })(startOpenAICompletion);

    const checkOpenAICompletion = makeLambda({
      scope: this,
      name: 'Check OpenAI Completion',
      entry: 'ai-check-openai-completion.ts',
      commonEnv: aiCommonEnv,
      onAdd,
    });
    ((fn) => {
      serviceTable.grantReadWriteData(fn);
      aiSecret.grantRead(fn);
      secret.grantRead(fn);
    })(checkOpenAICompletion);

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

    const definition =
      new LambdaInvoke(this, 'Invoke Start OpenAI Completion', {
        lambdaFunction: startOpenAICompletion,
        outputPath: '$.Payload',
      }).next(checkComplete);

    const sf = new StateMachine(this, `${ns}-AIAssistant`, {
      tracingEnabled: true,
      definition,
    });
    startOpenAICompletion.grantInvoke(sf);
    checkOpenAICompletion.grantInvoke(sf);

    aiCommonEnv.VKD_STATE_MACHINE_ARN = sf.stateMachineArn;

    // Mix in the auth (POST endpoints only)
    const methodOptionsWithAuth = {
      ...methodOptions,
      // ...auth,
    };

    (({ fn }) => {
      sf.grantStartExecution(fn);
      aiSecret.grantRead(fn);
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'completion',
      entry: 'ai-post-completion.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
    }));

    (({ fn }) => {
      serviceTable.grantReadData(fn);
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'GET',
      path: 'completion/{id}/{sortKey}',
      entry: 'ai-get-completion.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
    }));

    (({ fn }) => {
      serviceTable.grantReadData(fn);
    })(addLambdaResource({
      scope: this,
      root: aiAssistantRoot,
      method: 'POST',
      path: 'completion/{id}/{sortKey}',
      entry: 'ai-post-update.ts',
      commonEnv: aiCommonEnv,
      onAdd,
      methodOptions: methodOptionsWithAuth,
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
    }));
  }
}

