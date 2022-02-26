import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as s3Deploy from 'aws-cdk-lib/aws-s3-deployment';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as path from 'path';
import { LambdaIntegration, RestApi } from 'aws-cdk-lib/aws-apigateway';

export class CensusAPIStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
      super(scope, id, props);

      const citysdkLayer = new lambda.LayerVersion(this, 'CitySDK Layer', {
        code: lambda.Code.fromAsset('src/layers/citysdk-utils'),
        compatibleRuntimes: [ lambda.Runtime.NODEJS_12_X, lambda.Runtime.NODEJS_14_X ]
      });

      const helloWorld = new NodejsFunction(this, 'hello-world-function', {
        memorySize: 128,
        timeout: cdk.Duration.seconds(5),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'main',
        entry: path.join(__dirname, `/../src/hello.ts`)
      });

      // Package up the templates to S3
      const templateBucket = new s3.Bucket(this, "Template Distribution Bucket", {});

      const deployment = new s3Deploy.BucketDeployment(this, "Render templates", {
        destinationBucket: templateBucket,
        sources: [s3Deploy.Source.asset(path.join(__dirname, "../views"))]
      });

      const apiChartBarFunction = new NodejsFunction(this, 'Bar Chart API Function', {
        memorySize: 128,
        timeout: cdk.Duration.seconds(30),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'bar',
        entry: path.join(__dirname, `/../src/chartsRender.ts`)
      });

      const renderChartBarFunction = new NodejsFunction(this, 'Bar Chart Render Function', {
        memorySize: 128,
        timeout: cdk.Duration.seconds(30),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'bar',
        entry: path.join(__dirname, `/../src/chartsApi.ts`),
        environment: {
          templateBucket: templateBucket.s3UrlForObject()
        }
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
        layers: [ citysdkLayer ]
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
        layers: [ citysdkLayer ]
      });

      testDBFunction.addToRolePolicy(new iam.PolicyStatement({
        actions: ["secretsmanager:GetSecretValue"],
        resources: ["*"]
      }));

      const api = new RestApi(this, "Census");
      const hello = api.root.addResource("hello");
      hello.addMethod("GET", new LambdaIntegration(helloWorld));

      const rRender = api.root.addResource("render");
      const rRenderChart = rRender.addResource("chart");
      const rRenderChartBar = rRenderChart.addResource("bar");
      rRenderChartBar.addResource("{chartId}").addMethod("GET", new LambdaIntegration(renderChartBarFunction));

      const rChart = api.root.addResource("chart");
      const rChartBar = rChart.addResource("bar");
      rChartBar.addResource("{chartId}").addMethod("GET", new LambdaIntegration(apiChartBarFunction));

      const testCensusResource = api.root.addResource("census");
      testCensusResource.addMethod("GET", new LambdaIntegration(testCensusFunction));

      const testDBResource = api.root.addResource("testdb");
      testDBResource.addMethod("GET", new LambdaIntegration(testDBFunction));
    }
}