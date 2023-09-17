// usage
//  node scripts\upload-csv.js base-file-name upload-type identifier-suffix
//
const { execSync } = require('child_process');
const argv = require('yargs/yargs')(process.argv.slice(2)).argv;
const args = argv._;
// console.log({message: 'argv', argv, positionals: argv._, d: argv.d});
// process.exit(0);

function usage() {
  console.error(`usage:\n  node scripts/upload-csv.js base-file-name upload-type identifier-suffix qa|prod\n    or\n  node scripts/upload-csv.js general-upload-type identifier-suffix qa|prod`)
  console.error(' -d <upload directory>');
  process.exit(1);
}

const { isProd, baseFileName, uploadType, identifierSuffix } = (() => {
  console.log('args len', args.length);
  if (args.length === 3) {
    // Validate
    if (!["qa", "prod"].includes(args[2])) {
      usage();
    }
    return {
      baseFileName: args[0] + '.csv',
      uploadType: 'general:' + args[0],
      identifierSuffix: args[1],
      isProd: (args[2] === 'prod'),
    }
  } else if (args.length === 4) {
    if (!["qa", "prod"].includes(args[3])) {
      usage();
    }
    return {
      baseFileName: args[0],
      uploadType: args[1],
      identifierSuffix: args[2],
      isProd: (args[3] === 'prod'),
    }
  } else {
    usage();
  }
})();

const baseDir = argv.d || '\\Users\\bisagag\\Downloads';
console.log('baseDir ', baseDir);
const timestamp = new Date().toISOString();
const date = `${timestamp.substring(0, 4)}${timestamp.substring(5, 7)}${timestamp.substring(8, 10)}`
const bucket = `ctechnica-vkd-${isProd ? 'prod' : 'qa'}`;
const hostname = isProd ? 'api.vtkidsdata.org' : 'api.qa.vtkidsdata.org';
const identifier = `${date}-${identifierSuffix}`;
const statusUrl = `https://${hostname}/uploads/${identifier}`;

console.log({ baseFileName, bucket, uploadType, identifier, date, statusUrl });

function doCommand(cmd) {
  console.log(cmd);
  execSync(cmd);
}
doCommand(`aws s3 cp "${baseDir}/${baseFileName}" s3://${bucket}`);
doCommand(`aws s3api put-object-tagging --bucket ${bucket} --key "${baseFileName}" --tagging "TagSet=[{Key=identifier,Value=${identifier}},{Key=type,Value=${uploadType}}]"`);

// for (;;) {
//   execSync(`curl ${statusUrl}`);
// }