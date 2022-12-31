import { APIGatewayProxyEventV2, APIGatewayProxyStructuredResultV2, S3Event } from 'aws-lambda';
import * as AWS from 'aws-sdk';
import { PutItemOutput } from 'aws-sdk/clients/dynamodb';
import * as csv from 'csv-parse';
import { v4 as uuidv4 } from 'uuid';
import { doDBClose, doDBCommit, doDBOpen, doDBQuery } from "./db-utils";

interface UploadInfo {
  type: string;
  key: string;
}

const { S3_BUCKET_NAME: bucketName, REGION, STATUS_TABLE: statusTableName } = process.env;
const s3 = new AWS.S3({ region: REGION });
const dynamodb = new AWS.DynamoDB({ region: REGION });

type CsvProcessCallback = (record: string[], lnum: number, identifier: string, errors: Error[]) => Promise<void>;

interface TypesConfigElement {
  processRowFunction: CsvProcessCallback;
}

const typesConfig: { [type: string]: TypesConfigElement } = {
  assessments: {
    processRowFunction: processAssessmentRow
  }
}

// CREATE TABLE `dbvkd`.`data_assessments` (
//     `id` INT NOT NULL AUTO_INCREMENT,
//     `sy` INT NULL,
//     `org_id` VARCHAR(45) NULL,
//     `test_name` VARCHAR(128) NULL,
//     `indicator_label` VARCHAR(45) NULL,
//     `assess_group` VARCHAR(45) NULL,
//     `assess_label` VARCHAR(45) NULL,
//     `value_w_st` FLOAT NULL,
//     PRIMARY KEY (`id`));

async function processAssessmentRow(record: string[], lnum: number, identifier: string, errors: Error[]): Promise<void> {
  if (lnum > 1) {
    if (record.length != 9) throw new Error(`lines expected to have 9 columns`);

    if ((lnum % 1000) == 0) console.log(lnum);
    const values = {
      sy: parseInt(record[0]),
      org_id: record[1],
      test_name: record[2],
      indicator_label: record[3],
      assess_group: record[4],
      assess_label: record[5],
      value_w: (record[6] == '' || record[6] == 'NULL') ? null : parseFloat(record[6]),
      value_w_st: (record[7] == '' || record[7] == 'NULL') ? null : parseFloat(record[7]),
      value_w_susd: (record[8] == '' || record[8] == 'NULL') ? null : parseFloat(record[8])
    };
    await doDBQuery(
      `insert into data_assessments (sy, org_id, test_name, indicator_label, assess_group, assess_label, value_w, value_w_st, value_w_susd) 
            values (?, ?, ?, ?, ?, ?, ?, ?, ?) \
            on duplicate key update \
            sy=?, org_id=?, test_name=?, indicator_label=?, assess_group=?, assess_label=?, value_w=?, value_w_st=?, value_w_susd=?`,
      [
        values.sy, values.org_id, values.test_name, values.indicator_label, values.assess_group, values.assess_label, values.value_w, values.value_w_st, values.value_w_susd,
        values.sy, values.org_id, values.test_name, values.indicator_label, values.assess_group, values.assess_label, values.value_w, values.value_w_st, values.value_w_susd
      ]
    );
  }
}

async function updateStatus(id: string, status: string, percent: number, numRecords: number, errors: Error[]): Promise<PutItemOutput> {
  return dynamodb.putItem({
    TableName: statusTableName!,
    Item: {
      id: { S: id },
      status: { S: status },
      numRecords: { N: numRecords.toString() },
      percent: { N: percent.toString() },
      errors: { S: JSON.stringify(errors.map(e => e.message)) },
      lastUpdated: { S: new Date().toISOString() }
    }
  }).promise();
}

export async function status(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyStructuredResultV2> {
  const ret = await dynamodb.getItem({
    TableName: statusTableName!,
    Key: {
      id: { S: event.pathParameters!.uploadId }
    }
  }).promise();

  if (ret.Item == null) {
    return {
      statusCode: 500
    };
  } else {
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Access-Control-Allow-Methods": "GET",
      },
      body: JSON.stringify({
        status: ret.Item.status.S,
        numRecords: ret.Item.numRecords.N,
        percent: ret.Item.percent.N,
        errors: ret.Item.errors.S,
        lastUpdated: ret.Item.lastUpdated.S
      })
    };
  }
}

