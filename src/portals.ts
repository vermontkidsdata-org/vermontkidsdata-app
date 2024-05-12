import { Logger, injectLambdaContext } from "@aws-lambda-powertools/logger";
import { LogLevel } from "@aws-lambda-powertools/logger/lib/types";
import { Tracer, captureLambdaHandler } from "@aws-lambda-powertools/tracer";
import middy from "@middy/core";
import cors from "@middy/http-cors";
import { APIGatewayEvent, APIGatewayProxyResultV2 } from "aws-lambda";
import { doDBClose, doDBCommit, doDBInsert, doDBOpen, doDBQuery } from "./db-utils";

import { CORSConfigDefault } from "./cors-config";

// Set your service name. This comes out in service lens etc.
const { LOG_LEVEL, NAMESPACE } = process.env;
const serviceName = `charts-api-${NAMESPACE}`;
export const loggerCharts = new Logger({
  logLevel: (LOG_LEVEL || 'INFO') as LogLevel,
  serviceName,
});
export const tracerCharts = new Tracer({ serviceName });

function prepare(fn: (event: APIGatewayEvent) => Promise<APIGatewayProxyResultV2>) {
  // return fn;
  return middy(fn)
    .use(captureLambdaHandler(tracerCharts))
    .use(injectLambdaContext(loggerCharts))
    .use(
      cors(CORSConfigDefault),
    )
}

/* 
 * GET /
 */
