import { Construct } from "constructs";
import * as events from "aws-cdk-lib/aws-events";

export class HealthCheckRule extends Construct {

    public eventRule: events.Rule;

    constructor(scope: Construct, id: string) {
        super(scope, id);

        //set the event bridge rule to run every 10 mins
        this.eventRule = new events.Rule(this, "healthCheckRule", {
            schedule: events.Schedule.cron({
                minute: "0/10",
            }),
        });
    }
}