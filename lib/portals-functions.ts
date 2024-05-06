import { Duration } from "aws-cdk-lib";
import { LambdaIntegration, MethodOptions, Resource, RestApi } from "aws-cdk-lib/aws-apigateway";
import { NodejsFunction } from "aws-cdk-lib/aws-lambda-nodejs";
import { Construct } from "constructs";
import { join } from "path";
import { portalsGetById, portalsGetCategories, portalsGetElementById, portalsGetIndicators, portalsGetList, portalsGetSubCategories, portalsGetTopics, portalsPostAddElement, portalsPostAddIndicator, portalsPostAddIndicatorMapping, portalsPostAddMapping, portalsPostDeleteElement, portalsPostEditElement } from "../src/portals";

export type OnAddCallback = (fn: NodejsFunction) => void;

export interface PortalsFunctionsProps {
  api: RestApi;
  methodOptions?: MethodOptions;
  commonEnv: Record<string, string>;
  onAdd?: OnAddCallback;
}

export function getPortalsLambda(props: { scope: Construct, handler: string, commonEnv: Record<string, string>, onAdd?: OnAddCallback }): NodejsFunction {
  const { scope, handler, commonEnv, onAdd } = props;
  console.log({ message: 'getPortalsLambda', handler });

  const fn = new NodejsFunction(scope, `PortalsLambda ${handler}`, {
    entry: join(__dirname, '../src/portals.ts'),
    handler: handler,
    memorySize: 1024,
    timeout: Duration.seconds(30),
    environment: commonEnv,
  });

  if (onAdd) {
    onAdd(fn);
  }

  return fn;
}

function addResource(root: Resource, path: string): Resource {
  const parts = path.split('/').filter(p => p);
  let resource = root;
  for (const part of parts) {
    resource = resource.addResource(part);
  }
  return resource;
}

export class PortalsFunctions extends Construct {
  constructor(scope: Construct, id: string, props: PortalsFunctionsProps) {
    super(scope, id);

    const { api, commonEnv, onAdd, methodOptions } = props;
    const portalsRoot = api.root.addResource('portals');

    // GET /
    portalsRoot.addMethod('GET', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsGetList.name,
      commonEnv,
      onAdd,
    })), methodOptions);

    // * GET /:id
    const portalsRootId = addResource(portalsRoot, '{id}');
    portalsRootId.addMethod('GET', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsGetById.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.post('/addelement/:elttype/:eltval/:eltparent', async function (req, res, next) {
    addResource(portalsRoot, 'addelement/{elttype}/{eltval}/{eltparent}').addMethod('POST', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsPostAddElement.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.post('/addmapping/:elttype/:eltid/:eltparent', async function (req, res, next) {
    addResource(portalsRoot, '/addmapping/:elttype/:eltid/:eltparent').addMethod('POST', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsPostAddMapping.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.post('/addindicator', async function (req, res, next) {
    addResource(portalsRoot, '/addindicator').addMethod('POST', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsPostAddIndicator.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.post('/addindicatormapping', async function (req, res, next) {
    addResource(portalsRoot, '/addindicatormapping').addMethod('POST', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsPostAddIndicatorMapping.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.post('/deleteelement', async function (req, res, next) {
    addResource(portalsRoot, '/deleteelement').addMethod('POST', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsPostDeleteElement.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.post('/editelement', async function (req, res, next) {
    addResource(portalsRoot, '/editelement').addMethod('POST', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsPostEditElement.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.get('/element/:elt/:id', async function (req, res, next) {
    addResource(portalsRoot, '/element/{elt}/{id}').addMethod('GET', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsGetElementById.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.get('/topics/:id', async function (req, res, next) {
    addResource(portalsRoot, '/topics/{id}').addMethod('GET', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsGetTopics.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.get('/categories/:id', async function (req, res, next) {
    addResource(portalsRoot, '/categories/{id}').addMethod('GET', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsGetCategories.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.get('/subcategories/:id', async function (req, res, next) {
    addResource(portalsRoot, '/subcategories/{id}').addMethod('GET', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsGetSubCategories.name,
      commonEnv,
      onAdd
    })), methodOptions);

    // router.get('/indicators/:id', async function (req, res, next) {
    addResource(portalsRoot, '/indicators/{id}').addMethod('GET', new LambdaIntegration(getPortalsLambda({
      scope: this,
      handler: portalsGetIndicators.name,
      commonEnv,
      onAdd
    })), methodOptions);
  }
}