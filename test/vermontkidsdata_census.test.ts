import * as cdk from 'aws-cdk-lib';
import { Template } from 'aws-cdk-lib/assertions';
import { CensusAPIStack } from '../lib/census-api-stack';
import * as hello from '../src/hello';

// import { Template } from 'aws-cdk-lib/assertions';
import * as VermontkidsdataCensus from '../lib/vermontkidsdata_census-stack';
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';

// example test. To run these tests, uncomment this file along with the
// example resource in lib/vermontkidsdata_census-stack.ts
describe('Lambda', () => {
    it('Creates Lambda', () => {
        const app = new cdk.App();
        // WHEN
        const lambdaStack = new CensusAPIStack(app, 'CensusAPIDevStack');
        // THEN
        const template = Template.fromStack(lambdaStack);

        template.hasResourceProperties('AWS::Lambda::Function', {
            Handler: "index.main"
        });
    });
    
    it('Does the snapshot thing', () => {
        const app = new cdk.App();
        const lambdaStack = new CensusAPIStack(app, 'CensusAPIDevStack');
        const template = Template.fromStack(lambdaStack);

        /*
        * const stack = new Stack(app, 'MyStack');
        * const cfn = SynthUtils.toCloudFormation(stack);
        * expect(cfn).toMatchSnapshot(getMatchObject(cfn.Resources));
        */
        expect(template.toJSON()).toMatchSnapshot("CensusAPIDevStack-basic");
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
