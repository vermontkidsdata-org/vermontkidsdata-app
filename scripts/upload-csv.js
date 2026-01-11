// usage
//  node scripts\upload-csv.js base-file-name upload-type
//
const { execSync } = require('child_process');
const { randomUUID } = require('crypto');

// Convert script to use async/await for ES Module imports
(async () => {
  // Use dynamic import for yargs (ES Module)
  const { default: yargs } = await import('yargs/yargs');
  const argv = yargs(process.argv.slice(2)).argv;
  const args = argv._;
  // console.log({message: 'argv', argv, positionals: argv._, d: argv.d});
  // process.exit(0);

  function usage() {
    console.error(`usage:\n  node scripts/upload-csv.js base-file-name upload-type qa|prod\n    or\n  node scripts/upload-csv.js general-upload-type qa|prod`)
    console.error(' -d <upload directory>\n');
    console.error(`Normal procedure for "general" upload types:
1. Download CSV to data directory
2. Rename CSV to <general-subtype>.csv (e.g. 'reachup')
3. Run this script: node scripts/upload-csv.js <general-subtype> qa|prod -d data`);
    process.exit(1);
  }

  const { isProd, baseFileName, uploadType } = (() => {
    console.log('args len', args.length);
    if (args.length === 2) {
      // Validate
      if (!["qa", "prod"].includes(args[1])) {
        usage();
      }
      return {
        baseFileName: args[0] + '.csv',
        uploadType: 'general:' + args[0],
        isProd: (args[1] === 'prod'),
      }
    } else if (args.length === 3) {
      if (!["qa", "prod"].includes(args[2])) {
        usage();
      }
      return {
        baseFileName: args[0],
        uploadType: args[1],
        isProd: (args[2] === 'prod'),
      }
    } else {
      usage();
    }
  })();

  const baseDir = argv.d || '\\Users\\bisagag\\Downloads';
  console.log('baseDir ', baseDir);
  // const timestamp = new Date().toISOString();
  // const date = `${timestamp.substring(0, 4)}${timestamp.substring(5, 7)}${timestamp.substring(8, 10)}`
  const bucket = `ctechnica-vkd-${isProd ? 'prod' : 'qa'}`;
  const hostname = isProd ? 'api.vtkidsdata.org' : 'api.qa.vtkidsdata.org';
  const identifier = `${randomUUID()}`;
  const statusUrl = `https://${hostname}/upload-status/${identifier}`;

  console.log({ baseFileName, bucket, uploadType, identifier, statusUrl });

  function doCommand(cmd) {
    console.log(cmd);
    execSync(cmd);
  }
  
  doCommand(`aws s3 cp "${baseDir}/${baseFileName}" s3://${bucket}`);
  doCommand(`aws s3api put-object-tagging --bucket ${bucket} --key "${baseFileName}" --tagging "TagSet=[{Key=identifier,Value=${identifier}},{Key=type,Value=${uploadType}}]"`);

  // for (;;) {
  //   execSync(`curl ${statusUrl}`);
  // }
})();