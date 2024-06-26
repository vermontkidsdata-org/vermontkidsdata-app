// Needs to be right up front, before anything else is loaded
process.env.COGNITO_CLIENT_ID = 'bogus-client';
process.env.COGNITO_SECRET = 'bogus-secret';
process.env.SERVICE_TABLE = 'vkd-qa-service-table';

import * as cdk from 'aws-cdk-lib';
import { Template } from 'aws-cdk-lib/assertions';
import { VermontkidsdataStack } from '../lib/vermontkidsdata-stack';
import * as hello from '../src/hello';
import { addAssetSnapshotSerializer } from './add-snapshot-serializers';

// import { Template } from 'aws-cdk-lib/assertions';
import { APIGatewayProxyEventV2 } from 'aws-lambda';

const BOGUS_ACCOUNT_ENV_PROPS = {
  env: { account: '999999999', region: 'aq-south-1' },
  hostedZoneName: 'bogus-zone-name',
  hostedZoneId: 'bogus-zone-id-6789'
};

// example test. To run these tests, uncomment this file along with the
// example resource in lib/vermontkidsdata-pipeline-stack.ts
describe('Lambda', () => {
  // ----- Ensure that there are no unexpected changes (snapshot testing) -------------------------
  test('Snapshot Test', async () => {
    const app = new cdk.App();
    const applicationStack = new VermontkidsdataStack(app, 'test-TestStack', {
      ns: 'sandbox',
      isProduction: false,
      env: { account: BOGUS_ACCOUNT_ENV_PROPS.env.account, region: BOGUS_ACCOUNT_ENV_PROPS.env.region }
    });

    const template = Template.fromStack(applicationStack);

    // Ignore asset stuff
    addAssetSnapshotSerializer(
      BOGUS_ACCOUNT_ENV_PROPS.env.account!,
      BOGUS_ACCOUNT_ENV_PROPS.env.region!
    );

    // This will ensure that the configuration the stack does not have any unintended changes
    // Note: this automatically creates a snapshot if there isn't one; otherwise, it will compare
    //       the state of the template with the saved snapshot
    // eslint-disable-next-line max-len
    expect(template.toJSON()).toMatchSnapshot();
  });
});

describe('Hello code', () => {
  it('Returns invocation message', async () => {
    const event: APIGatewayProxyEventV2 = {
      headers: {

      },
      isBase64Encoded: false,
      rawPath: '',
      rawQueryString: '',
      requestContext: {} as any,
      routeKey: '',
      version: ''
    };
    const response: any = await hello.main(event);
    const body = JSON.parse(response['body']);
    expect(body.message).toMatch(/^Successful lambda invocation.*/);
  });
});
