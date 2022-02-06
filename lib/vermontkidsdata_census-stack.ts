import { Stack, StackProps } from 'aws-cdk-lib';
import { CodePipeline, CodePipelineSource, ShellStep } from 'aws-cdk-lib/pipelines';
import { Construct } from 'constructs';
import { PipelineDevStage } from './pipeline-dev-stage';
// import * as sqs from 'aws-cdk-lib/aws-sqs';

export class VermontkidsdataCensusStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const pipeline = new CodePipeline(this, 'Pipeline', {
      pipelineName: 'VKDDeployPipeline',
      // Required to compile TypeScript with esbuild
      dockerEnabledForSynth: true,
      synth: new ShellStep('Synth', {
        input: CodePipelineSource.connection('vermontkidsdata-org/vermontkidsdata_census', 'master', {
          connectionArn: 'arn:aws:codestar-connections:us-east-1:439348011602:connection/fd10d11a-8da2-46cf-b018-77db2b5be992'
        }),
        commands: ['npm ci', 'npm run build', 'npx cdk synth']
      })
    });

    pipeline.addStage(new PipelineDevStage(this, "PipelineDevStage", {
      env: { account: "439348011602", region: "us-east-1" }
    }));

  }
}