export async function main(
  event: S3Event,
): Promise<string> {
  console.log(`S3_BUCKET_NAME=${bucketName}, REGION=${REGION}, event 👉`, event);

  const bucket = event.Records[0].s3.bucket.name;
  const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
  const params = {
    Bucket: bucket,
    Key: key,
  };
  console.log('params', params);
  try {
    const { ContentType, Body } = await s3.getObject(params).promise();
    const { TagSet } = await s3.getObjectTagging(params).promise();
    console.log('CONTENT TYPE:', ContentType);
    const bodyContents = Body?.toString('utf-8');

    //[ { Key: 'type', Value: 'assessments' } ]
    console.log('TAGS:', TagSet);
    const tags: { [key: string]: string } = {};
    if (TagSet != null) TagSet.forEach(tag => tags[tag.Key.toLowerCase()] = tag.Value.toLowerCase());
    console.log(`tags = ${tags}`);
    if (tags.type == null || bodyContents == null) {
      return 'unknown';
    }

    // Get the identifier. Just create a UUID if one not provided like it should be.
    const identifier = tags.identifier || uuidv4();
    console.log(`set in progress ${identifier}`);
    await updateStatus(identifier, 'In progress', 0, 0, []);

    console.log('opening connection');
    await doDBOpen();
    console.log('connection open');

    const errors: Error[] = []
    let rowCount = 0;
    let saveTotal = 0;
    let statusUpdatePct = 0;
    try {
      let lastStatusUpdatePct = 0;
      await processCSV(bodyContents, async (record, index, total) => {
        await typesConfig[tags.type].processRowFunction(record, index, identifier, errors);

        // Update status every 10%
        statusUpdatePct = Math.round(100 * index / total);
        if (Math.floor(lastStatusUpdatePct / 10) != Math.floor(statusUpdatePct / 10)) {
          lastStatusUpdatePct = statusUpdatePct;
          await updateStatus(identifier, 'In progress', statusUpdatePct, total, []);
        }
        rowCount += 1;
        saveTotal = total;
      });
      await updateStatus(identifier, (errors.length == 0 ? 'Complete' : 'Error'), statusUpdatePct, saveTotal, errors);
      await doDBCommit();
    } catch (e) {
      await updateStatus(identifier, 'Error', statusUpdatePct, saveTotal, [e as Error]);
    } finally {
      await doDBClose();
    }

    return ContentType || 'unknown';
  } catch (err) {
    console.error(err);
    const message = `Error getting object ${key} from bucket ${bucket}. Make sure they exist and your bucket is in the same region as this function.`;
    console.log(message);
    throw new Error(message);
  }
}

async function parseCSV(recordsString: string): Promise<string[][]> {
  return new Promise<string[][]>((resolve, reject) => {
    csv.parse(recordsString, (err, tempRecords: string[][]) => {
      if (err) {
        reject(new Error(`csv.parse error: ${err.message}`));
      } else {
        console.log(`number of records processing csv: ${tempRecords.length}`)
        resolve(tempRecords);
      }
    });
  })
}

async function processCSV(recordsString: string, callback: (record: string[], index: number, total: number) => Promise<void>): Promise<void> {
  // First parse into array. Hopefully there are not too many!
  let records: string[][] = await parseCSV(recordsString);

  // Now process the records
  console.log(`number of records: ${records.length}`);
  for (let i = 0; i < records.length; i++) {
    await callback(records[i], i + 1, records.length);
  }
}

if (!module.parent) {
  (async () => {
    await main({
      Records: [{
        s3: {
          bucket: {
            name: 'master-localdevbranch-uploadsbucket86f42938-1x6dlq695pl4z'
          },
          object: {
            key: 'Assessment_2019a.csv'
          }
        }
      }]
    } as S3Event)
  })().catch(err => {
    console.log(`exception`, err);
  });
} else {
  console.log("we're NOT in the local deploy, probably in Lambda");
}
