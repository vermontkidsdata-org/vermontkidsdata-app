import { Stack, StackProps } from 'aws-cdk-lib';
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as targets from "aws-cdk-lib/aws-events-targets";
import * as events from "aws-cdk-lib/aws-events";
import * as iam from 'aws-cdk-lib/aws-iam';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as sqs from 'aws-cdk-lib/aws-sqs';
import * as lambdaEventSources from 'aws-cdk-lib/aws-lambda-event-sources';
import { HealthCheckRule } from "./events/health-check";

export class VermontkidsdataAutomationStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

        //create an instance of the event bridge rule to run the function on schedule
        const healthCheckRule = new HealthCheckRule (this, "Health Check Rule");

        /**************** BBF Health Check ******************/
        const healthCheckBBFHandler = new lambda.Function(this, "healthCheckBBFFunction", {
          runtime: lambda.Runtime.NODEJS_14_X,
          code: lambda.Code.fromAsset("lib/lambdas"),
          handler: "health-check-bbf.handler",
          timeout: cdk.Duration.minutes(10),
          description: "BBF Health Check Lambda Function"
        });

        // add the Lambda function as a target for the Event Rule
        healthCheckRule.eventRule.addTarget(
            new targets.LambdaFunction(healthCheckBBFHandler , {
              event: events.RuleTargetInput.fromObject({ message: "BBF Health Check Initiated" }),
            })
        );
        // allow the Event Rule to invoke the Lambda function
        targets.addLambdaPermission(healthCheckRule.eventRule, healthCheckBBFHandler);

        /**************** VKD Health Check ******************/
        const healthCheckVKDHandler = new lambda.Function(this, "healthCheckVKDFunction", {
          runtime: lambda.Runtime.NODEJS_14_X,
          code: lambda.Code.fromAsset("lib/lambdas"),
          handler: "health-check-vkd.handler",
          timeout: cdk.Duration.minutes(10),
          description: "VKD Health Check Lambda Function"
        });

        // add the Lambda function as a target for the Event Rule
        healthCheckRule.eventRule.addTarget(
            new targets.LambdaFunction(healthCheckVKDHandler , {
              event: events.RuleTargetInput.fromObject({ message: "VKD Health Check Initiated" }),
            })
        );
        // allow the Event Rule to invoke the Lambda function
        targets.addLambdaPermission(healthCheckRule.eventRule, healthCheckVKDHandler);

  }
}
