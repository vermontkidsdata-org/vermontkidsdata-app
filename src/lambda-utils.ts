import { Logger } from '@aws-lambda-powertools/logger';
import { injectLambdaContext } from '@aws-lambda-powertools/logger/middleware';
import { LogLevel } from '@aws-lambda-powertools/logger/types';
import { Tracer } from '@aws-lambda-powertools/tracer';
import { captureLambdaHandler } from '@aws-lambda-powertools/tracer/middleware';

import middy from "@middy/core";
import cors from "@middy/http-cors";
import { APIGatewayEventRequestContextV2, APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { CORSConfigDefault } from "./cors-config";

const { LOG_LEVEL, VKD_ENVIRONMENT } = process.env;
let powerToolsResources: PowerToolsResources;

interface PowerToolsResources {
  serviceName: string;
  logger: Logger;
  tracer: Tracer;
}

export function makePowerTools(props: { prefix: string }): PowerToolsResources {
  const { prefix } = props;

  const serviceName = `${prefix}-${VKD_ENVIRONMENT}`;
  powerToolsResources = {
    logger: new Logger({
      logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
      serviceName,
    }),
    tracer: new Tracer({ serviceName }),
    serviceName,
  };

  return powerToolsResources;
}

type LambdaHandlerWithoutAuth = (event: APIGatewayProxyEventV2) => Promise<APIGatewayProxyResultV2>;
type LambdaHandlerWithAuth = (event: APIGatewayProxyEventV2WithRequestContext<APIGatewayEventRequestContextV2>) => Promise<APIGatewayProxyResultV2>;

export function prepareAPIGateway(fn: LambdaHandlerWithoutAuth | LambdaHandlerWithAuth, props?: {
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

export function prepareLambda(fn: (event: any) => Promise<any>, props?: {
}) {
  if (!powerToolsResources) {
    makePowerTools({ prefix: 'give-power-tools-a-name' });
  }

  return middy(fn)
    .use(captureLambdaHandler(powerToolsResources.tracer))
    .use(injectLambdaContext(powerToolsResources.logger))
    ;
}

export interface StepFunctionInputOutput {
  id: string;
  sortKey: number;
  query: string;
  runId?: string;
  status?: string;
  stream?: boolean;
  type: string;
  envName?: string;
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
