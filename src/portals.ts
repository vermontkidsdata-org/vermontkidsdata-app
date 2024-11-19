import { APIGatewayProxyEventV2 } from "aws-lambda";
import { doDBClose, doDBCommit, doDBInsert, doDBOpen, doDBQuery } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";

makePowerTools({ prefix: 'portals' });

/* 
 * GET /
 */
export const portalsGetList = prepareAPIGateway(async () => {
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
export const portalsGetById = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing ID" }),
    }
  }

  await doDBOpen();

  // get the topics
  const sql = `select * from portals where id = ?`;
  const rows = await doDBQuery(sql, [id]);

  console.log('PORTAL', rows);

  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

interface AddElementParams {
  type: string;
  val: string;
  parent: string;
}

// router.post('/addelement/:elttype/:eltval/:eltparent', async function (req, res, next) {
// path params now moved to the body as JSON (AddElementParams)
export const portalsPostAddElement = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  const body = JSON.parse(event.body || '{}') as AddElementParams;
  const { type: elttype, val: eltval, parent } = body;

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
    sql = `insert into portal_topics (name, portal_id) values (?, ?)`
    console.log(sql);
    const createdId = await doDBInsert(sql, [eltval, portal]);
    await doDBCommit();

    console.log(createdId);
  }

  if (elttype === 'category') {
    sql = `insert into portal_categories (name,portal) values (?, ?); `
    console.log(sql);
    const createdId = await doDBInsert(sql, [eltval, portal]);
    console.log(createdId);

    //create the mapping
    sql = `insert into portal_category_topic_map (topic, category, portal) values (?, ?, ?); `
    console.log(sql);
    await doDBInsert(sql, [topic, createdId, portal]);
  }

  if (elttype === 'subcategory') {
    sql = `insert into portal_subcategories (name, portal) values (?, ?); `
    console.log(sql);
    const createdId = await doDBInsert(sql, [eltval, portal]);
    console.log(createdId);
    //create the mapping

    sql = `insert into portal_subcategory_category_map (topic, category, subcategory, portal) values (?, ?, ?, ?); `
    console.log(sql);
    await doDBInsert(sql, [topic, category, createdId, portal]);
  }

  await doDBClose();

  return {
    statusCode: 201,
    body: JSON.stringify('created element'),
  }
});

interface AddMappingParams {
  type: string;
  id: string;
  parent: string;
}

// router.post('/addmapping/:elttype/:eltid/:eltparent', async function (req, res, next) {
export const portalsPostAddMapping = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  const body = JSON.parse(event.body || '{}') as AddMappingParams;
  const { type: elttype, id: eltId, parent } = body;

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
    sql = `insert into portal_category_topic_map (topic, category, portal) values (?, ?, ?); `
    console.log(sql);
    const createdId = await doDBInsert(sql, [topic, eltId, portal]);
    console.log({ createdId });
  }

  if (elttype === 'subcategory') {
    //create the mapping
    sql = `insert into portal_subcategory_category_map (topic, category, subcategory, portal) values (?, ?, ?, ?); `
    console.log(sql);
    const createdId = await doDBInsert(sql, [topic, category, eltId, portal]);
    console.log({ createdId });
  }

  await doDBClose();

  return {
    statusCode: 201,
    body: JSON.stringify('created mapping'),
  }
});

