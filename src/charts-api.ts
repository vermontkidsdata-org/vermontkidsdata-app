import { injectLambdaContext } from "@aws-lambda-powertools/logger";
import { captureLambdaHandler } from "@aws-lambda-powertools/tracer";
import middy from "@middy/core";
import cors from "@middy/http-cors";
import { lambdaHandlerBar, loggerCharts, tracerCharts } from "./chartsApi";

export const bar = middy(lambdaHandlerBar)
  .use(captureLambdaHandler(tracerCharts))
  .use(injectLambdaContext(loggerCharts))
  .use(
    cors({
      origin: "*",
    }),
  );
