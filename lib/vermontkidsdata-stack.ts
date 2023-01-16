import * as cdk from 'aws-cdk-lib';
import { RemovalPolicy } from 'aws-cdk-lib';
import { AuthorizationType, Cors, IdentitySource, LambdaIntegration, RequestAuthorizer, RestApi } from 'aws-cdk-lib/aws-apigateway';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as cloudFront from 'aws-cdk-lib/aws-cloudfront';
import * as cloudFrontOrigins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import { AttributeType } from 'aws-cdk-lib/aws-dynamodb';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { Tracing } from 'aws-cdk-lib/aws-lambda';
import * as lambdanode from 'aws-cdk-lib/aws-lambda-nodejs';
import * as logs from 'aws-cdk-lib/aws-logs';
import * as route53 from 'aws-cdk-lib/aws-route53';
import * as route53Targets from 'aws-cdk-lib/aws-route53-targets';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as s3deploy from 'aws-cdk-lib/aws-s3-deployment';
import * as s3notify from 'aws-cdk-lib/aws-s3-notifications';
import * as sm from 'aws-cdk-lib/aws-secretsmanager';
import { Construct } from 'constructs';
import { join } from 'path';

const S3_SERVICE_PRINCIPAL = new iam.ServicePrincipal('s3.amazonaws.com');
const HOSTED_ZONE_ID = 'Z01884571R5A9N33JR5NE';
const BASE_DOMAIN_NAME = 'vtkidsdata.org';
const { COGNITO_CLIENT_ID, COGNITO_SECRET } = process.env;

export interface VermontkidsdataStackProps extends cdk.StackProps {
  ns: string;
  isProduction: boolean;
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

    const optionsFunction = new lambdanode.NodejsFunction(this, 'Options preflight', {
      memorySize: 1024,
      timeout: cdk.Duration.seconds(15),
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'handler',
      entry: join(__dirname, "../src/options.ts"),
      logRetention: logs.RetentionDays.ONE_DAY,
      environment: {
        REGION: this.region,
        NAMESPACE: ns,
      },
      tracing: Tracing.ACTIVE
    });

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

    // const userPool = UserPool.fromUserPoolId(this, 'my user pool', 'us-east-1_wft0IBegY');

    // const authorizer = new CognitoUserPoolsAuthorizer(this, 'cognito authorizer', {
    //   cognitoUserPools: [userPool]
    // });

    // const helloFunction = new lambdanode.NodejsFunction(this, 'hello function', {
    //   runtime: lambda.Runtime.NODEJS_16_X,
    //   entry: join(__dirname, "../src/hello.ts"),
    //   handler: 'main',
    //   logRetention: logs.RetentionDays.ONE_DAY,
    // });

    const sessionTable = new dynamodb.Table(this, 'Session Table', {
      partitionKey: { name: 'session_id', type: AttributeType.STRING },
      removalPolicy: RemovalPolicy.DESTROY
    });

    if (COGNITO_CLIENT_ID == null || COGNITO_SECRET == null) {
      throw new Error("Must define COGNITO_CLIENT_ID and COGNITO_SECRET");
    }

