import { CfnOutput, Duration, RemovalPolicy, Stack, StackProps } from 'aws-cdk-lib';
import { AuthorizationType, AwsIntegration, Cors, CorsOptions, GatewayResponse, IdentitySource, IntegrationResponse, LambdaIntegration, MethodResponse, Model, RequestAuthorizer, ResponseType, RestApi } from 'aws-cdk-lib/aws-apigateway';
import { DnsValidatedCertificate } from 'aws-cdk-lib/aws-certificatemanager';
import { Distribution, OriginAccessIdentity } from 'aws-cdk-lib/aws-cloudfront';
import { S3Origin } from 'aws-cdk-lib/aws-cloudfront-origins';
import { CfnIdentityPool, CfnIdentityPoolRoleAttachment, UserPool, UserPoolClient } from 'aws-cdk-lib/aws-cognito';
import { AttributeType, BillingMode, Table } from 'aws-cdk-lib/aws-dynamodb';
import { Effect, FederatedPrincipal, PolicyDocument, PolicyStatement, Role, ServicePrincipal } from 'aws-cdk-lib/aws-iam';
import { Runtime, Tracing } from 'aws-cdk-lib/aws-lambda';
import { SqsEventSource } from 'aws-cdk-lib/aws-lambda-event-sources';
import { Queue } from 'aws-cdk-lib/aws-sqs';

import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';
import { RetentionDays } from 'aws-cdk-lib/aws-logs';
import { ARecord, HostedZone, RecordTarget } from 'aws-cdk-lib/aws-route53';
import { ApiGateway } from 'aws-cdk-lib/aws-route53-targets';
import * as s3 from 'aws-cdk-lib/aws-s3'; // For some reason we need this one...
import { BlockPublicAccess, Bucket, BucketEncryption, EventType } from 'aws-cdk-lib/aws-s3';
import { BucketDeployment, Source } from 'aws-cdk-lib/aws-s3-deployment';
import { SqsDestination } from 'aws-cdk-lib/aws-s3-notifications';
import { Secret } from 'aws-cdk-lib/aws-secretsmanager';
import { Construct } from 'constructs';
import { readFileSync, readdirSync } from 'fs';
import { join } from 'path';
import * as util from 'util';
import { AIAssistantConstruct } from './ai-assistant-construct';
import { AuthInfo } from './cdk-utils';
import { PortalsFunctions } from './portals-functions';
// import { OpenApiBuilder } from './openapi';

const S3_SERVICE_PRINCIPAL = new ServicePrincipal('s3.amazonaws.com');
const HOSTED_ZONE_ID = 'Z01884571R5A9N33JR5NE';
const BASE_DOMAIN_NAME = 'vtkidsdata.org';
const LOCALHOST_ORIGIN = 'http://localhost:3000';
const { COGNITO_CLIENT_ID, COGNITO_SECRET } = process.env;
const USER_POOL_ID = 'us-east-1_wft0IBegY';
const USER_POOL_CLIENT_ID = '60c446jr2ogigpg0nb5l593l93';
const runtime = Runtime.NODEJS_18_X;

export interface VermontkidsdataStackProps extends StackProps {
  ns: string;
  isProduction: boolean;
}

export interface CognitoProviderInfo {
  providerName: string,
  clientId: string
}

