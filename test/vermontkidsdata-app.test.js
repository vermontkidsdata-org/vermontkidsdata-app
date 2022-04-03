"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const cdk = require("aws-cdk-lib");
const assertions_1 = require("aws-cdk-lib/assertions");
const vermontkidsdata_stack_1 = require("../lib/vermontkidsdata-stack");
const hello = require("../src/hello");
const add_snapshot_serializers_1 = require("./add-snapshot-serializers");
const BOGUS_ACCOUNT_ENV_PROPS = {
    env: { account: '999999999', region: 'aq-south-1' },
    hostedZoneName: 'bogus-zone-name',
    hostedZoneId: 'bogus-zone-id-6789'
};
// example test. To run these tests, uncomment this file along with the
// example resource in lib/vermontkidsdata-pipeline-stack.ts
describe('Lambda', () => {
    // it('Creates Lambda', () => {
    //     const app = new cdk.App();
    //     // WHEN
    //     const lambdaStack = new VermontkidsdataStack(app, 'CensusAPIDevStack', { ns: 'test' });
    //     // THEN
    //     const template = Template.fromStack(lambdaStack);
    //     template.hasResourceProperties('AWS::Lambda::Function', {
    //         Handler: "index.main"
    //     });
    // });
    // ----- Ensure that there are no unexpected changes (snapshot testing) -------------------------
    test('Snapshot Test', async () => {
        const app = new cdk.App();
        const applicationStack = new vermontkidsdata_stack_1.VermontkidsdataStack(app, 'test-TestStack', { ns: 'test' }, {
            env: { account: BOGUS_ACCOUNT_ENV_PROPS.env.account, region: BOGUS_ACCOUNT_ENV_PROPS.env.region }
        });
        const template = assertions_1.Template.fromStack(applicationStack);
        // Ignore asset stuff
        add_snapshot_serializers_1.addAssetSnapshotSerializer(BOGUS_ACCOUNT_ENV_PROPS.env.account, BOGUS_ACCOUNT_ENV_PROPS.env.region);
        // This will ensure that the configuration the stack does not have any unintended changes
        // Note: this automatically creates a snapshot if there isn't one; otherwise, it will compare
        //       the state of the template with the saved snapshot
        // eslint-disable-next-line max-len
        expect(template.toJSON()).toMatchSnapshot();
    });
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidmVybW9udGtpZHNkYXRhLWFwcC50ZXN0LmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsidmVybW9udGtpZHNkYXRhLWFwcC50ZXN0LnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7O0FBQUEsbUNBQW1DO0FBQ25DLHVEQUFrRDtBQUNsRCx3RUFBb0U7QUFDcEUsc0NBQXNDO0FBQ3RDLHlFQUF3RTtBQU14RSxNQUFNLHVCQUF1QixHQUFHO0lBQzVCLEdBQUcsRUFBRSxFQUFFLE9BQU8sRUFBRSxXQUFXLEVBQUUsTUFBTSxFQUFFLFlBQVksRUFBRTtJQUNuRCxjQUFjLEVBQUUsaUJBQWlCO0lBQ2pDLFlBQVksRUFBRSxvQkFBb0I7Q0FDbkMsQ0FBQztBQUVKLHVFQUF1RTtBQUN2RSw0REFBNEQ7QUFDNUQsUUFBUSxDQUFDLFFBQVEsRUFBRSxHQUFHLEVBQUU7SUFDcEIsK0JBQStCO0lBQy9CLGlDQUFpQztJQUNqQyxjQUFjO0lBQ2QsOEZBQThGO0lBQzlGLGNBQWM7SUFDZCx3REFBd0Q7SUFFeEQsZ0VBQWdFO0lBQ2hFLGdDQUFnQztJQUNoQyxVQUFVO0lBQ1YsTUFBTTtJQUVSLGlHQUFpRztJQUNqRyxJQUFJLENBQUMsZUFBZSxFQUFFLEtBQUssSUFBSSxFQUFFO1FBQy9CLE1BQU0sR0FBRyxHQUFHLElBQUksR0FBRyxDQUFDLEdBQUcsRUFBRSxDQUFDO1FBQzFCLE1BQU0sZ0JBQWdCLEdBQUcsSUFBSSw0Q0FBb0IsQ0FBQyxHQUFHLEVBQUUsZ0JBQWdCLEVBQUUsRUFBRSxFQUFFLEVBQUUsTUFBTSxFQUFFLEVBQUU7WUFDckYsR0FBRyxFQUFFLEVBQUUsT0FBTyxFQUFFLHVCQUF1QixDQUFDLEdBQUcsQ0FBQyxPQUFPLEVBQUUsTUFBTSxFQUFFLHVCQUF1QixDQUFDLEdBQUcsQ0FBQyxNQUFNLEVBQUU7U0FDcEcsQ0FBQyxDQUFDO1FBRUgsTUFBTSxRQUFRLEdBQUcscUJBQVEsQ0FBQyxTQUFTLENBQUMsZ0JBQWdCLENBQUMsQ0FBQztRQUV0RCxxQkFBcUI7UUFDckIscURBQTBCLENBQ3hCLHVCQUF1QixDQUFDLEdBQUcsQ0FBQyxPQUFRLEVBQ3BDLHVCQUF1QixDQUFDLEdBQUcsQ0FBQyxNQUFPLENBQ3BDLENBQUM7UUFFRix5RkFBeUY7UUFDekYsNkZBQTZGO1FBQzdGLDBEQUEwRDtRQUMxRCxtQ0FBbUM7UUFDbkMsTUFBTSxDQUFDLFFBQVEsQ0FBQyxNQUFNLEVBQUUsQ0FBQyxDQUFDLGVBQWUsRUFBRSxDQUFDO0lBQzlDLENBQUMsQ0FBQyxDQUFDO0FBQ0wsQ0FBQyxDQUFDLENBQUM7QUFFSCxRQUFRLENBQUMsWUFBWSxFQUFFLEdBQUcsRUFBRTtJQUN4QixFQUFFLENBQUMsNEJBQTRCLEVBQUUsS0FBSyxJQUFJLEVBQUU7UUFDeEMsTUFBTSxLQUFLLEdBQTJCO1lBQ2xDLE9BQU8sRUFBRSxFQUVSO1lBQ0QsZUFBZSxFQUFFLEtBQUs7WUFDdEIsT0FBTyxFQUFFLEVBQUU7WUFDWCxjQUFjLEVBQUUsRUFBRTtZQUNsQixjQUFjLEVBQUUsRUFBUztZQUN6QixRQUFRLEVBQUUsRUFBRTtZQUNaLE9BQU8sRUFBRSxFQUFFO1NBQ2QsQ0FBQztRQUNGLE1BQU0sUUFBUSxHQUFRLE1BQU0sS0FBSyxDQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsQ0FBQztRQUM5QyxNQUFNLElBQUksR0FBRyxJQUFJLENBQUMsS0FBSyxDQUFDLFFBQVEsQ0FBQyxNQUFNLENBQUMsQ0FBQyxDQUFDO1FBQzFDLE1BQU0sQ0FBQyxJQUFJLENBQUMsT0FBTyxDQUFDLENBQUMsT0FBTyxDQUFDLGlDQUFpQyxDQUFDLENBQUM7SUFDcEUsQ0FBQyxDQUFDLENBQUM7QUFDUCxDQUFDLENBQUMsQ0FBQyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCAqIGFzIGNkayBmcm9tICdhd3MtY2RrLWxpYic7XHJcbmltcG9ydCB7IFRlbXBsYXRlIH0gZnJvbSAnYXdzLWNkay1saWIvYXNzZXJ0aW9ucyc7XHJcbmltcG9ydCB7IFZlcm1vbnRraWRzZGF0YVN0YWNrIH0gZnJvbSAnLi4vbGliL3Zlcm1vbnRraWRzZGF0YS1zdGFjayc7XHJcbmltcG9ydCAqIGFzIGhlbGxvIGZyb20gJy4uL3NyYy9oZWxsbyc7XHJcbmltcG9ydCB7IGFkZEFzc2V0U25hcHNob3RTZXJpYWxpemVyIH0gZnJvbSAnLi9hZGQtc25hcHNob3Qtc2VyaWFsaXplcnMnO1xyXG5cclxuLy8gaW1wb3J0IHsgVGVtcGxhdGUgfSBmcm9tICdhd3MtY2RrLWxpYi9hc3NlcnRpb25zJztcclxuaW1wb3J0ICogYXMgVmVybW9udGtpZHNkYXRhQXBwIGZyb20gJy4uL2xpYi92ZXJtb250a2lkc2RhdGEtcGlwZWxpbmUtc3RhY2snO1xyXG5pbXBvcnQgeyBBUElHYXRld2F5UHJveHlFdmVudFYyLCBBUElHYXRld2F5UHJveHlSZXN1bHRWMiB9IGZyb20gJ2F3cy1sYW1iZGEnO1xyXG5cclxuY29uc3QgQk9HVVNfQUNDT1VOVF9FTlZfUFJPUFMgPSB7XHJcbiAgICBlbnY6IHsgYWNjb3VudDogJzk5OTk5OTk5OScsIHJlZ2lvbjogJ2FxLXNvdXRoLTEnIH0sXHJcbiAgICBob3N0ZWRab25lTmFtZTogJ2JvZ3VzLXpvbmUtbmFtZScsXHJcbiAgICBob3N0ZWRab25lSWQ6ICdib2d1cy16b25lLWlkLTY3ODknXHJcbiAgfTtcclxuXHJcbi8vIGV4YW1wbGUgdGVzdC4gVG8gcnVuIHRoZXNlIHRlc3RzLCB1bmNvbW1lbnQgdGhpcyBmaWxlIGFsb25nIHdpdGggdGhlXHJcbi8vIGV4YW1wbGUgcmVzb3VyY2UgaW4gbGliL3Zlcm1vbnRraWRzZGF0YS1waXBlbGluZS1zdGFjay50c1xyXG5kZXNjcmliZSgnTGFtYmRhJywgKCkgPT4ge1xyXG4gICAgLy8gaXQoJ0NyZWF0ZXMgTGFtYmRhJywgKCkgPT4ge1xyXG4gICAgLy8gICAgIGNvbnN0IGFwcCA9IG5ldyBjZGsuQXBwKCk7XHJcbiAgICAvLyAgICAgLy8gV0hFTlxyXG4gICAgLy8gICAgIGNvbnN0IGxhbWJkYVN0YWNrID0gbmV3IFZlcm1vbnRraWRzZGF0YVN0YWNrKGFwcCwgJ0NlbnN1c0FQSURldlN0YWNrJywgeyBuczogJ3Rlc3QnIH0pO1xyXG4gICAgLy8gICAgIC8vIFRIRU5cclxuICAgIC8vICAgICBjb25zdCB0ZW1wbGF0ZSA9IFRlbXBsYXRlLmZyb21TdGFjayhsYW1iZGFTdGFjayk7XHJcblxyXG4gICAgLy8gICAgIHRlbXBsYXRlLmhhc1Jlc291cmNlUHJvcGVydGllcygnQVdTOjpMYW1iZGE6OkZ1bmN0aW9uJywge1xyXG4gICAgLy8gICAgICAgICBIYW5kbGVyOiBcImluZGV4Lm1haW5cIlxyXG4gICAgLy8gICAgIH0pO1xyXG4gICAgLy8gfSk7XHJcblxyXG4gIC8vIC0tLS0tIEVuc3VyZSB0aGF0IHRoZXJlIGFyZSBubyB1bmV4cGVjdGVkIGNoYW5nZXMgKHNuYXBzaG90IHRlc3RpbmcpIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS1cclxuICB0ZXN0KCdTbmFwc2hvdCBUZXN0JywgYXN5bmMgKCkgPT4ge1xyXG4gICAgY29uc3QgYXBwID0gbmV3IGNkay5BcHAoKTtcclxuICAgIGNvbnN0IGFwcGxpY2F0aW9uU3RhY2sgPSBuZXcgVmVybW9udGtpZHNkYXRhU3RhY2soYXBwLCAndGVzdC1UZXN0U3RhY2snLCB7IG5zOiAndGVzdCcgfSwge1xyXG4gICAgICAgIGVudjogeyBhY2NvdW50OiBCT0dVU19BQ0NPVU5UX0VOVl9QUk9QUy5lbnYuYWNjb3VudCwgcmVnaW9uOiBCT0dVU19BQ0NPVU5UX0VOVl9QUk9QUy5lbnYucmVnaW9uIH1cclxuICAgIH0pO1xyXG4gICAgXHJcbiAgICBjb25zdCB0ZW1wbGF0ZSA9IFRlbXBsYXRlLmZyb21TdGFjayhhcHBsaWNhdGlvblN0YWNrKTtcclxuXHJcbiAgICAvLyBJZ25vcmUgYXNzZXQgc3R1ZmZcclxuICAgIGFkZEFzc2V0U25hcHNob3RTZXJpYWxpemVyKFxyXG4gICAgICBCT0dVU19BQ0NPVU5UX0VOVl9QUk9QUy5lbnYuYWNjb3VudCEsXHJcbiAgICAgIEJPR1VTX0FDQ09VTlRfRU5WX1BST1BTLmVudi5yZWdpb24hXHJcbiAgICApO1xyXG5cclxuICAgIC8vIFRoaXMgd2lsbCBlbnN1cmUgdGhhdCB0aGUgY29uZmlndXJhdGlvbiB0aGUgc3RhY2sgZG9lcyBub3QgaGF2ZSBhbnkgdW5pbnRlbmRlZCBjaGFuZ2VzXHJcbiAgICAvLyBOb3RlOiB0aGlzIGF1dG9tYXRpY2FsbHkgY3JlYXRlcyBhIHNuYXBzaG90IGlmIHRoZXJlIGlzbid0IG9uZTsgb3RoZXJ3aXNlLCBpdCB3aWxsIGNvbXBhcmVcclxuICAgIC8vICAgICAgIHRoZSBzdGF0ZSBvZiB0aGUgdGVtcGxhdGUgd2l0aCB0aGUgc2F2ZWQgc25hcHNob3RcclxuICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBtYXgtbGVuXHJcbiAgICBleHBlY3QodGVtcGxhdGUudG9KU09OKCkpLnRvTWF0Y2hTbmFwc2hvdCgpO1xyXG4gIH0pO1xyXG59KTtcclxuXHJcbmRlc2NyaWJlKCdIZWxsbyBjb2RlJywgKCkgPT4ge1xyXG4gICAgaXQoJ1JldHVybnMgaW52b2NhdGlvbiBtZXNzYWdlJywgYXN5bmMgKCkgPT4ge1xyXG4gICAgICAgIGNvbnN0IGV2ZW50OiBBUElHYXRld2F5UHJveHlFdmVudFYyID0ge1xyXG4gICAgICAgICAgICBoZWFkZXJzOiB7XHJcblxyXG4gICAgICAgICAgICB9LFxyXG4gICAgICAgICAgICBpc0Jhc2U2NEVuY29kZWQ6IGZhbHNlLFxyXG4gICAgICAgICAgICByYXdQYXRoOiAnJyxcclxuICAgICAgICAgICAgcmF3UXVlcnlTdHJpbmc6ICcnLFxyXG4gICAgICAgICAgICByZXF1ZXN0Q29udGV4dDoge30gYXMgYW55LFxyXG4gICAgICAgICAgICByb3V0ZUtleTogJycsXHJcbiAgICAgICAgICAgIHZlcnNpb246ICcnXHJcbiAgICAgICAgfTtcclxuICAgICAgICBjb25zdCByZXNwb25zZTogYW55ID0gYXdhaXQgaGVsbG8ubWFpbihldmVudCk7XHJcbiAgICAgICAgY29uc3QgYm9keSA9IEpTT04ucGFyc2UocmVzcG9uc2VbJ2JvZHknXSk7XHJcbiAgICAgICAgZXhwZWN0KGJvZHkubWVzc2FnZSkudG9NYXRjaCgvXlN1Y2Nlc3NmdWwgbGFtYmRhIGludm9jYXRpb24uKi8pO1xyXG4gICAgfSk7XHJcbn0pO1xyXG4iXX0=