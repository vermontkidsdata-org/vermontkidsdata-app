import { Stack, StackProps } from 'aws-cdk-lib';
import * as route53 from 'aws-cdk-lib/aws-route53'
import * as cdk from "aws-cdk-lib";
import { Construct } from 'constructs';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as s3deploy from 'aws-cdk-lib/aws-s3-deployment';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as targets from 'aws-cdk-lib/aws-route53-targets';

export interface StaticSiteProps extends StackProps {
  domainName: string;
  siteSubDomain: string;
}

export class UiDeployStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: StaticSiteProps) {
    super(scope, id, props);

    const zone = route53.HostedZone.fromLookup(this, "UiVtkidsdataZone", {
      domainName: props.domainName,
    });

    const siteDomain = props.siteSubDomain + "." + props.domainName;
    new cdk.CfnOutput(this, "UiVtkidsdataSite", { value: "https://" + siteDomain });

    // Content bucket
    const siteBucket = new s3.Bucket(this, "UiVtkidsdataSiteBucket", {
      bucketName: siteDomain,
      websiteIndexDocument: "index.html",
      websiteErrorDocument: "error.html",
      publicReadAccess: true,

      // The default removal policy is RETAIN, which means that cdk destroy will not attempt to delete
      // the new bucket, and it will remain in your account until manually deleted. By setting the policy to
      // DESTROY, cdk destroy will attempt to delete the bucket, but will error if the bucket is not empty.
      removalPolicy: cdk.RemovalPolicy.RETAIN, 
    });
    new cdk.CfnOutput(this, "UiVtkidsdataBucket", { value: siteBucket.bucketName });

    // TLS certificate
    const certificate = new acm.DnsValidatedCertificate(
      this,
      "UiVtkidsdataSiteCertificate",
      {
        domainName: siteDomain,
        hostedZone: zone,
        region: "us-east-1", // Cloudfront only checks this region for certificates.
      }
    );
    //new cdk.CfnOutput(this, "Certificate", { value: certificateArn });

    

    // CloudFront distribution that provides HTTPS
    const distribution = new cloudfront.CloudFrontWebDistribution(
      this,
      "UiVtkidsdataSiteDistribution",
      {
        viewerCertificate: cloudfront.ViewerCertificate.fromAcmCertificate(
          certificate,
          {
            aliases: [siteDomain],
            
          },
        ),
        originConfigs: [
          {
            customOriginSource: {
              domainName: siteBucket.bucketWebsiteDomainName,
              originProtocolPolicy: cloudfront.OriginProtocolPolicy.HTTP_ONLY,
            },
            behaviors: [{ isDefaultBehavior: true }],
          },
        ],
      }
    );
    new cdk.CfnOutput(this, "UiVtkidsdataDistributionId", {
      value: distribution.distributionId,
    });

    // Route53 alias record for the CloudFront distribution
    new route53.ARecord(this, "UiVtkidsdataSiteAliasRecord", {
      recordName: siteDomain,
      target: route53.RecordTarget.fromAlias(
        new targets.CloudFrontTarget(distribution)
      ),
      zone,
    });

    // Deploy site contents to S3 bucket
    new s3deploy.BucketDeployment(this, "UiVtkidsdataDeployment", {
      sources: [s3deploy.Source.asset("../build")],
      destinationBucket: siteBucket,
      distribution,
      distributionPaths: ["/*"],
    });

  }
}
