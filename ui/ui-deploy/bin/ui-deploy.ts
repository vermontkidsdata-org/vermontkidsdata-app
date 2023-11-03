#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { UiDeployStack } from '../lib/ui-deploy-stack';

const app = new cdk.App();
new UiDeployStack(app, 'UiDeployStack', {
 env: { account: '439348011602', region: 'us-east-1'},
 domainName: 'vtkidsdata.org',
 siteSubDomain: 'ui'
});