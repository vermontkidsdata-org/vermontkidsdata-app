import * as cdk from 'aws-cdk-lib';
import { Construct } from "constructs";
import { CensusAPIStack } from './census-api-stack';

export class PipelineDevStage extends cdk.Stage {
    
    constructor(scope: Construct, id: string, props?: cdk.StageProps) {
      super(scope, id, props);
  
      const lambdaStack = new CensusAPIStack(this, 'CensusAPIDevStack');
    }
}