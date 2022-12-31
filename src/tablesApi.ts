import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { census, CensusResultRow, GeoHierarchy } from './citysdk-utils';
import { getHeaders } from './cors';
import { doDBClose, doDBOpen, doDBQuery, queryDB } from './db-utils';

interface GazCounty {
  id: number, // 2819
  year: number, // 2019
  USPS: number, // 'VT'
  GEOID: string, // '50025'
  ANSICODE: string, // '1461769',
  NAME: string, // 'Windham County',
  ALAND: string, // '2034457838',
  AWATER: string, // '32920750',
  ALAND_SQMI: string, // '785.509',
  AWATER_SQMI: string, // '12.711',
  INTPTLAT: string, // '42.995335',
  INTPTLONG: string, // '-72.721955'
}

// Function response types
export interface GetCensusByGeoResponse {
  metadata: {
    table: string,
    geoType: string,
    year: number,
    geo: string,
    sourcePath: string[],
    variables: string[] | undefined
  },
  columns: {
    id: string,
    label: string
  }[],
  rows: {
    [key: string]: string | number
  }[]
}

export interface GetGeosByTypeResponse {
  geos: {
    id: string,
    name: string
  }[]
}

export interface ErrorResponse {
  message: string
}

interface ColumnMap {
  [key: string]: string
}

interface QueryRow {
  id: number,
  name: string,
  sqlText: string,
  columnMap?: string,
  metadata: string
};

async function getQuery(queryId: string): Promise<{ rows: QueryRow[] }> {
  // Just in case
  await doDBOpen();

  // Get the query to run from the parameters
  const queryRows = await doDBQuery('SELECT sqlText, columnMap, metadata FROM queries where name=?', [queryId]);
  console.log(queryRows);
  if (queryRows.length == 0) {
    throw new Error('unknown query');
  } else {
    return {
      rows: queryRows
    }
  }
}

async function localDBQuery(queryId: string): Promise<{ rows: any[], columnMap?: ColumnMap, metadata?: Object }> {
  const info = await getQuery(queryId);

  // Now run the query. Should always return three columns, with the following names
  // - cat: The category(s)
  // - label: The label for the values
  // - value: The value for the values
  const resultRows = await doDBQuery(info.rows[0].sqlText);
  console.log('result', resultRows);

  console.log('row0', info.rows[0])
  const columnMap = info.rows[0].columnMap != null ? JSON.parse(info.rows[0].columnMap) : undefined;
  return { rows: resultRows, columnMap: columnMap, metadata: JSON.parse(info.rows[0].metadata) };
}

export async function table(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
  if (event.pathParameters == null || event.pathParameters.queryId == null) {
    return {
      headers: getHeaders("application/json"),
      statusCode: 400
    };
  } else {
    const queryId = event.pathParameters.queryId;

    // Get the columns parameter, if any
    const columnsProjection = (event.queryStringParameters?.columns != null) ?
      event.queryStringParameters.columns.split(',') :
      undefined;

    try {
      // We assume we're getting back an array of values with the value keys being the key into the columnMap
      // columnMap => {'infant': 'Infant', 'toddler': 'Toddler', 'preschool': 'Preschool'}
      const resultRows = await localDBQuery(queryId);

      interface QueryResult {
        cat: string,
        label: string,
        value: string
      };

      const columns: { id: string, label: string }[] = [];
      const rows: { [key: string]: any }[] = [];

      for (let i = 0; i < resultRows.rows.length; i++) {
        // We'll take the column labels from the first row
        // First column in row is row label; rest are the columns
        const row = resultRows.rows[i];
        // console.log(`row`, row);
        if (i === 0) {
          // Build up the columns
          const keys = Object.keys(row);
          // console.log('keys', keys, 'cmap', resultRows.columnMap);
          for (let j = 0; j < keys.length; j++) {
            const key = keys[j];
            const label = resultRows.columnMap && resultRows.columnMap[key] != null
              ? resultRows.columnMap[key]
              : key;
            columns.push({
              id: key,
              label: label
            });
          }

          // If there's a column projection, select and re-order the columns
          if (columnsProjection != null) {
            const originalColumns = columns.splice(0, columns.length);
            // console.log(`originalColumns = ${JSON.stringify(originalColumns)}, new columns before=${columns}`);
            for (const columnProjection of columnsProjection) {
              const column = originalColumns.find(oc => oc.id.toLowerCase() === columnProjection.toLowerCase());
              // console.log(`- for ${columnProjection} found? ${JSON.stringify(column)}`);
              if (column) {
                columns.push(column);
              } else {
                return {
                  statusCode: 400,
                  headers: getHeaders("application/json"),
                  body: JSON.stringify({
                    message: 'unknown column projection'
                  })
                };

              }
            }
          }
        }

        // All rows, return the data
        const rowval: { [key: string]: any } = {};
        Object.values(columns).forEach(col => {
          rowval[col.id] = row[col.id];
        });
        rows.push(rowval);
      }
      const metadata: any = {};
      if (resultRows.metadata) {
        metadata.config = resultRows.metadata;
      }
      const body = {
        id: queryId,
        metadata,
        columns,
        rows
      };
      // console.log('body', JSON.stringify(body, null, 2));
      return {
        statusCode: 200,
        headers: getHeaders("application/json"),
        body: JSON.stringify(body)
      };
    } catch (e) {
      console.log(e);
      return {
        statusCode: 500,
        headers: getHeaders("application/json"),
        body: (e as Error).message
      };
    } finally {
      await doDBClose();
    }
  }
}

