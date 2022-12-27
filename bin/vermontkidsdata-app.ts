#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import 'source-map-support/register';
import { VermontkidsdataStack } from '../lib/vermontkidsdata-stack';

const NS_PROD = 'prod';

const app = new cdk.App();
(async () => {
  const ns = process.env.VKD_ENVIRONMENT;
  if (ns == null) {
    throw new Error("Need to define VKD_ENVIRONMENT");
  }

  const isProduction = (ns === NS_PROD);

  // Do a local deploy. NOTE: This is now the only one
  // supported!
  console.log(`doing local deploy to environment ${ns}`);
  new VermontkidsdataStack(app, `${isProduction ? 'master' : ns}-LocalDevBranch`, {
    ns,
    isProduction,
  });
})().catch(reason => {
  console.error((reason as Error).message);
});
