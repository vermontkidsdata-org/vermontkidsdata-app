#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { VermontkidsdataCensusStack } from '../lib/vermontkidsdata_census-stack';
import { getBranch } from '../lib/get-branch';
import { CensusAPIStack } from '../lib/census-api-stack';

const app = new cdk.App();
getBranch(branch => {
  // Do a local deploy if on a feature branch
  if (branch.startsWith('dev/')) {
    console.log(`doing local deploy to environment ${branch}`);
    new CensusAPIStack(app, `${branch}-LocalDevBranch`, {
      ns: branch,
      createBucket: true
    });
  } else {
    console.log(`doing pipeline deploy`);
    new VermontkidsdataCensusStack(app, 'VermontkidsdataCensusStack', {
      env: { account: process.env.CDK_DEFAULT_ACCOUNT, region: process.env.CDK_DEFAULT_REGION },
    });
    app.synth();
  }
});