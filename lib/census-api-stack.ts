import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as s3notify from 'aws-cdk-lib/aws-s3-notifications';
import * as logs from 'aws-cdk-lib/aws-logs';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import * as s3Deploy from 'aws-cdk-lib/aws-s3-deployment';
import * as s3Asset from 'aws-cdk-lib/aws-s3-assets';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as sm from 'aws-cdk-lib/aws-secretsmanager';
import * as path from 'path';
import { Cors, LambdaIntegration, RestApi } from 'aws-cdk-lib/aws-apigateway';

const S3_BUCKET_NAME = "S3_BUCKET_NAME";
const REGION = "REGION";
const DEFAULT_S3_BUCKET = 'dev-pipelinestage-dev-censu-uploadsbucket86f42938-dlc1biqgfmp8';
const S3_SERVICE_PRINCIPAL = new iam.ServicePrincipal('s3.amazonaws.com');

export class CensusAPIStack extends cdk.Stack {
    constructor(scope: Construct, id: string, local: {ns: string }, props?: cdk.StackProps) {
      super(scope, id, props);

      // Maybe need to always do this
      const bucket = new s3.Bucket(this, 'Uploads bucket', {
        accessControl: s3.BucketAccessControl.PUBLIC_READ_WRITE,
        removalPolicy: cdk.RemovalPolicy.DESTROY,
        versioned: false,
        publicReadAccess: false,
        objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_PREFERRED,  // Required if public upload - make sure we own the object!
        cors: [
          {
            allowedMethods: [ s3.HttpMethods.GET, s3.HttpMethods.POST, s3.HttpMethods.HEAD, s3.HttpMethods.PUT ],
            allowedOrigins: [ '*' ],
            allowedHeaders: [ '*' ]
          }
        ]
      });

      new cdk.CfnOutput(this, "Bucket name", {
        value: bucket.bucketName
      });

      const bucketName = bucket.bucketName;

      const uploadStatusTable = new dynamodb.Table(this, 'Upload status table', {
        partitionKey: { name: 'id', type: dynamodb.AttributeType.STRING },
        billingMode: dynamodb.BillingMode.PAY_PER_REQUEST
      });

      // Upload data function.
      const uploadFunction = new NodejsFunction(this, 'Upload Data Function', {
        memorySize: 128,
        timeout: cdk.Duration.seconds(300),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'main',
        entry: path.join(__dirname, `/../src/uploadData.ts`),
        logRetention: logs.RetentionDays.ONE_DAY,
        environment: {
          S3_BUCKET_NAME: bucketName,
          REGION: this.region,
          STATUS_TABLE: uploadStatusTable.tableName
        }
      });
      bucket.grantRead(uploadFunction);
      const notify = new s3notify.LambdaDestination(uploadFunction);
      notify.bind(this, bucket);
      bucket.addObjectCreatedNotification(notify, {
        suffix: 'csv'
      });
      uploadFunction.grantInvoke(S3_SERVICE_PRINCIPAL);

      // Also shows status of uploads.
      const uploadStatusFunction = new NodejsFunction(this, 'Upload Status Function', {
        memorySize: 128,
        timeout: cdk.Duration.seconds(5),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'status',
        entry: path.join(__dirname, `/../src/uploadData.ts`),
        logRetention: logs.RetentionDays.ONE_DAY,
        environment: {
          S3_BUCKET_NAME: bucketName,
          REGION: this.region,
          STATUS_TABLE: uploadStatusTable.tableName
        }
      });
      uploadStatusTable.grantReadWriteData(uploadFunction);
      uploadStatusTable.grantReadWriteData(uploadStatusFunction);

      // The secret where the DB login info is. Grant read access.
      const secret = sm.Secret.fromSecretNameV2(this, 'DB credentials', 'vkd/prod/dbcreds');
      secret.grantRead(uploadFunction);

      const citysdkLayer = new lambda.LayerVersion(this, 'CitySDK Layer', {
        code: lambda.Code.fromAsset('src/layers/citysdk-utils'),
        compatibleRuntimes: [ lambda.Runtime.NODEJS_12_X, lambda.Runtime.NODEJS_14_X ]
      });

      const helloWorld = new NodejsFunction(this, 'hello-world-function', {
        memorySize: 128,
        timeout: cdk.Duration.seconds(5),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'main',
        entry: path.join(__dirname, `/../src/hello.ts`),
        logRetention: logs.RetentionDays.ONE_DAY
      });

      const apiChartBarFunction = new NodejsFunction(this, 'Bar Chart API Function', {
        memorySize: 128,
        timeout: cdk.Duration.seconds(30),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'bar',
        entry: path.join(__dirname, `/../src/chartsApi.ts`),
        logRetention: logs.RetentionDays.ONE_DAY,
        environment: {
          REGION: this.region
        }
      });
      secret.grantRead(apiChartBarFunction);

      const renderChartBarFunction = new lambda.Function(this, 'Bar Chart Render Function', {
        code: lambda.Code.fromAsset(`render`),
        memorySize: 128,
        timeout: cdk.Duration.seconds(30),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'chartsRender.bar'
      });

      const testCensusFunction = new NodejsFunction(this, 'Test Census Function', {
        memorySize: 1024,
        timeout: cdk.Duration.seconds(15),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'getCensus',
        entry: path.join(__dirname, `/../src/testcitylambda.ts`),
        bundling: {
          minify: true,
          externalModules: [ 'citysdk' ]
        },
        layers: [ citysdkLayer ],
        logRetention: logs.RetentionDays.ONE_DAY
      });

      const testDBFunction = new NodejsFunction(this, 'Test DB Function', {
        memorySize: 1024,
        timeout: cdk.Duration.seconds(15),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'queryDB',
        entry: path.join(__dirname, `/../src/testcitylambda.ts`),
        bundling: {
          minify: true,
          externalModules: [ 'citysdk' ]
        },
        layers: [ citysdkLayer ],
        logRetention: logs.RetentionDays.ONE_DAY
      });

      testDBFunction.addToRolePolicy(new iam.PolicyStatement({
        actions: ["secretsmanager:GetSecretValue"],
        resources: ["*"]
      }));

      const api = new RestApi(this, `${local.ns}-Vermont Kids Data`, {
        // defaultCorsPreflightOptions: {
        //   allowOrigins: Cors.ALL_ORIGINS
        // }
      });

      const hello = api.root.addResource("hello");
      hello.addMethod("GET", new LambdaIntegration(helloWorld));

      const rRender = api.root.addResource("render");
      const rRenderChart = rRender.addResource("chart");
      const rRenderChartBar = rRenderChart.addResource("bar");
      const rRenderChartBarById = rRenderChartBar.addResource("{chartId}");
      rRenderChartBarById.addMethod("GET", new LambdaIntegration(renderChartBarFunction));

      const rUpload = api.root.addResource("upload");
      const rUploadById = rUpload.addResource("{uploadId}");
      rUploadById.addCorsPreflight({
        allowOrigins: [ '*' ],
        allowMethods: [ 'GET' ]
      });
      rUploadById.addMethod("GET", new LambdaIntegration(uploadStatusFunction));

      const rChart = api.root.addResource("chart");
      const rChartBar = rChart.addResource("bar");
      const rChartBarById = rChartBar.addResource("{chartId}");
      rChartBarById.addCorsPreflight({
        allowOrigins: [ '*' ],
        allowMethods: [ 'GET' ]
      });
      rChartBarById.addMethod("GET", new LambdaIntegration(apiChartBarFunction));

      const testCensusResource = api.root.addResource("census");
      testCensusResource.addMethod("GET", new LambdaIntegration(testCensusFunction));

      const testDBResource = api.root.addResource("testdb");
      testDBResource.addMethod("GET", new LambdaIntegration(testDBFunction));
    }
}