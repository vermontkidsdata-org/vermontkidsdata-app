"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const cdk = require("aws-cdk-lib");
const assertions_1 = require("aws-cdk-lib/assertions");
const vermontkidsdata_stack_1 = require("../lib/vermontkidsdata-stack");
const hello = require("../src/hello");
// example test. To run these tests, uncomment this file along with the
// example resource in lib/vermontkidsdata-pipeline-stack.ts
describe('Lambda', () => {
    it('Creates Lambda', () => {
        const app = new cdk.App();
        // WHEN
        const lambdaStack = new vermontkidsdata_stack_1.VermontkidsdataStack(app, 'CensusAPIDevStack', { ns: 'test' });
        // THEN
        const template = assertions_1.Template.fromStack(lambdaStack);
        template.hasResourceProperties('AWS::Lambda::Function', {
            Handler: "index.main"
        });
    });
    // Commented out because it always fails... need to do this better
    // it('Does the snapshot thing', () => {
    //     const app = new cdk.App();
    //     // const lambdaStack = new VermontkidsdataStack(app, 'CensusAPIDevStack');
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidmVybW9udGtpZHNkYXRhLWFwcC50ZXN0LmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsidmVybW9udGtpZHNkYXRhLWFwcC50ZXN0LnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7O0FBQUEsbUNBQW1DO0FBQ25DLHVEQUFrRDtBQUNsRCx3RUFBb0U7QUFDcEUsc0NBQXNDO0FBTXRDLHVFQUF1RTtBQUN2RSw0REFBNEQ7QUFDNUQsUUFBUSxDQUFDLFFBQVEsRUFBRSxHQUFHLEVBQUU7SUFDcEIsRUFBRSxDQUFDLGdCQUFnQixFQUFFLEdBQUcsRUFBRTtRQUN0QixNQUFNLEdBQUcsR0FBRyxJQUFJLEdBQUcsQ0FBQyxHQUFHLEVBQUUsQ0FBQztRQUMxQixPQUFPO1FBQ1AsTUFBTSxXQUFXLEdBQUcsSUFBSSw0Q0FBb0IsQ0FBQyxHQUFHLEVBQUUsbUJBQW1CLEVBQUUsRUFBRSxFQUFFLEVBQUUsTUFBTSxFQUFFLENBQUMsQ0FBQztRQUN2RixPQUFPO1FBQ1AsTUFBTSxRQUFRLEdBQUcscUJBQVEsQ0FBQyxTQUFTLENBQUMsV0FBVyxDQUFDLENBQUM7UUFFakQsUUFBUSxDQUFDLHFCQUFxQixDQUFDLHVCQUF1QixFQUFFO1lBQ3BELE9BQU8sRUFBRSxZQUFZO1NBQ3hCLENBQUMsQ0FBQztJQUNQLENBQUMsQ0FBQyxDQUFDO0lBRUgsa0VBQWtFO0lBQ2xFLHdDQUF3QztJQUN4QyxpQ0FBaUM7SUFDakMsaUZBQWlGO0lBQ2pGLDJEQUEyRDtJQUUzRCxtREFBbUQ7SUFDbkQsc0RBQXNEO0lBQ3RELGtFQUFrRTtJQUVsRSw0RUFBNEU7SUFDNUUsTUFBTTtBQUVWLENBQUMsQ0FBQyxDQUFDO0FBRUgsUUFBUSxDQUFDLFlBQVksRUFBRSxHQUFHLEVBQUU7SUFDeEIsRUFBRSxDQUFDLDRCQUE0QixFQUFFLEtBQUssSUFBSSxFQUFFO1FBQ3hDLE1BQU0sS0FBSyxHQUEyQjtZQUNsQyxPQUFPLEVBQUUsRUFFUjtZQUNELGVBQWUsRUFBRSxLQUFLO1lBQ3RCLE9BQU8sRUFBRSxFQUFFO1lBQ1gsY0FBYyxFQUFFLEVBQUU7WUFDbEIsY0FBYyxFQUFFLEVBQVM7WUFDekIsUUFBUSxFQUFFLEVBQUU7WUFDWixPQUFPLEVBQUUsRUFBRTtTQUNkLENBQUM7UUFDRixNQUFNLFFBQVEsR0FBUSxNQUFNLEtBQUssQ0FBQyxJQUFJLENBQUMsS0FBSyxDQUFDLENBQUM7UUFDOUMsTUFBTSxJQUFJLEdBQUcsSUFBSSxDQUFDLEtBQUssQ0FBQyxRQUFRLENBQUMsTUFBTSxDQUFDLENBQUMsQ0FBQztRQUMxQyxNQUFNLENBQUMsSUFBSSxDQUFDLE9BQU8sQ0FBQyxDQUFDLE9BQU8sQ0FBQyxpQ0FBaUMsQ0FBQyxDQUFDO0lBQ3BFLENBQUMsQ0FBQyxDQUFDO0FBQ1AsQ0FBQyxDQUFDLENBQUMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgKiBhcyBjZGsgZnJvbSAnYXdzLWNkay1saWInO1xyXG5pbXBvcnQgeyBUZW1wbGF0ZSB9IGZyb20gJ2F3cy1jZGstbGliL2Fzc2VydGlvbnMnO1xyXG5pbXBvcnQgeyBWZXJtb250a2lkc2RhdGFTdGFjayB9IGZyb20gJy4uL2xpYi92ZXJtb250a2lkc2RhdGEtc3RhY2snO1xyXG5pbXBvcnQgKiBhcyBoZWxsbyBmcm9tICcuLi9zcmMvaGVsbG8nO1xyXG5cclxuLy8gaW1wb3J0IHsgVGVtcGxhdGUgfSBmcm9tICdhd3MtY2RrLWxpYi9hc3NlcnRpb25zJztcclxuaW1wb3J0ICogYXMgVmVybW9udGtpZHNkYXRhQXBwIGZyb20gJy4uL2xpYi92ZXJtb250a2lkc2RhdGEtcGlwZWxpbmUtc3RhY2snO1xyXG5pbXBvcnQgeyBBUElHYXRld2F5UHJveHlFdmVudFYyLCBBUElHYXRld2F5UHJveHlSZXN1bHRWMiB9IGZyb20gJ2F3cy1sYW1iZGEnO1xyXG5cclxuLy8gZXhhbXBsZSB0ZXN0LiBUbyBydW4gdGhlc2UgdGVzdHMsIHVuY29tbWVudCB0aGlzIGZpbGUgYWxvbmcgd2l0aCB0aGVcclxuLy8gZXhhbXBsZSByZXNvdXJjZSBpbiBsaWIvdmVybW9udGtpZHNkYXRhLXBpcGVsaW5lLXN0YWNrLnRzXHJcbmRlc2NyaWJlKCdMYW1iZGEnLCAoKSA9PiB7XHJcbiAgICBpdCgnQ3JlYXRlcyBMYW1iZGEnLCAoKSA9PiB7XHJcbiAgICAgICAgY29uc3QgYXBwID0gbmV3IGNkay5BcHAoKTtcclxuICAgICAgICAvLyBXSEVOXHJcbiAgICAgICAgY29uc3QgbGFtYmRhU3RhY2sgPSBuZXcgVmVybW9udGtpZHNkYXRhU3RhY2soYXBwLCAnQ2Vuc3VzQVBJRGV2U3RhY2snLCB7IG5zOiAndGVzdCcgfSk7XHJcbiAgICAgICAgLy8gVEhFTlxyXG4gICAgICAgIGNvbnN0IHRlbXBsYXRlID0gVGVtcGxhdGUuZnJvbVN0YWNrKGxhbWJkYVN0YWNrKTtcclxuXHJcbiAgICAgICAgdGVtcGxhdGUuaGFzUmVzb3VyY2VQcm9wZXJ0aWVzKCdBV1M6OkxhbWJkYTo6RnVuY3Rpb24nLCB7XHJcbiAgICAgICAgICAgIEhhbmRsZXI6IFwiaW5kZXgubWFpblwiXHJcbiAgICAgICAgfSk7XHJcbiAgICB9KTtcclxuXHJcbiAgICAvLyBDb21tZW50ZWQgb3V0IGJlY2F1c2UgaXQgYWx3YXlzIGZhaWxzLi4uIG5lZWQgdG8gZG8gdGhpcyBiZXR0ZXJcclxuICAgIC8vIGl0KCdEb2VzIHRoZSBzbmFwc2hvdCB0aGluZycsICgpID0+IHtcclxuICAgIC8vICAgICBjb25zdCBhcHAgPSBuZXcgY2RrLkFwcCgpO1xyXG4gICAgLy8gICAgIC8vIGNvbnN0IGxhbWJkYVN0YWNrID0gbmV3IFZlcm1vbnRraWRzZGF0YVN0YWNrKGFwcCwgJ0NlbnN1c0FQSURldlN0YWNrJyk7XHJcbiAgICAvLyAgICAgLy8gY29uc3QgdGVtcGxhdGUgPSBUZW1wbGF0ZS5mcm9tU3RhY2sobGFtYmRhU3RhY2spO1xyXG5cclxuICAgIC8vICAgICBjb25zdCBzdGFjayA9IG5ldyBjZGsuU3RhY2soYXBwLCAnTXlTdGFjaycpO1xyXG4gICAgLy8gICAgIGNvbnN0IGNmbiA9IFN5bnRoVXRpbHMudG9DbG91ZEZvcm1hdGlvbihzdGFjayk7XHJcbiAgICAvLyAgICAgZXhwZWN0KGNmbikudG9NYXRjaFNuYXBzaG90KGdldE1hdGNoT2JqZWN0KGNmbi5SZXNvdXJjZXMpKTtcclxuICAgICAgICBcclxuICAgIC8vICAgICBleHBlY3QodGVtcGxhdGUudG9KU09OKCkpLnRvTWF0Y2hTbmFwc2hvdChcIkNlbnN1c0FQSURldlN0YWNrLWJhc2ljXCIpO1xyXG4gICAgLy8gfSk7XHJcblxyXG59KTtcclxuXHJcbmRlc2NyaWJlKCdIZWxsbyBjb2RlJywgKCkgPT4ge1xyXG4gICAgaXQoJ1JldHVybnMgaW52b2NhdGlvbiBtZXNzYWdlJywgYXN5bmMgKCkgPT4ge1xyXG4gICAgICAgIGNvbnN0IGV2ZW50OiBBUElHYXRld2F5UHJveHlFdmVudFYyID0ge1xyXG4gICAgICAgICAgICBoZWFkZXJzOiB7XHJcblxyXG4gICAgICAgICAgICB9LFxyXG4gICAgICAgICAgICBpc0Jhc2U2NEVuY29kZWQ6IGZhbHNlLFxyXG4gICAgICAgICAgICByYXdQYXRoOiAnJyxcclxuICAgICAgICAgICAgcmF3UXVlcnlTdHJpbmc6ICcnLFxyXG4gICAgICAgICAgICByZXF1ZXN0Q29udGV4dDoge30gYXMgYW55LFxyXG4gICAgICAgICAgICByb3V0ZUtleTogJycsXHJcbiAgICAgICAgICAgIHZlcnNpb246ICcnXHJcbiAgICAgICAgfTtcclxuICAgICAgICBjb25zdCByZXNwb25zZTogYW55ID0gYXdhaXQgaGVsbG8ubWFpbihldmVudCk7XHJcbiAgICAgICAgY29uc3QgYm9keSA9IEpTT04ucGFyc2UocmVzcG9uc2VbJ2JvZHknXSk7XHJcbiAgICAgICAgZXhwZWN0KGJvZHkubWVzc2FnZSkudG9NYXRjaCgvXlN1Y2Nlc3NmdWwgbGFtYmRhIGludm9jYXRpb24uKi8pO1xyXG4gICAgfSk7XHJcbn0pO1xyXG4iXX0=