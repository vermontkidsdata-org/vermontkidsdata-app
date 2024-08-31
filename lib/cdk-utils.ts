import { Duration } from "aws-cdk-lib";
import { AuthorizationType, IResource, LambdaIntegration, MethodOptions, MethodResponse, RequestAuthorizer, Resource } from "aws-cdk-lib/aws-apigateway";
import { ITable } from "aws-cdk-lib/aws-dynamodb";
import { Role } from "aws-cdk-lib/aws-iam";
import { Runtime, Tracing } from "aws-cdk-lib/aws-lambda";
import { NodejsFunction } from "aws-cdk-lib/aws-lambda-nodejs";
import { Construct } from "constructs";
import { join } from "path";

export interface AuthInfo {
  authorizationType: AuthorizationType,
  authorizer: RequestAuthorizer,
  methodResponses: MethodResponse[],
}

export function addResource(root: Resource, path: string): IResource {
  const parts = path.split('/').filter(p => p);
  let resource: IResource = root;
  for (const part of parts) {
    const existingChild = resource.getResource(part);
    if (existingChild) {
      resource = existingChild;
      continue;
    }
    resource = resource.addResource(part);
  }
  return resource;
}

export type OnAddCallback = (fn: NodejsFunction) => void;

export function makeLambda(props: {
  scope: Construct,
  name: string,
  entry: string,
  handler?: string,
  timeout?: Duration,
  commonEnv: Record<string, string>,
  onAdd?: OnAddCallback,
  serviceTable?: ITable,
  role?: Role,
}): NodejsFunction {
  const { scope, entry: _entry, handler: _handler, commonEnv, onAdd, name, timeout, serviceTable, role } = props;
  const entry = /[^0-9a-zA-Z]/.test(_entry) ? join(__dirname, '../src', _entry) : _entry;
  const handler = _handler || 'handler';

  const fn = new NodejsFunction(scope, name, {
    entry,
    handler: handler,
    memorySize: 1024,
    runtime: Runtime.NODEJS_20_X,
    timeout: timeout ?? Duration.seconds(29),
    environment: commonEnv,
    role,
    tracing: Tracing.ACTIVE,
  });

  if (onAdd) {
    onAdd(fn);
  }

  if (serviceTable) {
    serviceTable.grantReadData(fn);
  }

  return fn;
}

export function addLambdaResource(props: {
  scope: Construct,
  root: Resource,
  method: string,
  path: string,
  entry: string,
  commonEnv: Record<string, string>,
  onAdd?: OnAddCallback,
  methodOptions: MethodOptions,
  serviceTable?: ITable,
  role?: Role,
}): {
  fn: NodejsFunction,
} {
  const { scope, root, commonEnv, onAdd, methodOptions, method, path, entry, serviceTable, role } = props;

  const fn = makeLambda({
    scope,
    name: `${method} ${path}`,
    entry,
    commonEnv,
    onAdd,
    serviceTable,
    role,
  });

  const postCompletion = addResource(root, path);
  postCompletion.addMethod(method, new LambdaIntegration(fn), methodOptions);

  return { fn };
}