import { APIGatewayProxyEventV2, APIGatewayProxyResultV2, APIGatewayProxyStructuredResultV2, S3Event, S3EventRecord } from 'aws-lambda';
import * as AWS from 'aws-sdk';
import * as csv from 'csv-parse';
import * as mysql from 'mysql';
import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";
import * as util from 'util';
import { v4 as uuidv4 } from 'uuid';
import { PutItemOutput } from 'aws-sdk/clients/dynamodb';

interface UploadInfo {
    type: string;
    key: string;
}

const { S3_BUCKET_NAME: bucketName, REGION, STATUS_TABLE: statusTableName } = process.env;
const s3 = new AWS.S3({});
const dynamodb = new AWS.DynamoDB({});

type CsvProcessCallback = (connection: mysql.Connection, record: string[], lnum: number, identifier: string, errors: Error[]) => Promise<void>;

interface TypesConfigElement {
    processRowFunction: CsvProcessCallback;
}

const typesConfig: { [type: string]: TypesConfigElement } = {
    assessments: {
        processRowFunction: processAssessmentRow
    }
}

async function doOpen(): Promise<mysql.Connection> {
    const smClient = new SecretsManagerClient({ region: REGION });

    // Get secret connection info
    const secrets = (await smClient.send(new GetSecretValueCommand({
      SecretId: 'vkd/prod/dbcreds'
    }))).SecretString;
  
    if (secrets == null) {
        throw new Error('DB connection info not found');
    } else {
      const info: {host: string, username: string, password: string} = JSON.parse(secrets);
      if (info.host == null || info.username == null || info.password == null) {
          throw new Error('DB connection info missing information');
      } else {
        return mysql.createConnection({
          host: info.host,
          user: info.username,
          password: info.password
        });
      }
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

async function query(connection: mysql.Connection, sql: string, values?: any[]): Promise<any> {
    if (values == null) values = [];
    return new Promise<any>((resolve, reject) => {
        // console.log(`query ${JSON.stringify(values)}`);
        return connection.query(sql, values, (err, results /*, fields*/) => {
            if (err) {
                reject(err);
            } else {
                resolve(results);
            }
        })
    });
}

async function processAssessmentRow(connection: mysql.Connection, record: string[], lnum: number, identifier: string, errors: Error[]): Promise<void> {
    if (lnum > 1) {
        const values = {
            sy: parseInt(record[0]),
            org_id: record[1], 
            test_name: record[2], 
            indicator_label: record[3], 
            assess_group: record[4], 
            assess_label: record[5], 
            value_w_st: (record[7] == '' || record[7] == 'NULL') ? null : parseFloat(record[7])
        };
        await query(
            connection,
            `insert into data_assessments (sy, org_id, test_name, indicator_label, assess_group, assess_label, value_w_st) 
            values (?, ?, ?, ?, ?, ?, ?) \
            on duplicate key update \
            sy=?, org_id=?, test_name=?, indicator_label=?, assess_group=?, assess_label=?, value_w_st=?`,
            [  
                values.sy, values.org_id, values.test_name, values.indicator_label, values.assess_group, values.assess_label, values.value_w_st,
                values.sy, values.org_id, values.test_name, values.indicator_label, values.assess_group, values.assess_label, values.value_w_st
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
    console.log(`S3_BUCKET_NAME=${bucketName}, REGION=${REGION}, event 👉`, util.inspect(event));

    const bucket = event.Records[0].s3.bucket.name;
    const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    const params = {
        Bucket: bucket,
        Key: key,
    }; 
    try {
        const { ContentType, Body } = await s3.getObject(params).promise();
        const { TagSet } = await s3.getObjectTagging(params).promise();
        console.log('CONTENT TYPE:', ContentType);
        const bodyContents = Body?.toString('utf-8');

        //[ { Key: 'type', Value: 'assessments' } ]
        console.log('TAGS:', TagSet);
        const tags: {[key: string]: string} = {};
        if (TagSet != null) TagSet.forEach(tag => tags[tag.Key.toLowerCase()] = tag.Value.toLowerCase());
        if (tags.type == null || bodyContents == null) {
            return 'unknown';
        }

        // Get the identifier. Just create a UUID if one not provided like it should be.
        const identifier = tags.identifier || uuidv4();
        await updateStatus(identifier, 'In progress', 0, 0, []);

        console.log('opening connection');
        const connection = await doOpen();
        console.log('connection open');
        await query(connection, 'use dbvkd');

        const errors: Error[] = []
        let rowCount = 0;
        let saveTotal = 0;
        let statusUpdatePct = 0;
        try {
            let lastStatusUpdatePct = 0;
            await processCSV(bodyContents, async (record, index, total) => {
                await typesConfig[tags.type].processRowFunction(connection, record, index, identifier, errors);

                // Update status every 10%
                statusUpdatePct = Math.round(100 * index/total);
                if (Math.floor(lastStatusUpdatePct/10) != Math.floor(statusUpdatePct/10)) {
                    lastStatusUpdatePct = statusUpdatePct;
                    await updateStatus(identifier, 'In progress', statusUpdatePct, total, []);
                }
                rowCount += 1;
                saveTotal = total;
            });
            await updateStatus(identifier, (errors.length == 0 ? 'Complete' : 'Error'), statusUpdatePct, saveTotal, errors);
            await connection.commit();
        } catch (e) {
            await updateStatus(identifier, 'Error', statusUpdatePct, saveTotal, [e as Error]);
        }

        console.log('closing connection');
        await connection.end();
        console.log('connection closed');

        return ContentType || 'unknown';
    } catch (err) {
        console.log(err);
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
        await callback(records[i], i+1, records.length);
    }
}