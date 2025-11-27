# Stack Refactoring Plan to Stay Under 500 Resource Limit

## Current Issue
The CloudFormation stack has exceeded the 500 resource limit (currently at 510 resources). This prevents us from deploying our new assistant export/import functionality.

## Resource Distribution Analysis
Based on the error message, the stack currently has:
- 143 API Gateway Methods
- 79 API Gateway Resources
- 125 Lambda Permissions
- 33 Lambda Functions
- Various other resources (S3 buckets, IAM roles, etc.)

## Proposed Solution
Create a new nested stack for dataset-related functions to reduce the resource count in the main stack.

### 1. Create a DatasetConstruct Nested Stack

```typescript
// lib/dataset-construct.ts
import { Duration, NestedStack, NestedStackProps } from "aws-cdk-lib";
import { RestApi } from "aws-cdk-lib/aws-apigateway";
import { ITable } from "aws-cdk-lib/aws-dynamodb";
import { ISecret } from "aws-cdk-lib/aws-secretsmanager";
import { SqsEventSource } from "aws-cdk-lib/aws-lambda-event-sources";
import { Runtime, Tracing } from "aws-cdk-lib/aws-lambda";
import { NodejsFunction } from "aws-cdk-lib/aws-lambda-nodejs";
import { RetentionDays } from "aws-cdk-lib/aws-logs";
import { Queue } from "aws-cdk-lib/aws-sqs";
import { Bucket } from "aws-cdk-lib/aws-s3";
import { Construct } from "constructs";
import { join } from "path";
import { PolicyStatement } from "aws-cdk-lib/aws-iam";
import { AuthInfo } from "./cdk-utils";

interface DatasetConstructProps extends NestedStackProps {
  api: RestApi;
  commonEnv: Record<string, string>;
  auth?: AuthInfo;
  serviceTable: ITable;
  secret: ISecret;
  bucket: Bucket;
  queue: Queue;
  runtime: Runtime;
}

export class DatasetConstruct extends NestedStack {
  constructor(scope: Construct, id: string, props: DatasetConstructProps) {
    super(scope, id);
    
    const { api, commonEnv, auth, serviceTable, secret, bucket, queue, runtime } = props;
    const bucketName = bucket.bucketName;
    
    // Create dataset-related Lambda functions
    
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
    
    const getSecretValueStatement = new PolicyStatement({
      actions: ["secretsmanager:GetSecretValue"],
      resources: ["*"],
    });
    
    datasetBackupFunction.addToRolePolicy(getSecretValueStatement);
    datasetBackupFunction.addEventSource(new SqsEventSource(queue, {
      batchSize: 1,
    }));
    serviceTable.grantReadWriteData(datasetBackupFunction);
    bucket.grantReadWrite(datasetBackupFunction);
    
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
    
    // 6. Upload Status Function
    const uploadStatusFunction = new NodejsFunction(this, 'Upload Status Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/upload-get-status.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(uploadStatusFunction);
    
    // 7. Dataset Post API Function
    const datasetPostFunction = new NodejsFunction(this, 'Dataset Post API Function', {
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
    
    // Add API Gateway resources and methods
    const datasetRoot = api.root.addResource('dataset');
    
    // Upload status endpoint
    const uploadStatusPath = api.root.addResource('upload-status');
    uploadStatusPath.addResource('{id}').addMethod('GET', new LambdaIntegration(uploadStatusFunction), auth);
    
    // Dataset endpoints
    datasetRoot.addMethod('POST', new LambdaIntegration(datasetPostFunction), auth);
    
    // Dataset backup endpoints
    const backupPath = datasetRoot.addResource('backup');
    backupPath.addMethod('GET', new LambdaIntegration(listDataSetBackupsFunction), auth);
    
    const backupIdPath = backupPath.addResource('{id}');
    backupIdPath.addMethod('GET', new LambdaIntegration(getDataSetBackupFunction), auth);
    
    const revertPath = backupIdPath.addResource('revert');
    revertPath.addMethod('POST', new LambdaIntegration(dataSetRevertFunction), auth);
  }
}
```

### 2. Modify Main Stack to Use the Dataset Nested Stack

```typescript
// In VermontkidsdataStack constructor
// Replace the dataset functions with:

const datasetConstruct = new DatasetConstruct(this, 'Dataset Functions', {
  api,
  commonEnv,
  auth,
  serviceTable,
  secret,
  bucket,
  queue,
  runtime,
});
```

### 3. Remove Dataset Functions from Main Stack
- Remove uploadFunction
- Remove datasetBackupFunction
- Remove listDataSetBackupsFunction
- Remove getDataSetBackupFunction
- Remove dataSetRevertFunction
- Remove uploadStatusFunction
- Remove datasetPostFunction
- Remove related API Gateway resources and methods

## Expected Outcome
This refactoring should reduce the resource count in the main stack by approximately:
- 7 Lambda Functions
- 7+ IAM Roles/Policies
- 15+ API Gateway Methods
- 7+ API Gateway Resources
- 7+ Lambda Permissions

This should bring the total resource count below the 500 limit, allowing us to deploy our new assistant export/import functionality.

## Implementation Steps
1. Create the new `DatasetConstruct` class in `lib/dataset-construct.ts`
2. Modify `VermontkidsdataStack` to use the new nested stack
3. Remove dataset-related resources from the main stack
4. Deploy the changes
5. Verify that all dataset functionality still works correctly
6. Deploy our new assistant export/import functionality