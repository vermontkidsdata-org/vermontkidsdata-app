# Vermont Kids' Data project

Need to create some secrets first.

aws secretsmanager create-secret --name VKDPipelineGitHubToken --description "The GitHub access token for the VKD pipeline." --secret-string "{\"access-token\":\"XXXXXXXXXXXX\"}"
aws secretsmanager create-secret --name "vkd/prod/dbcreds" --secret-string "{\"username\":\"XXXXXXXXXXXX\", \"password\":\"XXXXXXXXXXXX\", \"host\": \"XXXXXXXX\"}"

Ditto for vkd/qa/dbcreds

# To deploy to personal cloud environment

1. Create a branch that starts with `dev/` and is unique to what you're doing. E.g. `dev/census-bar-chart`. Nobody else should
generally be using the same exact name.
2. `cdk deploy --profile vkd` assuming you have an AWS profile set up called `vkd`.

# To run lambdas locally
1. Create a local file called `.env.json` like this:
```
{
    "port": 3000,
    "apiurl": "https://jrnkzrwp0l.execute-api.us-east-1.amazonaws.com/prod"   <-- wherever the data API lambda is
}
```
2. `npm run watch`
3. In browser go to `http://localhost:3000/render/chart/bar/1234`

## Useful CDK commands

 * `npm run build`   compile typescript to js
 * `npm run watch`   watch for changes and compile
 * `npm run test`    perform the jest unit tests
 * `cdk deploy`      deploy this stack to your default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk synth`       emits the synthesized CloudFormation template
