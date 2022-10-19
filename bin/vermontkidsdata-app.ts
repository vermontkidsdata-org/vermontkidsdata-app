#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import 'source-map-support/register';
import { getBranch } from '../lib/get-branch';
import { VermontkidsdataStack } from '../lib/vermontkidsdata-stack';

const app = new cdk.App();
(async () => {
    const ns = process.env.VKD_ENVIRONMENT || await getBranch();

    // Do a local deploy if on a feature branch. NOTE: This is now the only one
    // supported!
    console.log(`doing local deploy to environment ${ns}`);
    new VermontkidsdataStack(app, `${ns}-LocalDevBranch`, {
      ns: ns
    });
})().catch(reason => {
  console.error((reason as Error).message);
});
