import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';
import { census, CensusResultRow, GeoHierarchy } from './citysdk-utils';
import * as mysql from 'mysql';
import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";
import { queryDB } from './db-utils';
import { getHeaders } from './cors';

const { REGION } = process.env;
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


async function doOpen(): Promise<mysql.Connection> {
  const smClient = new SecretsManagerClient({ region: REGION });

  // Get secret connection info
  const secrets = (await smClient.send(new GetSecretValueCommand({
    SecretId: 'vkd/prod/dbcreds'
  }))).SecretString;

  if (secrets == null) {
    throw new Error('DB connection info not found');
  } else {
    const info: { host: string, username: string, password: string } = JSON.parse(secrets);
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

interface ColumnMap {
  [key: string]: string
}

interface QueryRow {
  id: number,
  name: string,
  sqlText: string,
  columnMap?: string
};

async function getQuery(queryId: string): Promise<{ connection: mysql.Connection, rows: QueryRow[] }> {
  console.log('opening connection');
  const connection = await doOpen();
  console.log('connection open');
  await query(connection, 'use dbvkd');

  // Get the query to run from the parameters
  const queryRows = await query(connection, 'SELECT sqlText, columnMap FROM queries where name=?', [queryId]);
  console.log(queryRows);
  if (queryRows.length == 0) {
    throw new Error('unknown query');
  } else {
    return {
      connection: connection,
      rows: queryRows
    }
  }
}

async function doQuery(queryId: string): Promise<{ rows: any[], columnMap?: ColumnMap }> {
  const info = await getQuery(queryId);

  // Now run the query. Should always return three columns, with the following names
  // - cat: The category(s)
  // - label: The label for the values
  // - value: The value for the values
  const resultRows = await query(info.connection, info.rows[0].sqlText);
  console.log('result', resultRows);

  console.log('closing connection');
  info.connection.end();
  console.log('connection closed');
  console.log('row0', info.rows[0])
  const columnMap = info.rows[0].columnMap != null ? JSON.parse(info.rows[0].columnMap) : undefined;
  return { rows: resultRows, columnMap: columnMap };
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
    try {

      // We assume we're getting back an array of values with the value keys being the key into the columnMap
      // columnMap => {'infant': 'Infant', 'toddler': 'Toddler', 'preschool': 'Preschool'}
      const resultRows = await doQuery(queryId);

      // Example results:
      // Table:
      // const foo = {
      //   columns: [
      //     { id: 'type', label: 'Type' },
      //     { id: 'infant', label: 'Infant' },
      //     { id: 'toddler', label: 'Toddler' },
      //     { id: 'preschool', label: 'Preschool' }
      //   ],
      //   rows: [
      //     [ 'center',	1942,	1666,	8564 ],
      //     [ 'licensed',	45, 49, 136 ],
      //     [ 'registered', 537, 541, 1039 ]
      //   ]
      // }
      // Bar chart:
      // const foo = {
      //   "id": "58",
      //   "series": [
      //       { "name": "Infant", "data": [ 2935, 3066, 2524 ] },
      //       { "name": "Toddler", "data": [ 2597, 2699, 2256 ] },
      //       { "name": "Preschool", "data": [ 12290, 12185, 9739 ] },
      //   ],
      //   "categories": [
      //       '2018-2019', '2019-2020', '2020-2021'
      //   ]
      // }

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
        console.log(`row`, row);
        if (i === 0) {
          // Build up the columns
          const keys = Object.keys(row);
          console.log('keys', keys, 'cmap', resultRows.columnMap);
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
        }

        // All rows, return the data
        const rowval: { [key: string]: any } = {};
        Object.values(columns).forEach(col => {
          rowval[col.id] = row[col.id];
        });
        rows.push(rowval);
      }
      const body = {
        id: queryId,
        columns,
        rows
      };
      console.log('body', JSON.stringify(body, null, 2));
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
  year: number // 2016
}

interface ApiTableResultColumn { id: string, label: string }
interface ApiTableResultRow { [key: string]: any }

function censusResultsToTable(censusResults: CensusResultRow, acsVars: AcsVariable[], columns: ApiTableResultColumn[] | undefined, rows: ApiTableResultRow[]): void {
  if (columns != null) {
    acsVars.forEach(acsVar => {
      columns.push({ id: acsVar.variable, label: acsVar.label });
    });
  }

  censusResults.forEach((censusResult: { [key: string]: any }) => {
    const row: { [key: string]: any } = {};
    row.geo = censusResult.state + (censusResult.county || '');
    acsVars.forEach(acsVar => {
      row[acsVar.variable] = censusResult[acsVar.variable];
    });
    rows.push(row);
  });
}

export async function getCensusByGeo(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('starting main function');
  const pathParameters = event.pathParameters || {};
  const table = pathParameters.table!;
  const geoType = pathParameters.geoType!;

  const queryStringParameters = event.queryStringParameters || {};
  const year = queryStringParameters?.year || '2020';
  const geo = queryStringParameters?.geo || '*';

  if (!['county', 'state'].includes(geoType)) {
    return {
      body: JSON.stringify({
        message: 'Only supports county right now',
      }),
      headers: getHeaders("application/json"),
      statusCode: 400,
    };
  }

  // Get census variables
  console.log('before query');
  const acsVars: AcsVariable[] = await queryDB(`select * from dbvkd.acs_variables where variable like '${table}%' order by variable`);
  console.log('after query');
  const queryVars: string[] = [];
  acsVars.forEach(acsVar => {
    queryVars.push(acsVar.variable);
  });

  const columns: ApiTableResultColumn[] = [{ id: 'geo', label: 'Geography' }];
  const rows: ApiTableResultRow[] = [];

  if (geoType === 'county') {
    // Town:
    // {
    //   "county subdivision": '*',
    // }
    const geoHierarchy: GeoHierarchy = {
      state: "50"
    };
    if (geo) {
      geoHierarchy.county = geo;
    }

    const censusResults = await census({
      vintage: year,
      geoHierarchy: geoHierarchy,
      sourcePath: ['acs', 'acs5'],
      values: queryVars,
    });

    censusResultsToTable(censusResults, acsVars, columns, rows);
  }

  const censusStateResults = await census({
    vintage: year,
    geoHierarchy: {
      state: "50"
    },
    sourcePath: ['acs', 'acs5'],
    values: queryVars,
  });
  censusResultsToTable(censusStateResults, acsVars, Object.keys(columns).length == 1 ? columns : undefined, rows);

  // Now convert the geos to names
  const dbCounties: GazCounty[] = await queryDB(`select * from dbvkd.gaz_counties where usps='VT'`);
  const counties: { [id: string]: GazCounty } = {}
  dbCounties.forEach((cty) => {
    counties[cty.GEOID] = cty;
  });

  rows.forEach(row => {
    if (counties[row.geo] != null) {
      row.geo = counties[row.geo].NAME;
    }
  });

  // console.log('COUNTIES', counties);
  console.log('event 👉', event);

  return {
    body: JSON.stringify({
      // results: censusResults,
      columns: columns,
      rows: rows
    }),
    headers: getHeaders("application/json"),
    statusCode: 200,
  };
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

  const vars: AcsVariable[] = await queryDB(`SELECT distinct concept, \`group\` FROM dbvkd.acs_variables where ${conds.join(' and ')}`, params);
  return {
    body: JSON.stringify({ tables: vars.map(t => {
      return {
        table: t.group,
        concept: t.concept
      }
    }) }),
    headers: getHeaders("application/json"),
    statusCode: 200,
  };
}

export async function getGeosByType(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
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
    const dbCounties: GazCounty[] = await queryDB(`select * from dbvkd.gaz_counties where usps='VT' and geoid != '50'`);
    dbCounties.forEach((cty) => {
      if (cty.GEOID.length === 5) {
        geos.push({ id: cty.GEOID.substring(2), name: cty.NAME });
      }
    });
  }

  console.log('body', JSON.stringify(geos, null, 2));
  return {
    statusCode: 200,
    headers: getHeaders("application/json"),
    body: JSON.stringify({geos})
  };
}

(async() => {
  // console.log(await getGeosByType({ pathParameters: {geoType: 'county'} } as unknown as APIGatewayProxyEventV2));
  // console.log(await getGeosByType({ pathParameters: {geoType: 'state'} } as unknown as APIGatewayProxyEventV2));
  console.log(await getCensusTablesSearch({ queryStringParameters: { concept: 'poverty' }} as unknown as APIGatewayProxyEventV2));
  console.log(await getCensusTablesSearch({ queryStringParameters: { concept: 'occupation' }} as unknown as APIGatewayProxyEventV2));
  console.log(await getCensusTablesSearch({ } as unknown as APIGatewayProxyEventV2));
})();
// const event: APIGatewayProxyEventV2 = {
//   pathParameters: { 
//     queryId: '58'
//   }
// } as unknown as APIGatewayProxyEventV2;
// await table(event);
// Only run if executed directly
// if (!module.parent) {
//   (async () => {
//     try {
//       console.log('one county', await getCensusByGeo({
//         pathParameters: {
//           table: 'B09001',
//           geoType: 'county'
//         }, queryStringParameters: {
//           geo: '003'
//         }
//       } as unknown as APIGatewayProxyEventV2));
//       console.log('all counties', await getCensusByGeo({
//         pathParameters: {
//           table: 'B09001',
//           geoType: 'county'
//         }, queryStringParameters: {}
//       } as unknown as APIGatewayProxyEventV2));
//       console.log('just state', await getCensusByGeo({
//         pathParameters: {
//           table: 'B09001',
//           geoType: 'state'
//         }, queryStringParameters: {}
//       } as unknown as APIGatewayProxyEventV2));
//     } catch (e) {
//       console.error(e);
//     }
//   })();
// }
