import { SecretValue, Stack, StackProps } from 'aws-cdk-lib';
import { BuildSpec, EventAction, FilterGroup, GitHubSourceCredentials, Project, Source } from 'aws-cdk-lib/aws-codebuild';
import { CodeBuildStep, CodePipeline, CodePipelineSource, ShellStep } from 'aws-cdk-lib/pipelines';
import { Construct } from 'constructs';
import { PipelineDevStage } from './pipeline-dev-stage';
import * as sns from 'aws-cdk-lib/aws-sns';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as subs from 'aws-cdk-lib/aws-sns-subscriptions';
import * as notify from 'aws-cdk-lib/aws-codestarnotifications';

export class VermontkidsdataCensusStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const owner = 'vermontkidsdata-org';
    const repo = 'vermontkidsdata_census';
    const branch = 'master';
    const region = 'us-east-1';
    const account = '439348011602';
    const gitHubTokenSecret = "VKDPipelineGitHubToken-ZPZw3Z";

    const secretArn = `arn:aws:secretsmanager:${region}:${account}:secret:${gitHubTokenSecret}`;

    new GitHubSourceCredentials(this, 'GitHubCreds', {
      accessToken: SecretValue.secretsManager(`arn:aws:secretsmanager:${region}:${account}:secret:${gitHubTokenSecret}`, {
        jsonField: 'access-token',
      }),
    });
    
    const pipelineSpec = BuildSpec.fromObject({
      version: 0.2,
      phases: {
          install: {
              commands: ['n latest', 'node -v', 'npm ci', 'npm ci --prefix src/layers/citysdk-utils/nodejs'],
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
        ).andBranchIsNot('master'),
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
          commands: ['npx cdk synth', 'npm run test']
        }
      }
    });
    
    new Project(this, 'PullRequestProject', {
      source,
      buildSpec: prSpec,
      concurrentBuildLimit: 1,
    });
    
    pipeline.addStage(new PipelineDevStage(this, "PipelineDevStage", {
      env: { account: "439348011602", region: "us-east-1" },
    }));

    // SNS topic for notification
    const topic = new sns.Topic(this, "Topic", {
      displayName: "Pipeline build results"
    });
    topic.addSubscription(new subs.EmailSubscription("gbisaga@gmail.com"));

    topic.addToResourcePolicy(new iam.PolicyStatement({
      principals: [ new iam.ServicePrincipal("codestar-notifications.amazonaws.com") ],
      actions: [ "SNS:Publish" ],
      resources: [ topic.topicArn ]
    }))

    // Have to do this to ensure pipeline is built before the notification added - but we
    // can't make any more modifications after this.
    pipeline.buildPipeline();


    // const notification = new notify.NotificationRule(this, "Pipeline Notification Rule", {
    //   events: [ 'codepipeline-pipeline-stage-execution-succeeded', 'codepipeline-pipeline-stage-execution-failed' ],
    //   source: pipeline.pipeline,
    //   targets: [ topic ],
    // });

  }
}