// router.post('/addindicator', async function (req, res, next) {
export const portalsPostAddIndicator = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  const body = JSON.parse(event.body || '{}');

  // { 
  //   "elttype": "indicator", 
  //   "eltval": "STARS TEST",
  //   "elturl": "/columnchart/stars_test:chart", 
  //   "eltlink": "https://www.test.com",
  //   "eltparent": "p2_t1_c1_s24"
  // }
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
    sql = `insert into portal_indicators (chart_url, link, title, portal) values (?, ?, ?, ?); `
    const createdId = await doDBInsert(sql, [elturl, eltlink, eltval, portal]);
    console.log({ createdId });

    //add the mapping
    sql = `insert into portal_indicator_map (portal, topic, category, subcategory, indicator) values (?, ?, ?, ?, ?); `
    await doDBInsert(sql, [portal, topic, category, subcategory, createdId]);
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
export const portalsPostAddIndicatorMapping = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
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
    sql = `insert into portal_indicator_map (portal, topic, category, subcategory, indicator) values (?, ?, ?, ?, ?); `
    const createdId = await doDBInsert(sql, [portal, topic, category, subcategory, eltid]);
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
export const portalsPostDeleteElement = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
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


  const params: string[] = [];

  if (elttype === 't') {
    sql = `delete from portal_topics  where id_topic = ?`;
    params.push(idElts[1].replace('t', ''));
  }

  if (elttype === 'c') {
    sql = `delete from  portal_categories  where id_category = ? `;
    params.push(idElts[2].replace('c', ''));
  }

  if (elttype === 's') {
    sql = `delete from  portal_subcategories  where id_subcategory = ? `;
    params.push(idElts[3].replace('s', ''));
  }
  if (elttype === 'i') {
    sql = `delete from  portal_indicators  where id = ? `;
    params.push(idElts[4].replace('i', ''));
  }

  await doDBQuery(sql, params);

  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify('element deleted'),
  }
});

// router.post('/editelement', async function (req, res, next) {
export const portalsPostEditElement = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
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


  const params: string[] = [];
  if (elttype === 't') {
    sql = `update portal_topics set name=? where id_topic = ? `;
    params.push(eltval);
    params.push(idElts[1].replace('t', ''));
  }

  if (elttype === 'c') {
    sql = `update portal_categories set name=? where id_category = ? `;
    params.push(eltval);
    params.push(idElts[2].replace('c', ''));
  }

  if (elttype === 's') {
    sql = `update portal_subcategories set name=? where id_subcategory = ? `;
    params.push(eltval);
    params.push(idElts[3].replace('s', ''));
  }
  if (elttype === 'i') {
    sql = `update portal_indicators set title=? where id = ? `;
    params.push(eltval);
    params.push(idElts[4].replace('i', ''));
  }

  await doDBQuery(sql, params);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify('element updated'),
  }
});

/* GET an individual element by ID */
// router.get('/element/:elt/:id', async function (req, res, next) {
export const portalsGetElementById = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
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
    sql = `select * from portals where id = ?`;
  } else if (elt === 't') {
    sql = `select * from portal_topics where id_topic = ?`;
  } else if (elt === 'c') {
    sql = `select * from portal_categories where id_category = ?`
  } else if (elt === 's') {
    sql = `select * from portal_subcategories where id_subcategory = ?`;
  } else {
    sql = `select * from portal_indicators where id = ?`;
  }
  console.log(sql);
  const rows = await doDBQuery(sql, [id]);
  await doDBClose();

  console.log('TOPICS', rows);

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/* GET topics */
// router.get('/topics/:id', async function (req, res, next) {
export const portalsGetTopics = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" }),
    }
  }

  await doDBOpen();

  // get the topics
  const sql = `select * from portal_topics where portal_id = ?`;
  const rows = await doDBQuery(sql, [id]);
  await doDBClose();

  console.log('TOPICS', rows);

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/* GET categories */
// router.get('/categories/:id', async function (req, res, next) {
export const portalsGetCategories = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
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
where m.portal = ?`;
  const rows = await doDBQuery(sql, [id]);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/* GET subcategories */
// router.get('/subcategories/:id', async function (req, res, next) {
export const portalsGetSubCategories = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
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
  where m.portal = ?`;
  const rows = await doDBQuery(sql, [id]);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});

/* GET indicators */
// router.get('/indicators/:id', async function (req, res, next) {
export const portalsGetIndicators = prepareAPIGateway(async (event: APIGatewayProxyEventV2) => {
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
  where m.portal = ? order by i.title`;
  const rows = await doDBQuery(sql, [id]);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  }
});
