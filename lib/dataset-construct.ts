import { Duration, NestedStack, NestedStackProps } from "aws-cdk-lib";
import { LambdaIntegration, MethodOptions, RestApi } from "aws-cdk-lib/aws-apigateway";
import { ITable } from "aws-cdk-lib/aws-dynamodb";
import { PolicyStatement } from "aws-cdk-lib/aws-iam";
import { Runtime, Tracing } from "aws-cdk-lib/aws-lambda";
import { SqsEventSource } from "aws-cdk-lib/aws-lambda-event-sources";
import { NodejsFunction } from "aws-cdk-lib/aws-lambda-nodejs";
import { RetentionDays } from "aws-cdk-lib/aws-logs";
import { Bucket, EventType } from "aws-cdk-lib/aws-s3";
import { SqsDestination } from "aws-cdk-lib/aws-s3-notifications";
import { ISecret } from "aws-cdk-lib/aws-secretsmanager";
import { Queue } from "aws-cdk-lib/aws-sqs";
import { Construct } from "constructs";
import { join } from "path";
import { AuthInfo, OnAddCallback } from "./cdk-utils";

interface DatasetConstructProps extends NestedStackProps {
  api: RestApi;
  commonEnv: Record<string, string>;
  methodOptions?: MethodOptions;
  auth?: AuthInfo;
  onAdd?: OnAddCallback;
  serviceTable: ITable;
  secret: ISecret;
  bucket: Bucket;
  queue: Queue;
  uploadQueue: Queue;
  runtime: Runtime;
  getDataSetYearsByDatasetFunction?: any; // Lambda function for years endpoint
}

export class DatasetConstruct extends NestedStack {
  constructor(scope: Construct, id: string, props: DatasetConstructProps) {
    super(scope, id);
    
    const { api, commonEnv, methodOptions, auth, onAdd, serviceTable, secret, bucket, queue, uploadQueue, runtime, getDataSetYearsByDatasetFunction } = props;
    const bucketName = bucket.bucketName;
    
    const getSecretValueStatement = new PolicyStatement({
      actions: ["secretsmanager:GetSecretValue"],
      resources: ["*"],
    });
    
    // 1. Upload Data Function
    const uploadFunction = new NodejsFunction(this, 'Upload Data Function', {
      memorySize: 512,
      timeout: Duration.seconds(900),
      runtime,
      entry: join(__dirname, "../src/uploadData.ts"),
      handler: 'main',
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    bucket.grantRead(uploadFunction);
    queue.grantSendMessages(uploadFunction);
    serviceTable.grantReadWriteData(uploadFunction);
    uploadFunction.addToRolePolicy(getSecretValueStatement);
    
    // Add SQS event source to trigger the upload function when messages are received
    uploadFunction.addEventSource(new SqsEventSource(uploadQueue, {
      batchSize: 1,
    }));
    
    if (onAdd) onAdd(uploadFunction);
    
    // Configure S3 bucket to send notifications to SQS when objects are created
    bucket.addEventNotification(EventType.OBJECT_CREATED, new SqsDestination(uploadQueue));
    
    // 2. Dataset Backup Function
    const datasetBackupFunction = new NodejsFunction(this, 'Dataset Backup Function', {
      memorySize: 1024,
      timeout: Duration.minutes(15),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/datasetBackup.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    
    datasetBackupFunction.addToRolePolicy(getSecretValueStatement);
    datasetBackupFunction.addEventSource(new SqsEventSource(queue, {
      batchSize: 1,
    }));
    serviceTable.grantReadWriteData(datasetBackupFunction);
    bucket.grantReadWrite(datasetBackupFunction);
    if (onAdd) onAdd(datasetBackupFunction);
    
    // 3. List Dataset Backups Function
    const listDataSetBackupsFunction = new NodejsFunction(this, 'List Dataset Backups Function', {
      memorySize: 1024,
      timeout: Duration.minutes(1),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/datasetBackupList.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(listDataSetBackupsFunction);
    if (onAdd) onAdd(listDataSetBackupsFunction);
    
    // 4. Get Dataset Backup Function
    const getDataSetBackupFunction = new NodejsFunction(this, 'Get Dataset Backup Function', {
      memorySize: 1024,
      timeout: Duration.minutes(15),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/datasetBackupGet.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(getDataSetBackupFunction);
    bucket.grantReadWrite(getDataSetBackupFunction);
    if (onAdd) onAdd(getDataSetBackupFunction);
    
    // 5. Dataset Revert Function
    const dataSetRevertFunction = new NodejsFunction(this, 'Dataset Revert Function', {
      memorySize: 1024,
      timeout: Duration.minutes(15),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/datasetBackupRevert.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(dataSetRevertFunction);
    bucket.grantReadWrite(dataSetRevertFunction);
    dataSetRevertFunction.addToRolePolicy(getSecretValueStatement);
    if (onAdd) onAdd(dataSetRevertFunction);
    
    // 6. Upload Status Function
    const uploadStatusFunction = new NodejsFunction(this, 'Upload Status Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'handler',
      entry: join(__dirname, "../src/upload-get-status.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(uploadStatusFunction);
    if (onAdd) onAdd(uploadStatusFunction);
    
    // 7. Dataset Post API Function
    const datasetPostFunction = new NodejsFunction(this, 'Dataset post API Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'handlerPost',
      entry: join(__dirname, "../src/dataset-api.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(datasetPostFunction);
    if (onAdd) onAdd(datasetPostFunction);
    
    // Add API Gateway resources and methods
    const uploadStatusPath = api.root.addResource('upload-status');
    uploadStatusPath.addResource('{id}').addMethod('GET', new LambdaIntegration(uploadStatusFunction), methodOptions);
    
    const datasetRoot = api.root.addResource('dataset');
    datasetRoot.addMethod('POST', new LambdaIntegration(datasetPostFunction), methodOptions);
    
    const backupPath = datasetRoot.addResource('backup');
    backupPath.addMethod('GET', new LambdaIntegration(listDataSetBackupsFunction), methodOptions);
    
    const backupIdPath = backupPath.addResource('{id}');
    backupIdPath.addMethod('GET', new LambdaIntegration(getDataSetBackupFunction), methodOptions);
    
    const revertPath = backupIdPath.addResource('revert');
    revertPath.addMethod('POST', new LambdaIntegration(dataSetRevertFunction), methodOptions);
    
    // Add years endpoint if function is provided
    if (getDataSetYearsByDatasetFunction) {
      const yearsPath = datasetRoot.addResource('years');
      const yearsDatasetPath = yearsPath.addResource('{dataset}');
      yearsDatasetPath.addMethod('GET', new LambdaIntegration(getDataSetYearsByDatasetFunction));
    }
  }
}