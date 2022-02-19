import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as path from 'path';
import { LambdaIntegration, RestApi } from 'aws-cdk-lib/aws-apigateway';
import { Secret } from 'aws-cdk-lib/aws-secretsmanager';

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

      const testCensusResource = api.root.addResource("census");
      testCensusResource.addMethod("GET", new LambdaIntegration(testCensusFunction));

      const testDBResource = api.root.addResource("testdb");
      testDBResource.addMethod("GET", new LambdaIntegration(testDBFunction));
    }
}