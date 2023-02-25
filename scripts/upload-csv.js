// usage
//  node scripts\upload-csv.js base-file-name upload-type identifier-suffix
//
const { execSync } = require('child_process');

const baseFileName = process.argv[2];
const uploadType = process.argv[3];
const identifierSuffix = process.argv[4];
const baseDir = '\\Users\\bisagag\\Downloads';
const timestamp = new Date().toISOString();
const date = `${timestamp.substring(0,4)}${timestamp.substring(5,7)}${timestamp.substring(8,10)}`
const bucket = 'ctechnica-vkd-qa';
const hostname = 'api.qa.vtkidsdata.org';
const identifier = `${date}-${identifierSuffix}`;
const statusUrl = `https://${hostname}/uploads/${identifier}`;

console.log({baseFileName, bucket, uploadType, identifier, date, statusUrl});

execSync(`aws s3 cp ${baseDir}/${baseFileName} s3://${bucket}`);
execSync(`aws s3api put-object-tagging --bucket ${bucket} --key ${baseFileName} --tagging "TagSet=[{Key=identifier,Value=${identifier}},{Key=type,Value=${uploadType}}]"`);

for (;;) {
  execSync(`curl ${statusUrl}`);
}