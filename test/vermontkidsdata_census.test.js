"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const cdk = require("aws-cdk-lib");
const assertions_1 = require("aws-cdk-lib/assertions");
const census_api_stack_1 = require("../lib/census-api-stack");
const hello = require("../src/hello");
// example test. To run these tests, uncomment this file along with the
// example resource in lib/vermontkidsdata_census-stack.ts
describe('Lambda', () => {
    it('Creates Lambda', () => {
        const app = new cdk.App();
        // WHEN
        const lambdaStack = new census_api_stack_1.CensusAPIStack(app, 'CensusAPIDevStack', { ns: 'test' });
        // THEN
        const template = assertions_1.Template.fromStack(lambdaStack);
        template.hasResourceProperties('AWS::Lambda::Function', {
            Handler: "index.main"
        });
    });
    // Commented out because it always fails... need to do this better
    // it('Does the snapshot thing', () => {
    //     const app = new cdk.App();
    //     // const lambdaStack = new CensusAPIStack(app, 'CensusAPIDevStack');
    //     // const template = Template.fromStack(lambdaStack);
    //     const stack = new cdk.Stack(app, 'MyStack');
    //     const cfn = SynthUtils.toCloudFormation(stack);
    //     expect(cfn).toMatchSnapshot(getMatchObject(cfn.Resources));
    //     expect(template.toJSON()).toMatchSnapshot("CensusAPIDevStack-basic");
    // });
});
describe('Hello code', () => {
    it('Returns invocation message', async () => {
        const event = {
            headers: {},
            isBase64Encoded: false,
            rawPath: '',
            rawQueryString: '',
            requestContext: {},
            routeKey: '',
            version: ''
        };
        const response = await hello.main(event);
        const body = JSON.parse(response['body']);
        expect(body.message).toMatch(/^Successful lambda invocation.*/);
    });
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidmVybW9udGtpZHNkYXRhX2NlbnN1cy50ZXN0LmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsidmVybW9udGtpZHNkYXRhX2NlbnN1cy50ZXN0LnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7O0FBQUEsbUNBQW1DO0FBQ25DLHVEQUFrRDtBQUNsRCw4REFBeUQ7QUFDekQsc0NBQXNDO0FBTXRDLHVFQUF1RTtBQUN2RSwwREFBMEQ7QUFDMUQsUUFBUSxDQUFDLFFBQVEsRUFBRSxHQUFHLEVBQUU7SUFDcEIsRUFBRSxDQUFDLGdCQUFnQixFQUFFLEdBQUcsRUFBRTtRQUN0QixNQUFNLEdBQUcsR0FBRyxJQUFJLEdBQUcsQ0FBQyxHQUFHLEVBQUUsQ0FBQztRQUMxQixPQUFPO1FBQ1AsTUFBTSxXQUFXLEdBQUcsSUFBSSxpQ0FBYyxDQUFDLEdBQUcsRUFBRSxtQkFBbUIsRUFBRSxFQUFFLEVBQUUsRUFBRSxNQUFNLEVBQUUsQ0FBQyxDQUFDO1FBQ2pGLE9BQU87UUFDUCxNQUFNLFFBQVEsR0FBRyxxQkFBUSxDQUFDLFNBQVMsQ0FBQyxXQUFXLENBQUMsQ0FBQztRQUVqRCxRQUFRLENBQUMscUJBQXFCLENBQUMsdUJBQXVCLEVBQUU7WUFDcEQsT0FBTyxFQUFFLFlBQVk7U0FDeEIsQ0FBQyxDQUFDO0lBQ1AsQ0FBQyxDQUFDLENBQUM7SUFFSCxrRUFBa0U7SUFDbEUsd0NBQXdDO0lBQ3hDLGlDQUFpQztJQUNqQywyRUFBMkU7SUFDM0UsMkRBQTJEO0lBRTNELG1EQUFtRDtJQUNuRCxzREFBc0Q7SUFDdEQsa0VBQWtFO0lBRWxFLDRFQUE0RTtJQUM1RSxNQUFNO0FBRVYsQ0FBQyxDQUFDLENBQUM7QUFFSCxRQUFRLENBQUMsWUFBWSxFQUFFLEdBQUcsRUFBRTtJQUN4QixFQUFFLENBQUMsNEJBQTRCLEVBQUUsS0FBSyxJQUFJLEVBQUU7UUFDeEMsTUFBTSxLQUFLLEdBQTJCO1lBQ2xDLE9BQU8sRUFBRSxFQUVSO1lBQ0QsZUFBZSxFQUFFLEtBQUs7WUFDdEIsT0FBTyxFQUFFLEVBQUU7WUFDWCxjQUFjLEVBQUUsRUFBRTtZQUNsQixjQUFjLEVBQUUsRUFBUztZQUN6QixRQUFRLEVBQUUsRUFBRTtZQUNaLE9BQU8sRUFBRSxFQUFFO1NBQ2QsQ0FBQztRQUNGLE1BQU0sUUFBUSxHQUFRLE1BQU0sS0FBSyxDQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsQ0FBQztRQUM5QyxNQUFNLElBQUksR0FBRyxJQUFJLENBQUMsS0FBSyxDQUFDLFFBQVEsQ0FBQyxNQUFNLENBQUMsQ0FBQyxDQUFDO1FBQzFDLE1BQU0sQ0FBQyxJQUFJLENBQUMsT0FBTyxDQUFDLENBQUMsT0FBTyxDQUFDLGlDQUFpQyxDQUFDLENBQUM7SUFDcEUsQ0FBQyxDQUFDLENBQUM7QUFDUCxDQUFDLENBQUMsQ0FBQyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCAqIGFzIGNkayBmcm9tICdhd3MtY2RrLWxpYic7XHJcbmltcG9ydCB7IFRlbXBsYXRlIH0gZnJvbSAnYXdzLWNkay1saWIvYXNzZXJ0aW9ucyc7XHJcbmltcG9ydCB7IENlbnN1c0FQSVN0YWNrIH0gZnJvbSAnLi4vbGliL2NlbnN1cy1hcGktc3RhY2snO1xyXG5pbXBvcnQgKiBhcyBoZWxsbyBmcm9tICcuLi9zcmMvaGVsbG8nO1xyXG5cclxuLy8gaW1wb3J0IHsgVGVtcGxhdGUgfSBmcm9tICdhd3MtY2RrLWxpYi9hc3NlcnRpb25zJztcclxuaW1wb3J0ICogYXMgVmVybW9udGtpZHNkYXRhQ2Vuc3VzIGZyb20gJy4uL2xpYi92ZXJtb250a2lkc2RhdGFfY2Vuc3VzLXN0YWNrJztcclxuaW1wb3J0IHsgQVBJR2F0ZXdheVByb3h5RXZlbnRWMiwgQVBJR2F0ZXdheVByb3h5UmVzdWx0VjIgfSBmcm9tICdhd3MtbGFtYmRhJztcclxuXHJcbi8vIGV4YW1wbGUgdGVzdC4gVG8gcnVuIHRoZXNlIHRlc3RzLCB1bmNvbW1lbnQgdGhpcyBmaWxlIGFsb25nIHdpdGggdGhlXHJcbi8vIGV4YW1wbGUgcmVzb3VyY2UgaW4gbGliL3Zlcm1vbnRraWRzZGF0YV9jZW5zdXMtc3RhY2sudHNcclxuZGVzY3JpYmUoJ0xhbWJkYScsICgpID0+IHtcclxuICAgIGl0KCdDcmVhdGVzIExhbWJkYScsICgpID0+IHtcclxuICAgICAgICBjb25zdCBhcHAgPSBuZXcgY2RrLkFwcCgpO1xyXG4gICAgICAgIC8vIFdIRU5cclxuICAgICAgICBjb25zdCBsYW1iZGFTdGFjayA9IG5ldyBDZW5zdXNBUElTdGFjayhhcHAsICdDZW5zdXNBUElEZXZTdGFjaycsIHsgbnM6ICd0ZXN0JyB9KTtcclxuICAgICAgICAvLyBUSEVOXHJcbiAgICAgICAgY29uc3QgdGVtcGxhdGUgPSBUZW1wbGF0ZS5mcm9tU3RhY2sobGFtYmRhU3RhY2spO1xyXG5cclxuICAgICAgICB0ZW1wbGF0ZS5oYXNSZXNvdXJjZVByb3BlcnRpZXMoJ0FXUzo6TGFtYmRhOjpGdW5jdGlvbicsIHtcclxuICAgICAgICAgICAgSGFuZGxlcjogXCJpbmRleC5tYWluXCJcclxuICAgICAgICB9KTtcclxuICAgIH0pO1xyXG5cclxuICAgIC8vIENvbW1lbnRlZCBvdXQgYmVjYXVzZSBpdCBhbHdheXMgZmFpbHMuLi4gbmVlZCB0byBkbyB0aGlzIGJldHRlclxyXG4gICAgLy8gaXQoJ0RvZXMgdGhlIHNuYXBzaG90IHRoaW5nJywgKCkgPT4ge1xyXG4gICAgLy8gICAgIGNvbnN0IGFwcCA9IG5ldyBjZGsuQXBwKCk7XHJcbiAgICAvLyAgICAgLy8gY29uc3QgbGFtYmRhU3RhY2sgPSBuZXcgQ2Vuc3VzQVBJU3RhY2soYXBwLCAnQ2Vuc3VzQVBJRGV2U3RhY2snKTtcclxuICAgIC8vICAgICAvLyBjb25zdCB0ZW1wbGF0ZSA9IFRlbXBsYXRlLmZyb21TdGFjayhsYW1iZGFTdGFjayk7XHJcblxyXG4gICAgLy8gICAgIGNvbnN0IHN0YWNrID0gbmV3IGNkay5TdGFjayhhcHAsICdNeVN0YWNrJyk7XHJcbiAgICAvLyAgICAgY29uc3QgY2ZuID0gU3ludGhVdGlscy50b0Nsb3VkRm9ybWF0aW9uKHN0YWNrKTtcclxuICAgIC8vICAgICBleHBlY3QoY2ZuKS50b01hdGNoU25hcHNob3QoZ2V0TWF0Y2hPYmplY3QoY2ZuLlJlc291cmNlcykpO1xyXG4gICAgICAgIFxyXG4gICAgLy8gICAgIGV4cGVjdCh0ZW1wbGF0ZS50b0pTT04oKSkudG9NYXRjaFNuYXBzaG90KFwiQ2Vuc3VzQVBJRGV2U3RhY2stYmFzaWNcIik7XHJcbiAgICAvLyB9KTtcclxuXHJcbn0pO1xyXG5cclxuZGVzY3JpYmUoJ0hlbGxvIGNvZGUnLCAoKSA9PiB7XHJcbiAgICBpdCgnUmV0dXJucyBpbnZvY2F0aW9uIG1lc3NhZ2UnLCBhc3luYyAoKSA9PiB7XHJcbiAgICAgICAgY29uc3QgZXZlbnQ6IEFQSUdhdGV3YXlQcm94eUV2ZW50VjIgPSB7XHJcbiAgICAgICAgICAgIGhlYWRlcnM6IHtcclxuXHJcbiAgICAgICAgICAgIH0sXHJcbiAgICAgICAgICAgIGlzQmFzZTY0RW5jb2RlZDogZmFsc2UsXHJcbiAgICAgICAgICAgIHJhd1BhdGg6ICcnLFxyXG4gICAgICAgICAgICByYXdRdWVyeVN0cmluZzogJycsXHJcbiAgICAgICAgICAgIHJlcXVlc3RDb250ZXh0OiB7fSBhcyBhbnksXHJcbiAgICAgICAgICAgIHJvdXRlS2V5OiAnJyxcclxuICAgICAgICAgICAgdmVyc2lvbjogJydcclxuICAgICAgICB9O1xyXG4gICAgICAgIGNvbnN0IHJlc3BvbnNlOiBhbnkgPSBhd2FpdCBoZWxsby5tYWluKGV2ZW50KTtcclxuICAgICAgICBjb25zdCBib2R5ID0gSlNPTi5wYXJzZShyZXNwb25zZVsnYm9keSddKTtcclxuICAgICAgICBleHBlY3QoYm9keS5tZXNzYWdlKS50b01hdGNoKC9eU3VjY2Vzc2Z1bCBsYW1iZGEgaW52b2NhdGlvbi4qLyk7XHJcbiAgICB9KTtcclxufSk7XHJcbiJdfQ==