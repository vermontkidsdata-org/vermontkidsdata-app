import {APIGatewayEventRequestContextV2, APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2} from 'aws-lambda';
import { Liquid } from 'liquidjs';
import * as AWS from 'aws-sdk';
import * as s3 from '@aws-sdk/client-s3';
import * as fs from 'fs';
import {v4 as uuidv4} from 'uuid';
import * as StreamZip from 'node-stream-zip';
import { GetObjectCommandOutput } from '@aws-sdk/client-s3';
import { Readable } from 'stream';

const engine = new Liquid();

const S3_PREFIX = "s3://";
let s3Client = new s3.S3Client({});
const baseDir = '/tmp';

async function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function getAndUnzip(bucketName: string, keyName: string): Promise<string> {
  console.log(`bucketName=${bucketName}, keyName=${keyName}`);
  return new Promise<string>(async (resolve, reject) => {
    try {
      const resp: GetObjectCommandOutput = await s3Client.send(new s3.GetObjectCommand({
        Bucket: bucketName,
        Key: keyName
      })); 
    
      const uuid = uuidv4();
      const tempfile = `${baseDir}/${uuid}.zip`;
      const tempdir = `${baseDir}/${uuid}`;
      const destzipstream = await (resp.Body as Readable).pipe(fs.createWriteStream(tempfile));
      
      console.log('done destzipstream');
      // I have no idea why I need to sleep here. It should only be the first time the Lambda
      // invocation is started though.
      await sleep(3000);
      console.log('done sleep');
      const zip = new StreamZip.async({ file: tempfile });
      console.log('done zipfile');

      await zip.extract(null, tempdir);
      console.log('done unzipping to tempdir', tempdir);
      // const entries = await zip.entries();
      // for (const entry of Object.values(entries)) {
      //     const desc = entry.isDirectory ? 'directory' : `${entry.size} bytes`;
      //     console.log(`Entry ${entry.name}: ${desc}`);
      // }
      
      // Do not forget to close the file once you're done
      await zip.close();
      resolve(tempdir);
    } catch (e) {
      console.log('******** exception', e);
      reject(e);
    }
  })
}

// Load the templates during Lambda initialization
// Has the s3:// part also
const views = process.env['views']!;
if (!views.startsWith(S3_PREFIX) || !views.endsWith(".zip")) {
  throw new Error(`chartsRender: views not an S3 zip file ${views}`)
}

const bucketKey = views.substring(S3_PREFIX.length);
const bucketName = bucketKey.substring(0, bucketKey.indexOf('/'));
const keyName = bucketKey.substring(bucketKey.indexOf('/')+1);

const tempdir = getAndUnzip(bucketName, keyName).then(() => {
  console.log(`done fetch and unzip, tempdir=${tempdir}`);
})

export async function bar(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  if (event.pathParameters == null || event.pathParameters.chartId == null) {
    return {
      statusCode: 400
    }; 
  } else {
    const chartId = event.pathParameters.chartId;

    // The templates should already be loaded
    const tpl = engine.parse('Welcome to {{v}}, id={{id}}!');
    const rendered = await engine.render(tpl, {v: "Liquid", id: chartId});

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html'
      },
      body: rendered
    };
  }
}

// (async () => {
//   console.log('from CLI');
//   s3Client = new s3.S3Client({ region: "us-east-1", credentials: new AWS.SharedIniFileCredentials({profile: 'vkd'}) });

//   const event = {
//     pathParameters: {
//       chartId: 1234
//     }
//   };
//   process.env['views'] = 's3://elasticbeanstalk-us-east-1-439348011602/views.zip';
//   //'s3://pipelinedevstage-censusa-templatedistributionbuck-15mcyw9ttm9f9';
//   console.log(await bar(event as any));
// })();
