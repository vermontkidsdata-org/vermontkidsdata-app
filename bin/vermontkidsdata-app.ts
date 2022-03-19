#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { VermontkidsdataPipelineStack } from '../lib/vermontkidsdata-pipeline-stack';
import { getBranch } from '../lib/get-branch';
import { VermontkidsdataStack } from '../lib/vermontkidsdata-stack';
import {sleep} from './sleep';

const app = new cdk.App();
(async () => {
    const branch = await getBranch();

    // Do a local deploy if on a feature branch
    if (branch.startsWith('dev/')) {
      console.log(`doing local deploy to environment ${branch}`);
      new VermontkidsdataStack(app, `${branch}-LocalDevBranch`, {
        ns: branch
      });
    } else {
      console.log(`****** doing pipeline deploy                                 ******`);
      console.log(`****** did you really mean to do this? Hit control-C if not. ******`);
      await sleep(2000);
      
      new VermontkidsdataPipelineStack(app, 'VermontkidsdataPipelineStack', {
        env: { account: process.env.CDK_DEFAULT_ACCOUNT, region: process.env.CDK_DEFAULT_REGION },
      });
      app.synth();
    }
})();
