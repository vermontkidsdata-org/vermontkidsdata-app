import * as cdk from 'aws-cdk-lib';
import { RemovalPolicy } from 'aws-cdk-lib';
import { AuthorizationType, Cors, CorsOptions, GatewayResponse, IdentitySource, LambdaIntegration, MethodResponse, RequestAuthorizer, ResponseType, RestApi } from 'aws-cdk-lib/aws-apigateway';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import { CfnIdentityPool, CfnIdentityPoolRoleAttachment, UserPool, UserPoolClient } from 'aws-cdk-lib/aws-cognito';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import { AttributeType } from 'aws-cdk-lib/aws-dynamodb';
import * as iam from 'aws-cdk-lib/aws-iam';
import { Effect, PolicyDocument, PolicyStatement } from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { Tracing } from 'aws-cdk-lib/aws-lambda';
import * as lambdanode from 'aws-cdk-lib/aws-lambda-nodejs';
import * as logs from 'aws-cdk-lib/aws-logs';
import * as route53 from 'aws-cdk-lib/aws-route53';
import * as route53Targets from 'aws-cdk-lib/aws-route53-targets';
import * as s3 from 'aws-cdk-lib/aws-s3';
import { EventType } from 'aws-cdk-lib/aws-s3';
import * as s3notify from 'aws-cdk-lib/aws-s3-notifications';
import * as sm from 'aws-cdk-lib/aws-secretsmanager';
import { Construct } from 'constructs';
import { join } from 'path';
import * as util from 'util';

const S3_SERVICE_PRINCIPAL = new iam.ServicePrincipal('s3.amazonaws.com');
const HOSTED_ZONE_ID = 'Z01884571R5A9N33JR5NE';
const BASE_DOMAIN_NAME = 'vtkidsdata.org';
const { COGNITO_CLIENT_ID, COGNITO_SECRET } = process.env;
const USER_POOL_ID = 'us-east-1_wft0IBegY';
const USER_POOL_CLIENT_ID = '60c446jr2ogigpg0nb5l593l93';

export interface VermontkidsdataStackProps extends cdk.StackProps {
  ns: string;
  isProduction: boolean;
}

export interface CognitoProviderInfo {
  providerName: string,
  clientId: string
}

export class VermontkidsdataStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: VermontkidsdataStackProps) {
    super(scope, id, props);

    const ns = props.ns;

    // Maybe need to always do this
    const bucket = new s3.Bucket(this, 'Uploads bucket', {
      bucketName: `ctechnica-vkd-${ns}`,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
      versioned: false,
      publicReadAccess: false,
      objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_PREFERRED,  // Required if public upload - make sure we own the object!
      cors: [
        {
          allowedMethods: [s3.HttpMethods.GET, s3.HttpMethods.POST, s3.HttpMethods.HEAD, s3.HttpMethods.PUT],
          allowedOrigins: ['*'],
          allowedHeaders: ['*']
        }
      ]
    });

    // Look up the user pool. There's only one and we create it
    // outside CDK.
    const userPool = UserPool.fromUserPoolId(this, 'user pool', USER_POOL_ID);

    const userPoolClient = UserPoolClient.fromUserPoolClientId(this, 'user pool client', USER_POOL_CLIENT_ID);

    // Create the identity pool. Link to existing user pool
    const identityPool = new CfnIdentityPool(this, 'identity pool', {
      identityPoolName: `VKD-${ns}-pool`,
      allowUnauthenticatedIdentities: false,
      cognitoIdentityProviders: [{
        providerName: `cognito-idp.${this.region}.amazonaws.com/${userPool.userPoolId}`,
        clientId: userPoolClient.userPoolClientId
      }]
    });