export interface AcsVariable {
  variable: string, // 'B09001_009E',
  label: string, // 'Estimate!!Total!!In households!!15 to 17 years',
  concept: string, // 'POPULATION UNDER 18 YEARS BY AGE',
  predicateType: string, // 'int',
  group: string, // 'B09001',
  limit: number, // 0,
  attributes: string, // 'B09001_009M,B09001_009MA,B09001_009EA',
  year: number, // 2016
  tableType: string | undefined // Either 'subject' or null for non-subject tables
}

// Table gaz_geography_map
export interface GazGeographyMap {
  id: number,
  gaz_county_subdivision: string,
  gaz_county_subdivision_name: string,
  geography_map_type: string,
  geography_map_label: string,
  geography_map_name: string,
  geography_map_geoid: number,
  geography_map_owner: string
}

interface ApiTableResultColumn { id: string, label: string }
interface ApiTableResultRow { [key: string]: any }

interface DBACSVariables {
  [key: string]: {
    used: boolean,
    label: string
  }
}

function censusResultsToTable(censusResults: CensusResultRow[], dBVariables: DBACSVariables, columns: ApiTableResultColumn[] | undefined, rows: ApiTableResultRow[], variables: string[]): void {
  if (columns != null) {
    variables.forEach(variable => {
      const label = dBVariables[variable] == null && variable.endsWith('M') ?
        'MOE' : dBVariables[variable] != null ?
          dBVariables[variable].label :
          'Unknown';
      columns.push({ id: variable, label });
    });
  }

  censusResults.forEach(censusResult => {
    const row: { [key: string]: any } = {};
    if (censusResult.rollupName != null) {
      row.geo = censusResult.rollupName;
    } else if (censusResult.county == null) {
      row.geo = 'Vermont';
    } else {
      row.geo = censusResult.state + (censusResult.county || '');
    }
    variables.forEach(variable => {
      row[variable] = parseInt(censusResult[variable] || '-99');
    });
    rows.push(row);
  });
}

function getCountySubdivisions(geoType: string, geo?: string): string {
  return "*";
}

// Rollup map, works for any geoType (obviously you have to know what it is...)
// The key is the complete town id (2 digit state, 3 digit county, 5 digit county subdivision)
interface TownRollupMap {
  [gaz_county_subdivision: string]: {
    geography_map_geoid: number,
    geography_map_name: string
  }
}

async function getTownRollupMap(geoType: string): Promise<TownRollupMap | undefined> {
  const mappings: { gaz_county_subdivision: string, geography_map_geoid: number, geography_map_name: string }[] =
    await queryDB('select gaz_county_subdivision, geography_map_geoid, geography_map_name from gaz_geography_map where geography_map_type=?', [geoType]);
  if (mappings.length === 0) return undefined;

  const ret: TownRollupMap = {};
  mappings.forEach(mapping => ret[mapping.gaz_county_subdivision] = {
    geography_map_geoid: mapping.geography_map_geoid,
    geography_map_name: mapping.geography_map_name
  });
  return ret;
}

