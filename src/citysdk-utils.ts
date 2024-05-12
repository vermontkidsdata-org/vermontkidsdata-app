const citysdk = require("citysdk");

export interface GeoHierarchy {
  state: string,
  county?: string,
  "county subdivision"?: string,
}

export interface CitySDKParams {
  vintage: number|string,
  geoHierarchy: GeoHierarchy,
  // E.g. 'acs','acs5'
  sourcePath: string[],
  // E.g. 'B00001_001E'
  values: string[],
  // Resolution of GeoJSON ("20m", "5m", and "500k" available)
  geoResolution?: string,
  predicates?: any,
  statsKey?: string
}

export interface CensusResultRow {
  // "Header" returned from census
  county: string;
  state: string;
  "county-subdivision": string | undefined;

  // Additional rollup name (optional, only for town roll-ups)
  rollupName: string | undefined;
  
  // The header above, plus the individual variable values
  [varname: string]: string | undefined;
}

/**
 * Simple TypeScript wrapper for citysdk
 * @param params Same parameters sent to CitySDK
 * @returns Same response from CitySDK
 */
export async function census(params: CitySDKParams): Promise<CensusResultRow[]> {
  // console.log('starting citysdk-utils.census function');

  return new Promise<any>((resolve, reject) => {
    citysdk(params, (err: any, res: any) => {
        // console.log(`back from citysdk() function in citysdk-utils, err=${err}`);

        if (err) reject(err);
        else resolve(res);
      },
    )
  })
}