export const portalsGetList = prepare(async () => {
  await doDBOpen();

  // get the topics
  const sql = 'select * from portals';
  // const [rows, fields] = await connection.execute(sql);
  const rows = await doDBQuery(sql);
  console.log('PORTALS', rows);

  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/**
  * GET /:id
  */
export const portalsGetById = prepare(async (event: APIGatewayEvent) => {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing ID" }),
    }
  }

  await doDBOpen();

  // get the topics
  const sql = `select * from portals where id = ${id}`;
  const rows = await doDBQuery(sql);

  console.log('PORTAL', rows);

  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

// router.post('/addelement/:elttype/:eltval/:eltparent', async function (req, res, next) {
export const portalsPostAddElement = prepare(async (event: APIGatewayEvent) => {
  const id = event.pathParameters?.id;
  const parent = event.pathParameters?.eltparent;
  const elttype = event.pathParameters?.elttype;
  const eltval = event.pathParameters?.eltval;

  if (parent == null || elttype == null || eltval == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  // get the topics
  const idElts = parent.split('_');
  const portal = idElts[0].replace('p', '');
  let topic: string | undefined;
  let category: string | undefined;
  //let subcategory: string | undefined;
  let sql = ``;
  //const [rows, fields] = await connection.execute(sql);

  console.log('PORTAL', portal);
  console.log('ELT TYPE', elttype);
  console.log('ELT VAL', eltval);

  if (elttype === 'category' || elttype === 'subcategory') {
    topic = idElts[1].replace('t', '');
    console.log('TOPIC', topic);
  }
  if (elttype === 'subcategory') {
    category = idElts[2].replace('c', '');
    console.log('CATEGORY', category);
  }

  if (elttype === 'topic') {
    sql = `insert into portal_topics (name, portal_id) values ('${eltval}', ${portal}); `
    console.log(sql);
    const createdId = await doDBInsert(sql);
    await doDBCommit();

    console.log(createdId);
  }

  if (elttype === 'category') {
    sql = `insert into portal_categories (name,portal) values ('${eltval}', ${portal}); `
    console.log(sql);
    const createdId = await doDBInsert(sql);
    console.log(createdId);

    //create the mapping
    sql = `insert into portal_category_topic_map (topic, category, portal) values (${topic},${createdId}, ${portal}); `
    console.log(sql);
    await doDBInsert(sql);
  }

  if (elttype === 'subcategory') {
    sql = `insert into portal_subcategories (name, portal) values ('${eltval}', ${portal}); `
    console.log(sql);
    const createdId = await doDBInsert(sql);
    console.log(createdId);
    //create the mapping

    sql = `insert into portal_subcategory_category_map (topic, category, subcategory, portal) values (${topic},${category}, ${createdId}, ${portal}); `
    console.log(sql);
    await doDBInsert(sql);
  }

  await doDBClose();

  return {
    statusCode: 201,
    body: JSON.stringify('created element'),
  }
});

// router.post('/addmapping/:elttype/:eltid/:eltparent', async function (req, res, next) {
export const portalsPostAddMapping = prepare(async (event: APIGatewayEvent) => {
  const parent = event.pathParameters?.eltparent;
  const elttype = event.pathParameters?.elttype;
  const eltId = event.pathParameters?.eltid;
  if (parent == null || elttype == null || eltId == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  // get the topics
  const idElts = parent.split('_');
  const portal = idElts[0].replace('p', '');
  let topic: string | undefined;
  let category: string | undefined;
  //let subcategory: string | undefined;
  let sql = ``;
  //const [rows, fields] = await connection.execute(sql);

  console.log('PORTAL', portal);
  console.log('ELT TYPE', elttype);
  console.log('ELT ID', eltId);

  if (elttype === 'category' || elttype === 'subcategory') {
    topic = idElts[1].replace('t', '');
    console.log('TOPIC', topic);
  }
  if (elttype === 'subcategory') {
    category = idElts[2].replace('c', '');
    console.log('CATEGORY', category);
  }

  if (elttype === 'category') {
    //create the mapping
    sql = `insert into portal_category_topic_map (topic, category, portal) values (${topic},${eltId}, ${portal}); `
    console.log(sql);
    const createdId = await doDBInsert(sql);
    console.log({ createdId });
  }

  if (elttype === 'subcategory') {
    //create the mapping
    sql = `insert into portal_subcategory_category_map (topic, category, subcategory, portal) values (${topic},${category}, ${eltId}, ${portal}); `
    console.log(sql);
    const createdId = await doDBInsert(sql);
    console.log({ createdId });
  }

  await doDBClose();

  return {
    statusCode: 201,
    body: JSON.stringify('created mapping'),
  }
});

// router.post('/addindicator', async function (req, res, next) {
export const portalsPostAddIndicator = prepare(async (event: APIGatewayEvent) => {
  const body = JSON.parse(event.body || '{}');
  const parent = body.eltparent;
  const elttype = body.elttype;
  const eltval = body.eltval;
  const elturl = body.elturl;
  const eltlink = body.eltlink;

  if (parent == null || elttype == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  // get the topics
  //let eltindicator = event.pathParameters?.eltindicator;
  const idElts = parent.split('_');
  const portal = idElts[0].replace('p', '');
  let topic = -1;
  let category = -1;
  let subcategory = -1;
  let sql = ``;
  //const [rows, fields] = await connection.execute(sql);

  console.log('PORTAL', portal);
  console.log('ELT TYPE', elttype);
  console.log('ELT VAL', eltval);
  console.log('ELT URL', elturl);
  console.log('ELT LINK', eltlink);

  if (elttype === 'category' || elttype === 'subcategory' || elttype === 'indicator') {
    topic = idElts[1].replace('t', '');
    console.log('TOPIC', topic);
  }

  if (elttype === 'subcategory') {
    category = idElts[2].replace('c', '');
    console.log('CATEGORY', category);
  }

  if (elttype === 'indicator') {
    subcategory = idElts[3].replace('s', '');
    category = idElts[2].replace('c', '');
    console.log('SUB CATEGORY', subcategory);
  }

  try {
    sql = `insert into portal_indicators (chart_url, link, title, portal) values ('${elturl}','${eltlink}','${eltval}', ${portal}); `
    const createdId = await doDBInsert(sql);
    console.log({ createdId });

    //add the mapping
    sql = `insert into portal_indicator_map (portal, topic, category, subcategory, indicator) values (${portal},${topic},${category},${subcategory},${createdId}); `
    await doDBInsert(sql);
  } catch (e) {
    console.log((e as Error).message);
  }

  await doDBClose();

  return {
    statusCode: 201,
    body: JSON.stringify('created indicator'),
  }

});

// router.post('/addindicatormapping', async function (req, res, next) {
export const portalsPostAddIndicatorMapping = prepare(async (event: APIGatewayEvent) => {
  const body = JSON.parse(event.body || '{}');
  const parent = body.eltparent;
  const elttype = body.elttype;
  const eltid = body.eltid;
  if (parent == null || elttype == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  // get the topics
  const idElts = parent.split('_');
  const portal = idElts[0].replace('p', '');
  let topic = -1;
  let category = -1;
  let subcategory = -1;
  let sql = ``;
  //const [rows, fields] = await connection.execute(sql);

  console.log('PORTAL', portal);
  console.log('ELT TYPE', elttype);
  console.log('ELT INDICATOR', eltid);

  if (elttype === 'category' || elttype === 'subcategory' || elttype === 'indicator') {
    topic = idElts[1].replace('t', '');
    console.log('TOPIC', topic);
  }

  if (elttype === 'subcategory') {
    category = idElts[2].replace('c', '');
    console.log('CATEGORY', category);
  }

  if (elttype === 'indicator') {
    subcategory = idElts[3].replace('s', '');
    category = idElts[2].replace('c', '');
    console.log('SUB CATEGORY', subcategory);
  }

  try {
    //add the mapping
    sql = `insert into portal_indicator_map (portal, topic, category, subcategory, indicator) values (${portal},${topic},${category},${subcategory},${eltid}); `
    const createdId = await doDBInsert(sql);
    console.log({ createdId });
  } catch (e) {
    console.log((e as Error).message);
  }

  await doDBClose();

  return {
    statusCode: 201,
    body: JSON.stringify('created indicator mapping'),
  }
});

// router.post('/deleteelement', async function (req, res, next) {
export const portalsPostDeleteElement = prepare(async (event: APIGatewayEvent) => {
  const body = JSON.parse(event.body || '{}');
  console.log(body);
  const eltid = body.eltid;
  const eltval = body.eltval;
  const elttype = body.elttype;
  if (elttype == null || eltid == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  const idElts = eltid.split('_');

  console.log(eltid);
  console.log(elttype);
  console.log(eltval);


  //let subcategory = -1;
  let sql = ``;
  //const [rows, fields] = await connection.execute(sql);



  if (elttype === 't') {
    sql = `delete from portal_topics  where id_topic = ${idElts[1].replace('t', '')} `;
  }

  if (elttype === 'c') {
    sql = `delete from  portal_categories  where id_category = ${idElts[2].replace('c', '')} `;
  }

  if (elttype === 's') {
    sql = `delete from  portal_subcategories  where id_subcategory = ${idElts[3].replace('s', '')} `;
  }
  if (elttype === 'i') {
    sql = `delete from  portal_indicators  where id = ${idElts[4].replace('i', '')} `;
  }

  await doDBQuery(sql);

  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify('element deleted'),
  }
});

// router.post('/editelement', async function (req, res, next) {
export const portalsPostEditElement = prepare(async (event: APIGatewayEvent) => {
  const body = JSON.parse(event.body || '{}');
  console.log(body);

  const eltid = body.eltid;
  const eltval = body.eltval;
  const elttype = body.elttype;
  if (elttype == null || eltid == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  const idElts = eltid.split('_');

  console.log(eltid);
  console.log(elttype);
  console.log(eltval);


  //let subcategory = -1;
  let sql = ``;
  //const [rows, fields] = await connection.execute(sql);



  if (elttype === 't') {
    sql = `update portal_topics set name='${eltval}' where id_topic = ${idElts[1].replace('t', '')} `;
  }

  if (elttype === 'c') {
    sql = `update portal_categories set name='${eltval}' where id_category = ${idElts[2].replace('c', '')} `;
  }

  if (elttype === 's') {
    sql = `update portal_subcategories set name='${eltval}' where id_subcategory = ${idElts[3].replace('s', '')} `;
  }
  if (elttype === 'i') {
    sql = `update portal_indicators set title='${eltval}' where id = ${idElts[4].replace('i', '')} `;
  }

  await doDBQuery(sql);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify('element updated'),
  }
});

/* GET an individual element by ID */
// router.get('/element/:elt/:id', async function (req, res, next) {
export const portalsGetElementById = prepare(async (event: APIGatewayEvent) => {
  const id = event.pathParameters?.id;
  const elt = event.pathParameters?.elt;
  if (elt == null || id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  // get the topics
  //res.json(elt);
  let sql = ``;
  if (elt === 'p') {
    sql = `select * from portals where id = ${id}`;
  } else if (elt === 't') {
    sql = `select * from portal_topics where id_topic = ${id}`;
  } else if (elt === 'c') {
    sql = `select * from portal_categories where id_category = ${id}`
  } else if (elt === 's') {
    sql = `select * from portal_subcategories where id_subcategory = ${id}`;
  } else {
    sql = `select * from portal_indicators where id = ${id}`;
  }
  console.log(sql);
  const rows = await doDBQuery(sql);
  await doDBClose();

  console.log('TOPICS', rows);

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/* GET topics */
// router.get('/topics/:id', async function (req, res, next) {
export const portalsGetTopics = prepare(async (event: APIGatewayEvent) => {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  // get the topics
  const sql = `select * from portal_topics where portal_id = ${id}`;
  const rows = await doDBQuery(sql);
  await doDBClose();

  console.log('TOPICS', rows);

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/* GET categories */
// router.get('/categories/:id', async function (req, res, next) {
export const portalsGetCategories = prepare(async (event: APIGatewayEvent) => {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  //get the categories
  const sql = `select id, topic, id_category, name from portal_category_topic_map m 
join portal_categories pc on pc.id_category = m.category
where m.portal = ${id}`;
  const rows = await doDBQuery(sql);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/* GET subcategories */
// router.get('/subcategories/:id', async function (req, res, next) {
export const portalsGetSubCategories = prepare(async (event: APIGatewayEvent) => {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  //get the categories
  const sql = `select id, topic, category, id_subcategory, name from portal_subcategory_category_map m 
  join portal_subcategories sc on sc.id_subcategory = m.subcategory
  where m.portal = ${id}`;
  const rows = await doDBQuery(sql);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/* GET indicators */
// router.get('/indicators/:id', async function (req, res, next) {
export const portalsGetIndicators = prepare(async (event: APIGatewayEvent) => {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  //get the categories
  const sql = `SELECT * FROM portal_indicator_map m
  join portal_indicators i on i.id = m.indicator
  where m.portal = ${id} order by i.title`;
  const rows = await doDBQuery(sql);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});
