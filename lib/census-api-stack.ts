import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as path from 'path';

export class CensusAPIStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
      super(scope, id, props);
  
      const myFunction = new NodejsFunction(this, 'hello-world-function', {
        memorySize: 1024,
        timeout: cdk.Duration.seconds(5),
        runtime: lambda.Runtime.NODEJS_14_X,
        handler: 'main',
        entry: path.join(__dirname, `/../src/hello.ts`),
      });
      }
}