console.log('top of citysdk-utils file');

const citysdk = require("citysdk");

console.log('after import of citysdk of citysdk-utils file');

export interface CitySDKParams     {
  vintage: number|string,
  geoHierarchy: {
    state: string,
    county?: string,
  },
  // E.g. 'acs','acs5'
  sourcePath: string[],
  // E.g. 'B00001_001E'
  values: string[],
  // Resolution of GeoJSON ("20m", "5m", and "500k" available)
  geoResolution?: string,
  predicates?: any,
  statsKey?: string
}

/**
 * Simple TypeScript wrapper for citysdk
 * @param params Same parameters sent to CitySDK
 * @returns Same response from CitySDK
 */
export async function census(params: CitySDKParams): Promise<any> {
  console.log('starting citysdk-utils.census function');

  return new Promise<any>((resolve, reject) => {
    citysdk(params, (err: any, res: any) => {
        console.log(`back from citysdk() function in citysdk-utils, err=${err}`);

        if (err) reject(err);
        else resolve(res);
      }
    )
  })
}
