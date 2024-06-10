import { Logger, injectLambdaContext } from "@aws-lambda-powertools/logger";
import { LogLevel } from "@aws-lambda-powertools/logger/lib/types";
import { Tracer, captureLambdaHandler } from "@aws-lambda-powertools/tracer";
import middy from "@middy/core";
import cors from "@middy/http-cors";
import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { CORSConfigDefault } from "src/cors-config";

const { LOG_LEVEL, NAMESPACE } = process.env;
let powerToolsResources: PowerToolsResources;

interface PowerToolsResources {
  logger: Logger;
  tracer: Tracer;
}

export function makePowerTools(props: { prefix: string }): PowerToolsResources {
  const { prefix } = props;

  const serviceName = `${prefix}-${NAMESPACE}`;
  powerToolsResources = {
    logger: new Logger({
      logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
      serviceName,
    }),
    tracer: new Tracer({ serviceName })
  };

  return powerToolsResources;
}

export function prepareAPIGateway(fn: (event: APIGatewayProxyEventV2) => Promise<APIGatewayProxyResultV2>, props?: {
}) {
  if (!powerToolsResources) {
    makePowerTools({ prefix: 'give-power-tools-a-name' });
  }

  return middy(fn)
    .use(captureLambdaHandler(powerToolsResources.tracer))
    .use(injectLambdaContext(powerToolsResources.logger))
    .use(
      cors(CORSConfigDefault),
    )
}

export interface StepFunctionInputOutput {
  id: string;
  sortKey: number;
  query: string;
  runId?: string;
  status?: string;
  stream?: boolean;
}

export function prepareStepFunction(fn: (event: StepFunctionInputOutput) => Promise<StepFunctionInputOutput>, props?: {
}) {
  if (!powerToolsResources) {
    makePowerTools({ prefix: 'give-power-tools-a-name' });
  }

  return middy(fn)
    .use(captureLambdaHandler(powerToolsResources.tracer))
    .use(injectLambdaContext(powerToolsResources.logger))
    ;
}
