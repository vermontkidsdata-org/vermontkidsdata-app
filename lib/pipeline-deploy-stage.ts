import * as cdk from 'aws-cdk-lib';
import { Construct } from "constructs";
import { VermontkidsdataStack } from './vermontkidsdata-stack';

export class PipelineDeployStage extends cdk.Stage {
    
    constructor(scope: Construct, id: string, local: {ns: string }, props?: cdk.StageProps) {
      super(scope, id, props);
  
      const lambdaStack = new VermontkidsdataStack(this, `${local.ns}-VermontkidsdataStack`, local);
    }
}