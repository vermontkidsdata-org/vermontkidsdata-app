export function addAssetSnapshotSerializer(account: string, region: string): void {
  const bucketMatch = new RegExp(`cdk-[0-9a-z]{9}-assets-${account}-${region}`);
  const assetMatch = /[0-9a-f]{64}\.zip/;

  expect.addSnapshotSerializer({
    test: (val) => typeof val === 'string'
        && (val.match(bucketMatch) != null
         || val.match(assetMatch) != null),
    print: (val) => {
      // Substitute both the bucket part and the asset zip part
      let sval = `${val}`;
      sval = sval.replace(bucketMatch, '[ASSET BUCKET]');
      sval = sval.replace(assetMatch, '[ASSET ZIP]');
      return `"${sval}"`;
    }
  });
}
