import * as cdk from 'aws-cdk-lib';
import { Construct } from "constructs";
import { CensusAPIStack } from './census-api-stack';

export class PipelineDeployStage extends cdk.Stage {
    
    constructor(scope: Construct, id: string, local: {ns: string}, props?: cdk.StageProps) {
      super(scope, id, props);
  
      const lambdaStack = new CensusAPIStack(this, `${local.ns}-CensusAPIStack`, local);
    }
}