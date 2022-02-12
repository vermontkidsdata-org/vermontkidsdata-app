import { SecretValue, Stack, StackProps } from 'aws-cdk-lib';
import { BuildSpec, EventAction, FilterGroup, GitHubSourceCredentials, Project, Source } from 'aws-cdk-lib/aws-codebuild';
import { CodeBuildStep, CodePipeline, CodePipelineSource, ShellStep } from 'aws-cdk-lib/pipelines';
import { Construct } from 'constructs';
import { PipelineDevStage } from './pipeline-dev-stage';
// import * as sqs from 'aws-cdk-lib/aws-sqs';

export class VermontkidsdataCensusStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const owner = 'martzcodes';
    const repo = 'blog-pipeline';
    const branch = 'main';
    const region = 'us-east-1';
    const account = '439348011602';
    const gitHubTokenSecret = "VKDPipelineGitHubToken-ZPZw3Z";

    const secretArn = `arn:aws:secretsmanager:${region}:${account}:secret:${gitHubTokenSecret}`;

    // const pipeline = new CodePipeline(this, 'Pipeline', {
    //   pipelineName: 'VKDDeployPipeline',
    //   synth: new ShellStep('Synth', {
    //     input: CodePipelineSource.connection('vermontkidsdata-org/vermontkidsdata_census', 'master', {
    //       connectionArn: 'arn:aws:codestar-connections:us-east-1:439348011602:connection/fd10d11a-8da2-46cf-b018-77db2b5be992'
    //     }),
    //     commands: ['npm ci', 'npm run build', 'npx cdk synth']
    //   })
    // });

    new GitHubSourceCredentials(this, 'GitHubCreds', {
      accessToken: SecretValue.secretsManager(`arn:aws:secretsmanager:${region}:${account}:secret:${gitHubTokenSecret}`, {
        jsonField: 'access-token',
      }),
    });
    
    const pipelineSpec = BuildSpec.fromObject({
      version: 0.2,
      phases: {
          install: {
              commands: ['n latest', 'node -v', 'npm ci'],
          },
          build: {
              commands: ['npx cdk synth']
          }
      }
  });
  
  const synthAction = new CodeBuildStep(`Synth`, {
      input: CodePipelineSource.gitHub(`${owner}/${repo}`, branch, {
          authentication: SecretValue.secretsManager(secretArn, {
              jsonField: 'access-token',
          }),
      }),
      partialBuildSpec: pipelineSpec,
      commands: [],
  });

  const pipeline = new CodePipeline(this, `Pipeline`, {
      synth: synthAction,
      dockerEnabledForSynth: true,
      // need this if you're actually deploying to multiple accounts
      // crossAccountKeys: true,
  });

  const source = Source.gitHub({
      owner: owner,
      repo: repo,
      webhook: true,
      webhookFilters: [
        FilterGroup.inEventOf(
          EventAction.PULL_REQUEST_CREATED,
          EventAction.PULL_REQUEST_UPDATED,
          EventAction.PULL_REQUEST_REOPENED,
        ).andBranchIsNot('main'),
      ],
      reportBuildStatus: true,
    });
    
    const prSpec = BuildSpec.fromObject({
      version: 0.2,
      phases: {
        install: {
          commands: ['n latest', 'node -v', 'npm ci'],
        },
        build: {
          commands: ['npm run test']
        }
      }
    });
    
    new Project(this, 'PullRequestProject', {
      source,
      buildSpec: prSpec,
      concurrentBuildLimit: 1,
    });
    
    pipeline.addStage(new PipelineDevStage(this, "PipelineDevStage", {
      env: { account: "439348011602", region: "us-east-1" }
    }));

  }
}