    const oauthCallbackFunction = new lambdanode.NodejsFunction(this, 'OAuth callback function', {
      runtime: lambda.Runtime.NODEJS_16_X,
      entry: join(__dirname, "../src/oauth-callback.ts"),
      handler: 'main',
      logRetention: logs.RetentionDays.FIVE_DAYS,
      environment: {
        COGNITO_CLIENT_ID,
        COGNITO_SECRET,
        MY_DOMAIN: domainName,
        REDIRECT_URI: `https://ui.${domainName}/`,
        MY_URI: `https://api.${domainName}/oauthcallback`,
        TABLE_NAME: sessionTable.tableName,
        ENV_NAME: ns
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
      //   allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']
      // }
    });

    const corsOptions = {
      allowOrigins: Cors.ALL_ORIGINS,
      allowHeaders: Cors.DEFAULT_HEADERS,
      allowMethods: Cors.ALL_METHODS,
    };

    // const rHello = api.root.addResource('hello');
    // rHello.addMethod("GET", new LambdaIntegration(helloFunction), { //  new MockIntegration()
    //   authorizationType: AuthorizationType.COGNITO,
    //   authorizer
    // });

    const rOauthCallback = api.root.addResource('oauthcallback');
    rOauthCallback.addMethod("GET", new LambdaIntegration(oauthCallbackFunction));
    rOauthCallback.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));

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
      })
    };
    const rQueries = api.root.addResource("queries");
    rQueries.addMethod("GET", new LambdaIntegration(queriesGetListFunction), auth)
    rQueries.addMethod("POST", new LambdaIntegration(queriesPostFunction), auth);
    rQueries.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));
    const rQueriesById = rQueries.addResource("{id}");
    rQueriesById.addMethod("GET", new LambdaIntegration(queriesGetFunction), auth);
    rQueriesById.addMethod("PUT", new LambdaIntegration(queriesPutFunction), auth);
    rQueriesById.addMethod("DELETE", new LambdaIntegration(queriesDeleteFunction), auth);
    rQueriesById.addMethod("OPTIONS", new LambdaIntegration(optionsFunction));

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

    if (props.isProduction) {
      // S3 Bucket that CloudFront Distribution will log to
      const s3BucketLog = new s3.Bucket(this, `${ns}-s3-log`, {
        // Block all public access
        blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
        // When stack is deleted, delete this bucket also
        removalPolicy: cdk.RemovalPolicy.DESTROY,
        // Delete contained objects when bucket is deleted
        autoDeleteObjects: true
      });

      // S3 Bucket that will contain static web content and serve as origin to CloudFront Distribution
      const s3BucketWeb = new s3.Bucket(this, `${ns}-s3-web`, {
        // Block all public access
        blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
        // When stack is deleted, delete this bucket also
        removalPolicy: cdk.RemovalPolicy.DESTROY,
        // Delete contained objects when bucket is deleted
        autoDeleteObjects: true
      });

      // CloudFront Distribution pointing to S3 Web Bucket for origin and S3 Log Bucket for logging
      // Defaults:
      //  - min protocol version: TLS 1.2
      //  - max HTTP version:     HTTP/2
      const cloudFrontDistrib = new cloudFront.Distribution(this, `${ns}-cloudfront`, {
        // Default behavior config
        defaultBehavior: {
          // Point to S3 Web Bucket as origin
          origin: new cloudFrontOrigins.S3Origin(s3BucketWeb),
          // HTTP requests will be redirected to HTTPS
          viewerProtocolPolicy: cloudFront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
          // Only allow GET, HEAD, OPTIONS methods
          allowedMethods: cloudFront.AllowedMethods.ALLOW_GET_HEAD_OPTIONS,
          // Cache GET, HEAD, OPTIONS
          cachedMethods: cloudFront.CachedMethods.CACHE_GET_HEAD_OPTIONS
        },
        errorResponses: [
          {
            httpStatus: 403,
            responseHttpStatus: 200,
            responsePagePath: '/index.html'
          }, {
            httpStatus: 404,
            responseHttpStatus: 200,
            responsePagePath: '/index.html'
          }
        ],
        // Enable default logging
        enableLogging: true,
        // Point to S3 Log Bucket
        logBucket: s3BucketLog,
        // Log prefix
        logFilePrefix: `cloudfront-access-logs-${ns}`,
        // If index.html is not specified in URL, assume it rather than given a 404 error
        defaultRootObject: 'index.html',
        // Allow IPv6 DNS requests with an IPv6 address
        enableIpv6: true,
        // Restrict site to the USA and Canada
        geoRestriction: cloudFront.GeoRestriction.allowlist('US', 'CA'),
        // 100 is USA, Canada, Europe and Israel
        priceClass: cloudFront.PriceClass.PRICE_CLASS_100,
        // Descriptive comment
        comment: `CloudFront distribution in ${ns} environment`
      });

      // Deploy the static web content to the S3 Web Bucket
      const deploymentToS3Web = new s3deploy.BucketDeployment(this, `${ns}-s3deploy`, {
        // Static web content source
        // Note: the path to the source must be kept updated in case of repo folder restructuring or
        // refactoring
        sources: [s3deploy.Source.asset(join(__dirname, '../ui/build'))],
        // Point to the S3 Web Bucket
        destinationBucket: s3BucketWeb
      });

      new cdk.CfnOutput(this, "CloudFront bucket", {
        value: s3BucketWeb.bucketName
      });
      new cdk.CfnOutput(this, "CloudFront DNS", {
        value: cloudFrontDistrib.domainName
      });
    }
  }
}