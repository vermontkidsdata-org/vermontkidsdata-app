import { lambdaHandlerBar } from "./chartsApi";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

const pt = makePowerTools({ prefix: `charts-api` });

export const bar = prepareAPIGateway(lambdaHandlerBar);