function rollUpTownResultsByGeoType(censusResults: CensusResultRow[], rollupMap: TownRollupMap | undefined): CensusResultRow[] {
  const rollupResults: {
    [geography_map_geoid: number]: CensusResultRow
  } = {};
  if (rollupMap == null) {
    return censusResults;
  } else {
    censusResults.forEach(censusResult => {
      const gaz_county_subdivision = censusResult.state + censusResult.county + censusResult['county-subdivision'];
      const rollupMapKeys = Object.keys(rollupMap);
      if (rollupMapKeys.includes(gaz_county_subdivision)) {
        const geography_map_geoid = rollupMap[gaz_county_subdivision].geography_map_geoid;
        const existingRow = rollupResults[geography_map_geoid];
        if (existingRow == null) {
          // console.log(`first time for geoid=${geography_map_geoid}`);
          censusResult.rollupName = rollupMap[gaz_county_subdivision].geography_map_name;
          censusResult['county-subdivision'] = undefined;
          censusResult.county = "*";
          rollupResults[geography_map_geoid] = censusResult;
        } else {
          Object.entries(censusResult).forEach(entry => {
            const key = entry[0];
            const value = entry[1] || '0';
            if (!['county', 'state', "county-subdivision", 'rollupName'].includes(key)) {
              if (existingRow[key] != null) {
                const oldValue = existingRow[key]!;
                existingRow[key] = `${parseInt(oldValue) + parseInt(value)}`;
                // console.log(`value to aggregate for geoid=${geography_map_geoid}: ${key} = ${oldValue} + ${value} => ${existingRow[key]}`);
              } else {
                // console.log(`first in row for geoid=${geography_map_geoid}: ${key} => ${entry[1]}`);
                existingRow[key] = value;
              }
            }
          })
        }
      } else {
        throw new Error(`internal error: unknown gaz_county_subdivision ${gaz_county_subdivision}`);
      }

    });
  }
  return Object.values(rollupResults);
}

interface CensusDataset {
  vintage: number | undefined,
  dataset: string
}

async function validateDataSet(year: number, dataset: string): Promise<string[] | undefined> {
  const ds: CensusDataset[] = await queryDB(`select vintage, dataset from census_datasets where vintage=? and dataset=?`, [year, dataset]);
  if (ds == null || ds.length != 1) {
    return undefined;
  } else {
    return dataset.split('/');
  }
}