    const isUserCognitoGroupRole = new iam.Role(this, 'users-group-role', {
      description: 'Default role for authenticated users',
      assumedBy: new iam.FederatedPrincipal(
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
            })
          ]
        })
      }
    });

    new CfnIdentityPoolRoleAttachment(this, 'identity pool role attachment', {
      identityPoolId: identityPool.ref,
      roles: {
        authenticated: isUserCognitoGroupRole.roleArn
      },
      roleMappings: {
        mapping: {
          type: 'Token',
          ambiguousRoleResolution: 'AuthenticatedRole',
          identityProvider: `cognito-idp.${cdk.Stack.of(this).region
            }.amazonaws.com/${userPool.userPoolId}:${userPoolClient.userPoolClientId
            }`,
        },
      }
    });

    // s3Role.addToPolicy(new PolicyStatement({
    //   effect: Effect.ALLOW,
    //   actions: ['s3:PutObject'],
    //   resources: [`${bucket.bucketArn}/*`],
    // }));

    new cdk.CfnOutput(this, "Bucket name", {
      value: bucket.bucketName
    });

    const bucketName = bucket.bucketName;

    const uploadStatusTable = new dynamodb.Table(this, 'Upload status table', {
      partitionKey: { name: 'id', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST
    });

    // Upload data function.
    const uploadFunction = new lambdanode.NodejsFunction(this, 'Upload Data Function', {
      memorySize: 512,
      timeout: cdk.Duration.seconds(900),
      runtime: lambda.Runtime.NODEJS_16_X,
      entry: join(__dirname, "../src/uploadData.ts"),
      handler: 'main',
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        S3_BUCKET_NAME: bucketName,
        REGION: this.region,
        STATUS_TABLE: uploadStatusTable.tableName,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    bucket.grantRead(uploadFunction);
    const notify = new s3notify.LambdaDestination(uploadFunction);
    notify.bind(this, bucket);
    bucket.addObjectCreatedNotification(notify, {
      suffix: 'csv'
    });
    bucket.addEventNotification(EventType.OBJECT_TAGGING_PUT, notify, {
      suffix: 'csv'
    });
    uploadFunction.grantInvoke(S3_SERVICE_PRINCIPAL);

    // Also shows status of uploads.
    const uploadStatusFunction = new lambdanode.NodejsFunction(this, 'Upload Status Function', {
      memorySize: 128,
      timeout: cdk.Duration.seconds(5),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'status',
      entry: join(__dirname, "../src/uploadData.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        S3_BUCKET_NAME: bucketName,
        REGION: this.region,
        STATUS_TABLE: uploadStatusTable.tableName
      },
      tracing: Tracing.ACTIVE
    });
    uploadStatusTable.grantReadWriteData(uploadFunction);
    uploadStatusTable.grantReadWriteData(uploadStatusFunction);

    // The secret where the DB login info is. Grant read access.
    const secret = sm.Secret.fromSecretNameV2(this, 'DB credentials', `vkd/${ns}/dbcreds`);
    secret.grantRead(uploadFunction);

    const apiChartBarFunction = new lambdanode.NodejsFunction(this, 'Bar Chart API Function', {
      memorySize: 128,
      timeout: cdk.Duration.seconds(30),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'bar',
      entry: join(__dirname, "../src/chartsApi.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    secret.grantRead(apiChartBarFunction);

    const apiTableFunction = new lambdanode.NodejsFunction(this, 'Basic table API Function', {
      memorySize: 128,
      timeout: cdk.Duration.seconds(30),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'table',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    secret.grantRead(apiTableFunction);

    const queriesGetListFunction = new lambdanode.NodejsFunction(this, 'Queries getList API Function', {
      memorySize: 128,
      timeout: cdk.Duration.seconds(30),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'handler',
      entry: join(__dirname, "../src/queries-api-getList.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    secret.grantRead(queriesGetListFunction);

    const queriesGetFunction = new lambdanode.NodejsFunction(this, 'Queries get API Function', {
      memorySize: 128,
      timeout: cdk.Duration.seconds(30),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'handler',
      entry: join(__dirname, "../src/queries-api-get.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    secret.grantRead(queriesGetFunction);

    const queriesPutFunction = new lambdanode.NodejsFunction(this, 'Queries put API Function', {
      memorySize: 128,
      timeout: cdk.Duration.seconds(30),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'handler',
      entry: join(__dirname, "../src/queries-api-put.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    secret.grantRead(queriesPutFunction);

    const queriesDeleteFunction = new lambdanode.NodejsFunction(this, 'Queries delete API Function', {
      memorySize: 128,
      timeout: cdk.Duration.seconds(30),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'handler',
      entry: join(__dirname, "../src/queries-api-delete.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    secret.grantRead(queriesDeleteFunction);

    const queriesPostFunction = new lambdanode.NodejsFunction(this, 'Queries post API Function', {
      memorySize: 128,
      timeout: cdk.Duration.seconds(30),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'handler',
      entry: join(__dirname, "../src/queries-api-post.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    secret.grantRead(queriesPostFunction);

    const getSecretValueStatement = new iam.PolicyStatement({
      actions: ["secretsmanager:GetSecretValue"],
      resources: ["*"]
    });
    const tableCensusByGeoFunction = new lambdanode.NodejsFunction(this, 'Census Table By Geo Function', {
      memorySize: 1024,
      timeout: cdk.Duration.seconds(15),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'getCensusByGeo',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    tableCensusByGeoFunction.addToRolePolicy(getSecretValueStatement);

    const codesCensusVariablesByTable = new lambdanode.NodejsFunction(this, 'Codes Census Variables By Table Function', {
      memorySize: 1024,
      timeout: cdk.Duration.seconds(15),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'codesCensusVariablesByTable',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    codesCensusVariablesByTable.addToRolePolicy(getSecretValueStatement);

    const getDataSetYearsByDatasetFunction = new lambdanode.NodejsFunction(this, 'Get Years Function', {
      memorySize: 1024,
      timeout: cdk.Duration.seconds(15),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'getDataSetYearsByDataset',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    getDataSetYearsByDatasetFunction.addToRolePolicy(getSecretValueStatement);

    const getGeosByTypeFunction = new lambdanode.NodejsFunction(this, 'Get Geos by Type Function', {
      memorySize: 1024,
      timeout: cdk.Duration.seconds(15),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'getGeosByType',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    getGeosByTypeFunction.addToRolePolicy(getSecretValueStatement);

    const getCensusTablesSearchFunction = new lambdanode.NodejsFunction(this, 'Get Census Tables Search Function', {
      memorySize: 1024,
      timeout: cdk.Duration.seconds(15),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'getCensusTablesSearch',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    getCensusTablesSearchFunction.addToRolePolicy(getSecretValueStatement);

    const testDBFunction = new lambdanode.NodejsFunction(this, 'Test DB Function', {
      memorySize: 1024,
      timeout: cdk.Duration.seconds(15),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'testcitylambda.queryDB',
      entry: join(__dirname, "../src/tablesApi.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    testDBFunction.addToRolePolicy(getSecretValueStatement);

    const downloadFunction = new lambdanode.NodejsFunction(this, 'Download Function', {
      memorySize: 1024,
      timeout: cdk.Duration.seconds(60),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'main',
      entry: join(__dirname, "../src/download.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });
    downloadFunction.addToRolePolicy(getSecretValueStatement);

    // const optionsFunction = new lambdanode.NodejsFunction(this, 'Options preflight', {
    //   memorySize: 1024,
    //   timeout: cdk.Duration.seconds(15),
    //   runtime: lambda.Runtime.NODEJS_16_X,
    //   handler: 'handler',
    //   entry: join(__dirname, "../src/options.ts"),
    //   logRetention: logs.RetentionDays.ONE_DAY,
    //   environment: {
    //     REGION: this.region,
    //     NAMESPACE: ns,
    //   },
    //   tracing: Tracing.ACTIVE
    // });

    // Add the custom domain name. First look up the R53 zone
    const hostedZone = route53.HostedZone.fromHostedZoneAttributes(
      this,
      `route53-zone`,
      {
        hostedZoneId: HOSTED_ZONE_ID,
        zoneName: BASE_DOMAIN_NAME
      }
    );

    const domainName = props.isProduction ?
      `${BASE_DOMAIN_NAME}` :
      `${ns}.${BASE_DOMAIN_NAME}`;
    const apiDomainName = `api.${domainName}`;

    const certificate = new acm.DnsValidatedCertificate(
      this,
      `be-cert`,
      {
        domainName: apiDomainName,
        hostedZone,
        region: "us-east-1"
      }
    );

    const sessionTable = new dynamodb.Table(this, 'Session Table', {
      partitionKey: { name: 'session_id', type: AttributeType.STRING },
      removalPolicy: RemovalPolicy.DESTROY
    });

    if (COGNITO_CLIENT_ID == null || COGNITO_SECRET == null) {
      throw new Error("Must define COGNITO_CLIENT_ID and COGNITO_SECRET");
    }

    const uiOrigin = `https://ui.${domainName}`;

    const oauthCallbackFunction = new lambdanode.NodejsFunction(this, 'OAuth callback function', {
      runtime: lambda.Runtime.NODEJS_16_X,
      entry: join(__dirname, "../src/oauth-callback.ts"),
      handler: 'main',
      logRetention: logs.RetentionDays.FIVE_DAYS,
      environment: {
        COGNITO_CLIENT_ID,
        COGNITO_SECRET,
        MY_DOMAIN: domainName,
        REDIRECT_URI: uiOrigin,
        MY_URI: `https://api.${domainName}/oauthcallback`,
        TABLE_NAME: sessionTable.tableName,
        ENV_NAME: ns,
        IS_PRODUCTION: `${props.isProduction}`
      },
      tracing: Tracing.ACTIVE
    });

    sessionTable.grantReadWriteData(oauthCallbackFunction);

    const authorizerFunction = new lambdanode.NodejsFunction(this, 'Authorizer function', {
      runtime: lambda.Runtime.NODEJS_16_X,
      entry: join(__dirname, "../src/authorizer.ts"),
      handler: 'main',
      logRetention: logs.RetentionDays.FIVE_DAYS,
      environment: {
        TABLE_NAME: sessionTable.tableName,
        ENV_NAME: ns
      }
    });

    sessionTable.grantReadWriteData(authorizerFunction);

    const api = new RestApi(this, `${ns}-Vermont Kids Data`, {
      domainName: {
        certificate,
        domainName: apiDomainName
      },
      // Add OPTIONS call to all resources
      // defaultCorsPreflightOptions: {
      //   allowOrigins: Cors.ALL_ORIGINS,
      //   allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
      //   allowCredentials: true,
      //   allowHeaders: Cors.DEFAULT_HEADERS
      // }
    });

    const corsOptions: CorsOptions = {
      allowOrigins: [uiOrigin, 'http://localhost:3000'],
      allowHeaders: Cors.DEFAULT_HEADERS,
      allowMethods: Cors.ALL_METHODS,
      allowCredentials: true,
    };

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
        }
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

    const getCredentialsFunction = new lambdanode.NodejsFunction(this, 'Credentials function', {
      runtime: lambda.Runtime.NODEJS_16_X,
      entry: join(__dirname, "../src/get-credentials.ts"),
      handler: 'main',
      logRetention: logs.RetentionDays.FIVE_DAYS,
      environment: {
        TABLE_NAME: sessionTable.tableName,
        ENV_NAME: ns,
        IDENTITY_POOL_ID: identityPool.ref,
        IDENTITY_PROVIDER: cognitoProviderInfo.providerName
      }
    });

    sessionTable.grantReadWriteData(getCredentialsFunction);

    const methodResponses = [{
      statusCode: '401',
      responseParameters: {
        "method.response.header.Access-Control-Allow-Origin": true
      }
    }, {
      statusCode: '403',
      responseParameters: {
        "method.response.header.Access-Control-Allow-Origin": true
      }
    }] as MethodResponse[];
    
    const rDownload = api.root.addResource('download');
    const rDownloadByType = rDownload.addResource('{uploadType}');
    rDownloadByType.addMethod("GET", new LambdaIntegration(downloadFunction));

    const rOauthCallback = api.root.addResource('oauthcallback');
    rOauthCallback.addCorsPreflight(corsOptions);
    rOauthCallback.addMethod("GET", new LambdaIntegration(oauthCallbackFunction), {
      methodResponses
    });
    // rOauthCallback.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));

    const rDataset = api.root.addResource('dataset');
    // rDataset.addCorsPreflight(corsOptions);
    const rDatasetYears = rDataset.addResource('years');
    const rDatasetYearsDataset = rDatasetYears.addResource('{dataset+}');
    rDatasetYearsDataset.addMethod("GET", new LambdaIntegration(getDataSetYearsByDatasetFunction));

    const rUpload = api.root.addResource("upload");
    rUpload.addCorsPreflight(corsOptions);
    const rUploadById = rUpload.addResource("{uploadId}");
    rUploadById.addMethod("GET", new LambdaIntegration(uploadStatusFunction));

    const rChart = api.root.addResource("chart");
    rChart.addCorsPreflight(corsOptions);
    const rChartBar = rChart.addResource("bar");
    const rChartBarById = rChartBar.addResource("{queryId}");
    rChartBarById.addMethod("GET", new LambdaIntegration(apiChartBarFunction));

    const rTable = api.root.addResource("table");
    rTable.addCorsPreflight(corsOptions);
    const rTableTable = rTable.addResource("table");
    const rTableTableById = rTableTable.addResource("{queryId}");
    rTableTableById.addMethod("GET", new LambdaIntegration(apiTableFunction));
    const rTableCensus = rTable.addResource("census");
    const rTableCensusTable = rTableCensus.addResource("{table}");
    const rTableCensusTableByGeo = rTableCensusTable.addResource("{geoType}");
    rTableCensusTableByGeo.addMethod("GET", new LambdaIntegration(tableCensusByGeoFunction));

    // Apply to all the methods that need authorization
    const auth = {
      authorizationType: AuthorizationType.CUSTOM,
      authorizer: new RequestAuthorizer(this, 'request authorizer', {
        handler: authorizerFunction,
        identitySources: [
          IdentitySource.header('Cookie')
        ],
        resultsCacheTtl: cdk.Duration.seconds(0) // Disable cache on authorizer
      }),
      methodResponses
    };

    const rCredentials = api.root.addResource('credentials');
    rCredentials.addCorsPreflight(corsOptions);
    rCredentials.addMethod("GET", new LambdaIntegration(getCredentialsFunction), auth);
    // rCredentials.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));

    const rQueries = api.root.addResource("queries");
    rQueries.addCorsPreflight(corsOptions);
    rQueries.addMethod("GET", new LambdaIntegration(queriesGetListFunction), auth)
    rQueries.addMethod("POST", new LambdaIntegration(queriesPostFunction), auth);
    // rQueries.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));
    const rQueriesById = rQueries.addResource("{id}");
    rQueriesById.addCorsPreflight(corsOptions);
    rQueriesById.addMethod("GET", new LambdaIntegration(queriesGetFunction), auth);
    rQueriesById.addMethod("PUT", new LambdaIntegration(queriesPutFunction), auth);
    rQueriesById.addMethod("DELETE", new LambdaIntegration(queriesDeleteFunction), auth);
    // rQueriesById.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));

    const rCodes = api.root.addResource("codes");
    rCodes.addCorsPreflight(corsOptions);
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

    new route53.ARecord(this, 'r53-be-arec', {
      zone: hostedZone,
      target: route53.RecordTarget.fromAlias(
        new route53Targets.ApiGateway(api)
      ),
      recordName: apiDomainName
    });

    new cdk.CfnOutput(this, "API Domain Name", {
      value: apiDomainName
    });
  }
}