export class VermontkidsdataStack extends Stack {
  constructor(scope: Construct, id: string, props: VermontkidsdataStackProps) {
    super(scope, id, props);

    const ns = props.ns;

    // Maybe need to always do this
    const bucket = new Bucket(this, 'Uploads bucket', {
      bucketName: `ctechnica-vkd-${ns}`,
      blockPublicAccess: BlockPublicAccess.BLOCK_ALL,
      removalPolicy: RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
      versioned: false,
      publicReadAccess: false,
      objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_PREFERRED,  // Required if public upload - make sure we own the object!
      cors: [
        {
          allowedMethods: [s3.HttpMethods.GET, s3.HttpMethods.POST, s3.HttpMethods.HEAD, s3.HttpMethods.PUT],
          allowedOrigins: ['*'],
          allowedHeaders: ['*'],
        },
      ],
    });

    // Look up the user pool. There's only one and we create it
    // outside CDK.
    const userPool = UserPool.fromUserPoolId(this, 'user pool', USER_POOL_ID);
    // const userPool = new UserPool(this, 'env user pool', {
    //   userPoolName: `VKD-${ns}-userpool`,
    //   signInAliases: {
    //     phone: true,
    //     email: true
    //   },
    //   autoVerify: {
    //     email: true
    //   },
    //   mfa: Mfa.OFF,
    //   accountRecovery: AccountRecovery.EMAIL_AND_PHONE_WITHOUT_MFA,
    //   selfSignUpEnabled: false,
    //   email: UserPoolEmail.withCognito("noreply@verificationemail.com"),
    //   removalPolicy: RemovalPolicy.DESTROY
    // });

    const userPoolClient = UserPoolClient.fromUserPoolClientId(this, 'user pool client', USER_POOL_CLIENT_ID);

    // Create the identity pool. Link to existing user pool
    const identityPool = new CfnIdentityPool(this, 'identity pool', {
      identityPoolName: `VKD-${ns}-pool`,
      allowUnauthenticatedIdentities: false,
      cognitoIdentityProviders: [{
        providerName: `cognito-idp.${this.region}.amazonaws.com/${userPool.userPoolId}`,
        clientId: userPoolClient.userPoolClientId,
      }],
    });

    const isUserCognitoGroupRole = new Role(this, 'users-group-role', {
      description: 'Default role for authenticated users',
      assumedBy: new FederatedPrincipal(
        'cognito-identity.amazonaws.com',
        {
          StringEquals: {
            'cognito-identity.amazonaws.com:aud': identityPool.ref,
          },
          'ForAnyValue:StringLike': {
            'cognito-identity.amazonaws.com:amr': 'authenticated',
          },
        },
        'sts:AssumeRoleWithWebIdentity',
      ),
      inlinePolicies: {
        s3Policy: new PolicyDocument({
          statements: [
            new PolicyStatement({
              effect: Effect.ALLOW,
              actions: ['s3:PutObject', 's3:PutObjectTagging'],
              resources: [`${bucket.bucketArn}/*`],
            }),
          ],
        }),
      },
    });

    new CfnIdentityPoolRoleAttachment(this, 'identity pool role attachment', {
      identityPoolId: identityPool.ref,
      roles: {
        authenticated: isUserCognitoGroupRole.roleArn,
      },
      roleMappings: {
        mapping: {
          type: 'Token',
          ambiguousRoleResolution: 'AuthenticatedRole',
          identityProvider: `cognito-idp.${Stack.of(this).region
            }.amazonaws.com/${userPool.userPoolId}:${userPoolClient.userPoolClientId
            }`,
        },
      },
    });

    // s3Role.addToPolicy(new PolicyStatement({
    //   effect: Effect.ALLOW,
    //   actions: ['s3:PutObject'],
    //   resources: [`${bucket.bucketArn}/*`],
    // }));

    new CfnOutput(this, "Bucket name", {
      value: bucket.bucketName,
    });

    const bucketName = bucket.bucketName;

    const serviceTable = new Table(this, 'Single Service Table', {
      partitionKey: { name: 'PK', type: AttributeType.STRING },
      sortKey: { name: 'SK', type: AttributeType.STRING },
      billingMode: BillingMode.PAY_PER_REQUEST,
      timeToLiveAttribute: 'TTL',
    });

    serviceTable.addGlobalSecondaryIndex({
      indexName: 'GSI1',
      partitionKey: { name: 'GSI1PK', type: AttributeType.STRING },
      sortKey: { name: 'GSI1SK', type: AttributeType.STRING },
    });

    serviceTable.addGlobalSecondaryIndex({
      indexName: 'GSI2',
      partitionKey: { name: 'GSI2PK', type: AttributeType.STRING },
      sortKey: { name: 'GSI2SK', type: AttributeType.STRING },
    });

    new CfnOutput(this, "Service table name", {
      value: serviceTable.tableName,
    });

    // Create SQS queue to start a backup
    const queue = new Queue(this, 'Backup queue', {
      visibilityTimeout: Duration.minutes(15),
    });

    // Another SQS queue to serialize processing on the S3 uploads
    const uploadQueue = new Queue(this, 'Upload queue', {
      visibilityTimeout: Duration.minutes(15),
    });

    const DB_SECRET_NAME = `vkd/${ns}/dbcreds`;

    // common environment for all lambdas
    const commonEnv = {
      REGION: this.region,
      SERVICE_TABLE: serviceTable.tableName,
      NAMESPACE: ns,
      IS_PRODUCTION: `${props.isProduction}`,
      DATASET_BACKUP_QUEUE_URL: queue.queueUrl,
      LOG_LEVEL: 'info',
      DB_SECRET_NAME,
    };

    // Upload data function.
    const uploadFunction = new NodejsFunction(this, 'Upload Data Function', {
      memorySize: 512,
      timeout: Duration.seconds(900),
      runtime,
      entry: join(__dirname, "../src/uploadData.ts"),
      handler: 'main',
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    bucket.grantRead(uploadFunction);
    queue.grantSendMessages(uploadFunction);

    const getSecretValueStatement = new PolicyStatement({
      actions: ["secretsmanager:GetSecretValue"],
      resources: ["*"],
    });

    const datasetBackupFunction = new NodejsFunction(this, 'Dataset Backup Function', {
      memorySize: 1024,
      timeout: Duration.minutes(15),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/datasetBackup.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    datasetBackupFunction.addToRolePolicy(getSecretValueStatement);
    datasetBackupFunction.addEventSource(new SqsEventSource(queue, {
      batchSize: 1,
    }));
    serviceTable.grantReadWriteData(datasetBackupFunction);
    bucket.grantReadWrite(datasetBackupFunction);

    const listDataSetBackupsFunction = new NodejsFunction(this, 'List Dataset Backups Function', {
      memorySize: 1024,
      timeout: Duration.minutes(1),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/datasetBackupList.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(listDataSetBackupsFunction);

    const getDataSetBackupFunction = new NodejsFunction(this, 'Get Dataset Backup Function', {
      memorySize: 1024,
      timeout: Duration.minutes(15),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/datasetBackupGet.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(getDataSetBackupFunction);
    bucket.grantReadWrite(getDataSetBackupFunction);

    const dataSetRevertFunction = new NodejsFunction(this, 'Dataset Revert Function', {
      memorySize: 1024,
      timeout: Duration.minutes(15),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/datasetBackupRevert.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(dataSetRevertFunction);
    bucket.grantReadWrite(dataSetRevertFunction);
    dataSetRevertFunction.addToRolePolicy(getSecretValueStatement);

    const notify = new SqsDestination(uploadQueue);
    //  LambdaDestination(uploadFunction);
    notify.bind(this, bucket);
    // bucket.addObjectCreatedNotification(notify, {
    //   suffix: 'csv'
    // });
    bucket.addEventNotification(EventType.OBJECT_TAGGING_PUT, notify, {
      suffix: 'csv',
    });
    uploadQueue.grantSendMessages(S3_SERVICE_PRINCIPAL);
    uploadFunction.addEventSource(new SqsEventSource(uploadQueue, {
      batchSize: 1,
    }));

    // uploadFunction.grantInvoke(S3_SERVICE_PRINCIPAL);

    // Also shows status of uploads.
    const uploadStatusFunction = new NodejsFunction(this, 'Upload Status Function', {
      memorySize: 128,
      timeout: Duration.seconds(5),
      runtime,
      handler: 'handler',
      entry: join(__dirname, "../src/upload-get-status.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    serviceTable.grantReadWriteData(uploadFunction);
    serviceTable.grantReadWriteData(uploadStatusFunction);

    // The secret where the DB login info is. Grant read access.
    const secret = Secret.fromSecretNameV2(this, 'DB credentials', DB_SECRET_NAME);
    secret.grantRead(uploadFunction);

    const apiChartBarFunction = new NodejsFunction(this, 'Bar Chart API Function', {
      memorySize: 1024,
      timeout: Duration.seconds(30),
      runtime,
      entry: join(__dirname, "../src/charts-api.ts"),
      handler: 'bar',
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(apiChartBarFunction);

    const apiTableFunction = new NodejsFunction(this, 'Basic table API Function', {
      memorySize: 1024,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'table',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(apiTableFunction);

    const dashboardCheckFunction = new NodejsFunction(this, 'Dashboard check API Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'check',
      entry: join(__dirname, "../src/dashboard-check.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(dashboardCheckFunction);

    const queriesGetListFunction = new NodejsFunction(this, 'Queries getList API Function', {
      memorySize: 1024,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'handlerGetList',
      entry: join(__dirname, "../src/queries-api.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(queriesGetListFunction);

    const queriesGetFunction = new NodejsFunction(this, 'Queries get API Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'handlerGet',
      entry: join(__dirname, "../src/queries-api.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(queriesGetFunction);

    const queriesPutFunction = new NodejsFunction(this, 'Queries put API Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'handlerPut',
      entry: join(__dirname, "../src/queries-api.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(queriesPutFunction);

    const queriesDeleteFunction = new NodejsFunction(this, 'Queries delete API Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'handlerDelete',
      entry: join(__dirname, "../src/queries-api.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(queriesDeleteFunction);

    const queriesPostFunction = new NodejsFunction(this, 'Queries post API Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'handlerPost',
      entry: join(__dirname, "../src/queries-api.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(queriesPostFunction);

    const datasetPostFunction = new NodejsFunction(this, 'Dataset post API Function', {
      memorySize: 128,
      timeout: Duration.seconds(30),
      runtime,
      handler: 'handlerPost',
      entry: join(__dirname, "../src/dataset-api.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
        S3_BUCKET_NAME: bucketName,
      },
      tracing: Tracing.ACTIVE,
    });
    secret.grantRead(datasetPostFunction);

    const tableCensusByGeoFunction = new NodejsFunction(this, 'Census Table By Geo Function', {
      memorySize: 1024,
      timeout: Duration.seconds(15),
      runtime,
      handler: 'getCensusByGeo',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    tableCensusByGeoFunction.addToRolePolicy(getSecretValueStatement);

    const codesCensusVariablesByTable = new NodejsFunction(this, 'Codes Census Variables By Table Function', {
      memorySize: 1024,
      timeout: Duration.seconds(15),
      runtime,
      handler: 'codesCensusVariablesByTable',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    codesCensusVariablesByTable.addToRolePolicy(getSecretValueStatement);

    const getDataSetYearsByDatasetFunction = new NodejsFunction(this, 'Get Years Function', {
      memorySize: 1024,
      timeout: Duration.seconds(15),
      runtime,
      handler: 'getDataSetYearsByDataset',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    getDataSetYearsByDatasetFunction.addToRolePolicy(getSecretValueStatement);

    const getGeosByTypeFunction = new NodejsFunction(this, 'Get Geos by Type Function', {
      memorySize: 1024,
      timeout: Duration.seconds(15),
      runtime,
      handler: 'getGeosByType',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    getGeosByTypeFunction.addToRolePolicy(getSecretValueStatement);

    const getCensusTablesSearchFunction = new NodejsFunction(this, 'Get Census Tables Search Function', {
      memorySize: 1024,
      timeout: Duration.seconds(15),
      runtime,
      handler: 'getCensusTablesSearch',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    getCensusTablesSearchFunction.addToRolePolicy(getSecretValueStatement);

    const testDBFunction = new NodejsFunction(this, 'Test DB Function', {
      memorySize: 1024,
      timeout: Duration.seconds(15),
      runtime,
      handler: 'testcitylambda.queryDB',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    testDBFunction.addToRolePolicy(getSecretValueStatement);

    const downloadFunction = new NodejsFunction(this, 'Download Function', {
      memorySize: 1024,
      timeout: Duration.seconds(60),
      runtime,
      handler: 'main',
      entry: join(__dirname, "../src/download.ts"),
      logRetention: RetentionDays.ONE_DAY,
      environment: {
        ...commonEnv,
      },
      tracing: Tracing.ACTIVE,
    });
    downloadFunction.addToRolePolicy(getSecretValueStatement);

    // const optionsFunction = new NodejsFunction(this, 'Options preflight', {
    //   memorySize: 1024,
    //   timeout: Duration.seconds(15),
    //   runtime,
    //   handler: 'handler',
    //   entry: join(__dirname, "../src/options.ts"),
    //   logRetention: RetentionDays.ONE_DAY,
    //   environment: {
    // ...commonEnv
    //   },
    //   tracing: Tracing.ACTIVE
    // });

    // Add the custom domain name. First look up the R53 zone
    const hostedZone = HostedZone.fromHostedZoneAttributes(
      this,
      `route53-zone`,
      {
        hostedZoneId: HOSTED_ZONE_ID,
        zoneName: BASE_DOMAIN_NAME,
      },
    );

    const domainName = props.isProduction ?
      `${BASE_DOMAIN_NAME}` :
      `${ns}.${BASE_DOMAIN_NAME}`;
    const apiDomainName = `api.${domainName}`;

    const certificate = new DnsValidatedCertificate(
      this,
      `be-cert`,
      {
        domainName: apiDomainName,
        hostedZone,
        region: "us-east-1",
      },
    );

    if (COGNITO_CLIENT_ID == null || COGNITO_SECRET == null) {
      throw new Error("Must define COGNITO_CLIENT_ID and COGNITO_SECRET");
    }

    const uiOrigin = `https://ui.${domainName}`;
    const REDIRECT_URI = `${uiOrigin}/admin`;

    const oauthCallbackFunction = new NodejsFunction(this, 'OAuth callback function', {
      runtime,
      entry: join(__dirname, "../src/oauth-callback.ts"),
      handler: 'main',
      logRetention: RetentionDays.FIVE_DAYS,
      environment: {
        ...commonEnv,
        COGNITO_CLIENT_ID,
        COGNITO_SECRET,
        MY_DOMAIN: domainName,
        REDIRECT_URI,
        MY_URI: `https://api.${domainName}/oauthcallback`,
        ENV_NAME: ns,
        IS_PRODUCTION: `${props.isProduction}`,
      },
      tracing: Tracing.ACTIVE,
    });

    serviceTable.grantReadWriteData(oauthCallbackFunction);

    const authorizerFunction = new NodejsFunction(this, 'Authorizer function', {
      runtime,
      entry: join(__dirname, "../src/authorizer.ts"),
      handler: 'main',
      logRetention: RetentionDays.FIVE_DAYS,
      environment: {
        ...commonEnv,
        ENV_NAME: ns,
      },
    });

    serviceTable.grantReadWriteData(authorizerFunction);

    const corsOptions: CorsOptions = {
      allowOrigins: [uiOrigin, LOCALHOST_ORIGIN],
      allowHeaders: Cors.DEFAULT_HEADERS,
      allowMethods: Cors.ALL_METHODS,
      allowCredentials: true,
    };

    const api = new RestApi(this, `${ns}-Vermont Kids Data`, {
      domainName: {
        certificate,
        domainName: apiDomainName,
      },
      // Add OPTIONS call to all resources
      defaultCorsPreflightOptions: corsOptions,
    });

    const authorizer = new RequestAuthorizer(this, 'request authorizer', {
      handler: authorizerFunction,
      identitySources: [
        IdentitySource.header('Cookie'),
      ],
      resultsCacheTtl: Duration.seconds(0), // Disable cache on authorizer
    });

    // const openApi = new OpenApiBuilder({
    //   restApi: api,
    //   apiProps: {
    //     //
    //   },
    //   modelsDir: join(__dirname, 'models'),
    //   tsConfig: join(__dirname, '../tsconfig.json'),
    //   servers: [{ url: `https://${apiDomainName}` }]
    // });

    // const rHello = api.root.addResource('hello');
    // rHello.addMethod("GET", new LambdaIntegration(helloFunction), { //  new MockIntegration()
    //   authorizationType: AuthorizationType.COGNITO,
    //   authorizer
    // });
    for (const type of [ResponseType.DEFAULT_4XX, ResponseType.DEFAULT_5XX, ResponseType.ACCESS_DENIED]) {
      new GatewayResponse(this, `gateway response for ${type.responseType}`, {
        restApi: api,
        type,
        responseHeaders: {
          "Access-Control-Allow-Origin": "method.request.header.origin",
          "Access-Control-Allow-Methods": "'*'",
          "Access-Control-Allow-Credentials": "'true'",
        },
      });
    }

    console.log('cognitoIdentityProviders', identityPool.cognitoIdentityProviders);
    if (identityPool.cognitoIdentityProviders == null
      || !Array.isArray(identityPool.cognitoIdentityProviders)
      || identityPool.cognitoIdentityProviders.length !== 1
      || !(identityPool.cognitoIdentityProviders[0] as CognitoProviderInfo).providerName) {
      throw new Error(`expected 1 cognitoIdentityProviders, got ${util.inspect(identityPool.cognitoIdentityProviders)}`)
    }
    const cognitoProviderInfo = identityPool.cognitoIdentityProviders[0] as CognitoProviderInfo;

    const getCredentialsFunction = new NodejsFunction(this, 'Credentials function', {
      runtime,
      entry: join(__dirname, "../src/get-credentials.ts"),
      handler: 'main',
      logRetention: RetentionDays.FIVE_DAYS,
      environment: {
        ...commonEnv,
        ENV_NAME: ns,
        IDENTITY_POOL_ID: identityPool.ref,
        IDENTITY_PROVIDER: cognitoProviderInfo.providerName,
      },
    });
    serviceTable.grantReadWriteData(getCredentialsFunction);

    const getSessionFunction = new NodejsFunction(this, 'Get Session function', {
      runtime,
      entry: join(__dirname, "../src/get-session.ts"),
      handler: 'main',
      logRetention: RetentionDays.FIVE_DAYS,
      environment: {
        ...commonEnv,
      },
    });
    serviceTable.grantReadWriteData(getSessionFunction);

    const deleteSessionFunction = new NodejsFunction(this, 'Delete Session function', {
      runtime,
      entry: join(__dirname, "../src/delete-session.ts"),
      handler: 'main',
      logRetention: RetentionDays.FIVE_DAYS,
      environment: {
        ...commonEnv,
        REDIRECT_URI,
      },
    });
    serviceTable.grantReadWriteData(deleteSessionFunction);

    const methodResponses = [{
      statusCode: '401',
      responseParameters: {
        "method.response.header.Access-Control-Allow-Origin": true,
      },
    }, {
      statusCode: '403',
      responseParameters: {
        "method.response.header.Access-Control-Allow-Origin": true,
      },
    }] as MethodResponse[];

    // Apply to all the methods that need authorization
    const auth: AuthInfo = {
      authorizationType: AuthorizationType.CUSTOM,
      authorizer,
      methodResponses,
    };

    new PortalsFunctions(this, 'portals functions', {
      api,
      commonEnv,
      auth,
      onAdd: (fn) => {
        serviceTable.grantReadWriteData(fn);
        secret.grantRead(fn);
      },
    });

    new AIAssistantConstruct(this, 'AI Assistant', {
      api,
      commonEnv,
      ns,
      auth,
      serviceTable,
      secret,
      onAdd: (fn) => {
        serviceTable.grantReadWriteData(fn);
      },
    });

    const rSession = api.root.addResource('session');
    rSession.addMethod("GET", new LambdaIntegration(getSessionFunction));
    rSession.addResource('end').addMethod("GET", new LambdaIntegration(deleteSessionFunction));

    const rDownload = api.root.addResource('download');
    const rDownloadByType = rDownload.addResource('{uploadType}');
    rDownloadByType.addMethod("GET", new LambdaIntegration(downloadFunction));

    const rOauthCallback = api.root.addResource('oauthcallback');
    rOauthCallback.addMethod("GET", new LambdaIntegration(oauthCallbackFunction), {
      methodResponses,
    });
    // rOauthCallback.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));

    const rDataset = api.root.addResource('dataset');
    const rDatasetDataset = rDataset.addResource('{dataset}');
    // POST /dataset/{dataset}
    rDatasetDataset.addMethod("POST", new LambdaIntegration(datasetPostFunction), auth);

    const rDatasetYears = rDataset.addResource('years');
    const rDatasetYearsDataset = rDatasetYears.addResource('{dataset}');
    // GET /dataset/years/{dataset}
    rDatasetYearsDataset.addMethod("GET", new LambdaIntegration(getDataSetYearsByDatasetFunction));

    const rDatasetBackups = rDataset.addResource('backups');
    const rDatasetBackupsDataset = rDatasetBackups.addResource('{dataset}');
    // GET /dataset/backups/{dataset}
    rDatasetBackupsDataset.addMethod("GET", new LambdaIntegration(listDataSetBackupsFunction));
    const rDatasetBackupsDatasetVersion = rDatasetBackupsDataset.addResource('{version}');
    // GET /dataset/backups/{dataset}/{version}
    rDatasetBackupsDatasetVersion.addMethod("GET", new LambdaIntegration(getDataSetBackupFunction));
    // POST /dataset/backups/{dataset}/{version}/revert
    rDatasetBackupsDatasetVersion.addResource('revert').addMethod("POST", new LambdaIntegration(dataSetRevertFunction), auth);

    const rUpload = api.root.addResource("upload");
    const rUploadById = rUpload.addResource("{uploadId}");
    rUploadById.addMethod("GET", new LambdaIntegration(uploadStatusFunction));

    const rChart = api.root.addResource("chart");
    const rChartBar = rChart.addResource("bar");
    const rChartBarById = rChartBar.addResource("{queryId}");
    rChartBarById.addMethod("GET", new LambdaIntegration(apiChartBarFunction));

    const rTable = api.root.addResource("table");
    const rTableTable = rTable.addResource("table");
    const rTableTableById = rTableTable.addResource("{queryId}");
    rTableTableById.addMethod("GET", new LambdaIntegration(apiTableFunction));
    const rTableCensus = rTable.addResource("census");
    const rTableCensusTable = rTableCensus.addResource("{table}");
    const rTableCensusTableByGeo = rTableCensusTable.addResource("{geoType}");
    rTableCensusTableByGeo.addMethod("GET", new LambdaIntegration(tableCensusByGeoFunction));

    const rDashboard = api.root.addResource("dashboard");
    const rDashboardCheck = rDashboard.addResource("check");
    rDashboardCheck.addMethod("GET", new LambdaIntegration(dashboardCheckFunction));

    const rCredentials = api.root.addResource('credentials');
    rCredentials.addMethod("GET", new LambdaIntegration(getCredentialsFunction), auth);

    const rQueries = api.root.addResource("queries");
    rQueries.addMethod("GET", new LambdaIntegration(queriesGetListFunction), auth)
    rQueries.addMethod("POST", new LambdaIntegration(queriesPostFunction), auth);

    // openApi.addMethods(['queries'], {
    //   "GET": {
    //     description: "Get list of queries defined"
    //   },
    //   "POST": {
    //     description: "Create new query"
    //   },
    // });

    const rQueriesById = rQueries.addResource("{id}");
    rQueriesById.addMethod("GET", new LambdaIntegration(queriesGetFunction), auth);
    rQueriesById.addMethod("PUT", new LambdaIntegration(queriesPutFunction), auth);
    rQueriesById.addMethod("DELETE", new LambdaIntegration(queriesDeleteFunction), auth);
    // rQueriesById.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));

    const rCodes = api.root.addResource("codes");
    const rCodesGeos = rCodes.addResource("geos");
    const rCodesGeosByType = rCodesGeos.addResource("{geoType}");
    rCodesGeosByType.addMethod("GET", new LambdaIntegration(getGeosByTypeFunction));
    const rCodesCensus = rCodes.addResource("census");
    const rCodesCensusTables = rCodesCensus.addResource("tables");
    const rCodesCensusTablesSearch = rCodesCensusTables.addResource("search");
    rCodesCensusTablesSearch.addMethod("GET", new LambdaIntegration(getCensusTablesSearchFunction));
    const rCodesCensusVariables = rCodesCensus.addResource("variables");
    const rCodesCensusVariablesByTable = rCodesCensusVariables.addResource("{table}");
    rCodesCensusVariablesByTable.addMethod("GET", new LambdaIntegration(codesCensusVariablesByTable));

    const testDBResource = api.root.addResource("testdb");
    testDBResource.addMethod("GET", new LambdaIntegration(testDBFunction));

    const objectKey = `${this.node.path}.yaml`.replace(/[/ ]/g, '-');
    console.log({ objectKey });

    const destinationBucket = new Bucket(this, 'Docs bucket', {
      encryption: BucketEncryption.S3_MANAGED,
      removalPolicy: RemovalPolicy.DESTROY,
    });

    const docUIdir = join(__dirname, "../swagger-dist");

    new BucketDeployment(this, `DeployWebsite`, {
      destinationBucket,
      sources: [
        Source.data(objectKey, readFileSync(join(__dirname, "../apidocs.yaml")).toString().replace(/{{host}}/g, apiDomainName)),
        ...(readdirSync(docUIdir).map(fn =>
          Source.data(fn, readFileSync(join(docUIdir, fn)).toString().replace(/{{host}}/g, apiDomainName)))
        ),
      ],
      prune: false,
      memoryLimit: 1024,
    });

    const bucketRole = new Role(this, 'API Doc Bucket Role', {
      assumedBy: new ServicePrincipal('apigateway.amazonaws.com'),
    });
    destinationBucket.grantRead(bucketRole);

    const originAccessIdentity = new OriginAccessIdentity(this, 'OriginAccessIdentity');
    bucket.grantRead(originAccessIdentity);

    const distro = new Distribution(this, 'Distribution', {
      defaultRootObject: 'index.html',
      defaultBehavior: {
        origin: new S3Origin(destinationBucket, { originAccessIdentity }),
      },
    });

    new CfnOutput(this, 'docs domain', {
      value: distro.domainName,
    });

    const apiDocsPath = api.root.addResource('apidocs.yaml');

    apiDocsPath.addMethod(
      'GET',
      new AwsIntegration({
        service: 's3',
        integrationHttpMethod: 'GET',
        path: `${destinationBucket.bucketName}/${objectKey}`,
        options: {
          credentialsRole: bucketRole,
          // integration responses are required!
          integrationResponses: [
            {
              statusCode: '200',
              'method.response.header.Content-Type':
                "'application/yaml'",
              'method.response.header.Content-Disposition':
                'integration.response.header.Content-Disposition',
              responseParameters: {
                'method.response.header.Access-Control-Allow-Headers':
                  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'",
                'method.response.header.Access-Control-Allow-Methods':
                  "'GET,OPTIONS'",
                'method.response.header.Access-Control-Allow-Origin': "'*'",
              },
            } as IntegrationResponse,
            { statusCode: '400' },
          ],
        },
      }),
      {
        methodResponses: [
          {
            statusCode: '200',
            responseModels: {
              'application/json': Model.EMPTY_MODEL,
            },
            responseParameters: {
              'method.response.header.Access-Control-Allow-Headers': true,
              'method.response.header.Access-Control-Allow-Methods': true,
              'method.response.header.Access-Control-Allow-Origin': true,
            },
          },
        ],
      },
    );

    new ARecord(this, 'r53-be-arec', {
      zone: hostedZone,
      target: RecordTarget.fromAlias(
        new ApiGateway(api),
      ),
      recordName: apiDomainName,
    });

    new CfnOutput(this, "API Domain Name", {
      value: apiDomainName,
    });
  }
}