export async function getCensusByGeo(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2<GetCensusByGeoResponse>> {
  console.log('starting main function');
  try {
    const pathParameters = event.pathParameters || {};
    const table = pathParameters.table!;
    const geoType = pathParameters.geoType!;

    const queryStringParameters = event.queryStringParameters || {};
    const year = parseInt(queryStringParameters.year || '2020');
    const geo = queryStringParameters.geo || '*';
    const dataset = queryStringParameters.dataset;
    const variables = queryStringParameters.variables ? queryStringParameters.variables.split(',').map(v => v.toUpperCase()) : undefined;
    const extensions = (queryStringParameters.extensions || '').split(',').map(ex => ex.toLowerCase()); // Comma-separated extensions
    const isExtensionSimpleMOE = extensions.includes('moe');

    // Don't allow towns - almost works but not quite...
    const townGeoTypes: string[] = [];
    const georows: { geography_map_type: string }[] = await queryDB('SELECT distinct geography_map_type FROM gaz_geography_map');
    georows.forEach(row => townGeoTypes.push(row.geography_map_type));
    if (!['county', 'state'].includes(geoType) && !townGeoTypes.includes(geoType)) {
      return {
        body: JSON.stringify({
          message: 'unknown geography type',
        }),
        headers: getHeaders("application/json"),
        statusCode: 400,
      };
    }

    // Get census variables
    const acsVars: AcsVariable[] = await queryDB('select * from acs_variables where `group`=? order by variable', [table.toUpperCase()]);
    if (acsVars.length === 0) {
      return {
        body: JSON.stringify({
          message: 'unknown table',
        }),
        headers: getHeaders("application/json"),
        statusCode: 400,
      };
    }

    // This is the tracker for vars from the DB (used to ensure no invalid variables were
    // requested)
    const dBVariables: DBACSVariables = {};
    acsVars.forEach(acsVar => {
      dBVariables[acsVar.variable] = {
        used: false,
        label: acsVar.label
      }
    });

    // The actual list of query variables
    const queryVars = variables != null ? variables
      : acsVars.map(acsVar => acsVar.variable.toUpperCase());

    // See if there's the MOE extension; just supplement the 'E's with 'M's
    if (isExtensionSimpleMOE) {
      const extendedQueryVars: string[] = [];
      for (const qv of queryVars) {
        extendedQueryVars.push(qv);
        if (qv.toUpperCase().endsWith('E')) {
          extendedQueryVars.push(`${qv.substring(0, qv.length - 1)}M`);
        }
      }

      // Replace queryVars
      queryVars.length = 0;
      queryVars.push(...extendedQueryVars);
    }

    // API limits to 50 variables
    if (queryVars.length > 50) {
      return {
        body: JSON.stringify({
          message: 'census API limited to 50 variables',
        }),
        headers: getHeaders("application/json"),
        statusCode: 400,
      };
    }

    // See if it's a subject table or not and alter the default dataset (otherwise, have to pass)
    const requestDataset = (dataset != null) ? dataset :
      acsVars[0].tableType === 'subject' ? 'acs/acs5/subject'
        : 'acs/acs5';

    const sourcePath = await validateDataSet(year, requestDataset);
    if (sourcePath == null) {
      return {
        body: JSON.stringify({
          message: 'invalid year/dataset combination',
        }),
        headers: getHeaders("application/json"),
        statusCode: 400,
      };
    }

    // Make sure every variable requested is actually in the DB for this table
    queryVars.forEach(queryVar => {
      if (dBVariables[queryVar] != null) {
        dBVariables[queryVar].used = true;
      }
    });
    const unknownVars = queryVars.filter(qv => {
      return dBVariables[qv] == null ||
        qv.endsWith('M') ? dBVariables[`${qv.substring(0, qv.length - 1)}E`] == null : false;
    });

    if (unknownVars.length > 0) {
      return {
        body: JSON.stringify({
          message: 'one or more unknown variables requested: ' + unknownVars,
        }),
        headers: getHeaders("application/json"),
        statusCode: 400,
      };
    }

    const columns: ApiTableResultColumn[] = [{ id: 'geo', label: 'Geography' }];
    const rows: ApiTableResultRow[] = [];

    if (geoType === 'county') {
      const geoHierarchy: GeoHierarchy = {
        state: "50"
      };
      if (geo) {
        geoHierarchy.county = geo;
      }

      const censusResults: CensusResultRow[] = await census({
        vintage: year,
        geoHierarchy: geoHierarchy,
        sourcePath,
        values: queryVars,
      });

      censusResultsToTable(censusResults, dBVariables, columns, rows, queryVars);

      // Now convert the county geos to names
      const dbCounties: GazCounty[] = await queryDB(`select * from gaz_counties where usps='VT'`);
      const counties: { [id: string]: GazCounty } = {}
      dbCounties.forEach((cty) => {
        counties[cty.GEOID] = cty;
      });

      rows.forEach(row => {
        if (counties[row.geo] != null) {
          row.geo = counties[row.geo].NAME;
        }
      });

    } else if (townGeoTypes.includes(geoType)) {
      const censusResults = await census({
        vintage: year,
        geoHierarchy: {
          state: '50',
          "county subdivision": getCountySubdivisions(geoType, geo)
        },
        sourcePath,
        values: queryVars,
      });
      const map = await getTownRollupMap(geoType);
      // console.log('rollup map', JSON.stringify(map, null, 2));
      const geoResults = rollUpTownResultsByGeoType(censusResults, map);
      // console.log(JSON.stringify(geoResults, null, 2));
      censusResultsToTable(geoResults, dBVariables, columns, rows, queryVars);
    }

    const censusStateResults = await census({
      vintage: year,
      geoHierarchy: {
        state: "50"
      },
      sourcePath,
      values: queryVars,
    });
    censusResultsToTable(censusStateResults, dBVariables, Object.keys(columns).length == 1 ? columns : undefined, rows, queryVars);

    // console.log('COUNTIES', counties);
    console.log('event 👉', event);
    return {
      body: JSON.stringify({
        metadata: {
          table,
          geoType,
          year,
          geo,
          sourcePath,
          variables
        },
        columns: columns,
        rows: rows
      }),
      headers: getHeaders("application/json"),
      statusCode: 200,
    };

  } catch (e) {
    console.error(e);
    return {
      body: JSON.stringify({
        message: (e as Error).message
      }),
      headers: getHeaders("application/json"),
      statusCode: 500,
    };
  }
}

export async function codesCensusVariablesByTable(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('starting main function');
  const pathParameters = event.pathParameters || {};
  const table = pathParameters.table!;

  // Get census variables
  const acsVars: AcsVariable[] = await queryDB('select * from acs_variables where `group`=? order by variable', [table.toUpperCase()]);

  if (acsVars == null || acsVars.length === 0) {
    return {
      body: JSON.stringify({
        message: "unknown table"
      }),
      headers: getHeaders("application/json"),
      statusCode: 400,
    };
  } else {
    return {
      body: JSON.stringify({
        metadata: {
          tableType: acsVars[0].tableType || undefined
        },
        variables: acsVars.map(acsVar => {
          return {
            variable: acsVar.variable,
            concept: acsVar.concept,
            label: acsVar.label
          };
        })
      }),
      headers: getHeaders("application/json"),
      statusCode: 200,
    };
  }
}

export async function getCensusTablesSearch(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('starting main function');
  const queryStringParameters = event.queryStringParameters || {};
  const concept = queryStringParameters.concept;

  const conds: string[] = [];
  const params: any[] = [];
  if (concept != null) {
    conds.push("concept like ?");
    params.push(`%${concept}%`);
  }

  if (conds.length === 0) {
    return {
      body: JSON.stringify({ message: 'Need at least one search condition', }),
      headers: getHeaders("application/json"),
      statusCode: 400,
    };
  }

  const vars: AcsVariable[] = await queryDB(`SELECT distinct concept, \`group\` FROM acs_variables where ${conds.join(' and ')}`, params);
  return {
    body: JSON.stringify({
      tables: vars.map(t => {
        return {
          table: t.group,
          concept: t.concept
        }
      })
    }),
    headers: getHeaders("application/json"),
    statusCode: 200,
  };
}

export async function getGeosByType(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2<GetGeosByTypeResponse>> {
  console.log('starting main function');
  const pathParameters = event.pathParameters || {};
  const geoType = pathParameters.geoType!;

  if (!['county'].includes(geoType)) {
    return {
      body: JSON.stringify({
        message: 'Only supports county right now',
      }),
      headers: getHeaders("application/json"),
      statusCode: 400,
    };
  }

  const geos: { id: string, name: string }[] = []
  if (geoType === 'county') {
    const dbCounties: GazCounty[] = await queryDB(`select * from gaz_counties where usps='VT' and geoid != '50'`);
    dbCounties.forEach((cty) => {
      if (cty.GEOID.length === 5) {
        geos.push({ id: cty.GEOID.substring(2), name: cty.NAME });
      }
    });
  }

  // console.log('body', JSON.stringify(geos, null, 2));
  return {
    statusCode: 200,
    headers: getHeaders("application/json"),
    body: JSON.stringify({ geos })
  };
}

// Only run if executed directly
if (!module.parent) {
  (async () => {
    /*
    const ret = await getCensusByGeo({
      pathParameters: {
        table: 'S1701',
        geoType: 'head_start'
      }, queryStringParameters: {
        variables: 'S1701_C01_044E,S1601_C01_001E,S1601_C01_002E'
      }
    } as unknown as APIGatewayProxyEventV2);
    console.log('S1701 -- unknown vars', ret);
 
    // console.log(await getGeosByType({ pathParameters: { geoType: 'county' } } as unknown as APIGatewayProxyEventV2));
    console.log(await getGeosByType({ pathParameters: { geoType: 'state' } } as unknown as APIGatewayProxyEventV2));
    console.log(await getCensusTablesSearch({ queryStringParameters: { concept: 'poverty' } } as unknown as APIGatewayProxyEventV2));
    console.log(await getCensusTablesSearch({ queryStringParameters: { concept: 'occupation' } } as unknown as APIGatewayProxyEventV2));
    console.log(await getCensusTablesSearch({} as unknown as APIGatewayProxyEventV2));
    console.log('one county', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'county'
      }, queryStringParameters: {
        geo: '003'
      }
    } as unknown as APIGatewayProxyEventV2));
    console.log('all counties', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'county'
      }, queryStringParameters: {}
    } as unknown as APIGatewayProxyEventV2));
    console.log('just state', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'state'
      }, queryStringParameters: {}
    } as unknown as APIGatewayProxyEventV2));
    console.log('HS ', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'head_start'
      }, queryStringParameters: {}
    } as unknown as APIGatewayProxyEventV2));
    console.log('B09001 vars', await codesCensusVariablesByTable({ pathParameters: { table: 'B09001' } } as unknown as APIGatewayProxyEventV2));
    console.log('S1701 vars', await codesCensusVariablesByTable({ pathParameters: { table: 'S1701' } } as unknown as APIGatewayProxyEventV2));
    console.log(await codesCensusVariablesByTable({ pathParameters: { table: 'BOGUS' } } as unknown as APIGatewayProxyEventV2));
    console.log('HS region', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'head_start'
      }, queryStringParameters: {}
    } as unknown as APIGatewayProxyEventV2));
    console.log('HS region, only two vars', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'head_start'
      }, queryStringParameters: {
        variables: 'B09001_001E,B09001_002E'
      }
    } as unknown as APIGatewayProxyEventV2));
    console.log('HS region, 2018', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'head_start'
      }, queryStringParameters: {
        year: '2018'
      }
    } as unknown as APIGatewayProxyEventV2));
    // console.log('HS region, invalid year', await getCensusByGeo({
    //   pathParameters: {
    //     table: 'B09001',
    //     geoType: 'head_start'
    //   }, queryStringParameters: {
    //     year: '1776'
    //   }
    // } as unknown as APIGatewayProxyEventV2));
    console.log('HS region, valid year for acs3', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'head_start'
      }, queryStringParameters: {
        year: '2013',
        dataset: 'acs/acs3'
      }
    } as unknown as APIGatewayProxyEventV2));
    console.log('HS region, invalid year for acs3', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'head_start'
      }, queryStringParameters: {
        year: '2020',
        dataset: 'acs/acs3'
      }
    } as unknown as APIGatewayProxyEventV2));
    // console.log('HS region, valid year for acs1, only two variables', await getCensusByGeo({
    //   pathParameters: {
    //     table: 'B09001',
    //     geoType: 'head_start'
    //   }, queryStringParameters: {
    //     year: '2005',
    //     dataset: 'acs/acs1',
    //     variables: 'B09001_002E,B09001_001E'
    //   }
    // } as unknown as APIGatewayProxyEventV2));
    console.log('Unknown table', await getCensusByGeo({
      pathParameters: {
        table: 'BOGUS',
        geoType: 'head_start'
      }, queryStringParameters: {
      }
    } as unknown as APIGatewayProxyEventV2));
    console.log('S1601 -- too many variables', await getCensusByGeo({
      pathParameters: {
        table: 'S1601',
        geoType: 'head_start'
      }, queryStringParameters: {
      }
    } as unknown as APIGatewayProxyEventV2));
    console.log('S1601 -- OK', await getCensusByGeo({
      pathParameters: {
        table: 'S1601',
        geoType: 'head_start'
      }, queryStringParameters: {
        variables: 'S1601_C01_001E,S1601_C01_002E,S1601_C01_003E,S1601_C01_004E'
      }
    } as unknown as APIGatewayProxyEventV2));
    console.log('S1701 -- OK', await getCensusByGeo({
      pathParameters: {
        table: 'S1701',
        geoType: 'head_start'
      }, queryStringParameters: {
        variables: 'S1701_C01_044E,S1701_C01_047E'
      }
    } as unknown as APIGatewayProxyEventV2));
    console.log('BBF region', await getCensusByGeo({
      pathParameters: {
        table: 'B09001',
        geoType: 'bbf_region'
      }, queryStringParameters: {}
    } as unknown as APIGatewayProxyEventV2));
    */
    // console.log('MOEs', await getCensusByGeo({
    //   pathParameters: {
    //     table: 'S1701',
    //     geoType: 'head_start'
    //   }, queryStringParameters: {
    //     variables: 'S1701_C01_044E',
    //     extensions: 'moe'
    //   }
    // } as unknown as APIGatewayProxyEventV2));
    // console.log('AHS district', await getCensusByGeo({
    //   pathParameters: {
    //     table: 'B09001',
    //     geoType: 'ahs_district'
    //   }, queryStringParameters: {}
    // } as unknown as APIGatewayProxyEventV2));
    // await queryDB(`select gaz_county_subdivision, geography_map_geoid from gaz_geography_map where geography_map_type='head_start'`);
    // console.log('raw', await census({
    //   vintage: 2020,
    //   geoHierarchy: {
    //     state: '50',
    //     county: '*'
    //   },
    //   sourcePath: ['acs', 'acs5', 'subject'],
    //   values: ['S1601_C05_014E'],
    // }));
    console.log(await table({
      pathParameters: {
        queryId: '58'
      }
    } as unknown as APIGatewayProxyEventV2));

  })().catch(err => {
    console.log(`exception`, err);
  });
} else {
  console.log("we're NOT in the local deploy, probably in Lambda");
}
