import { APIGatewayEvent } from "aws-lambda";
import { doDBClose, doDBCommit, doDBInsert, doDBOpen, doDBQuery } from "./db-utils";

/*
  // GET /
  export async function portalsGetList() {
  // * GET /:id
  export async function portalsGetById(event: APIGatewayEvent) {
  // router.post('/addelement/:elttype/:eltval/:eltparent', async function (req, res, next) {
  export async function portalsPostAddElement(event: APIGatewayEvent) {
  // router.post('/addmapping/:elttype/:eltid/:eltparent', async function (req, res, next) {
  export async function portalsPostAddMapping(event: APIGatewayEvent) {
  // router.post('/addindicator', async function (req, res, next) {
  export async function portalsPostAddIndicator(event: APIGatewayEvent) {
  // router.post('/addindicatormapping', async function (req, res, next) {
  export async function portalsPostAddIndicatorMapping(event: APIGatewayEvent) {
  // router.post('/deleteelement', async function (req, res, next) {
  export async function portalsPostDeleteElement(event: APIGatewayEvent) {
  // router.post('/editelement', async function (req, res, next) {
  export async function portalsPostEditElement(event: APIGatewayEvent) {
  // router.get('/element/:elt/:id', async function (req, res, next) {
  export async function portalsGetElementById(event: APIGatewayEvent) {
  // router.get('/topics/:id', async function (req, res, next) {
  export async function portalsGetTopics(event: APIGatewayEvent) {
  // router.get('/categories/:id', async function (req, res, next) {
  export async function portalsGetCategories(event: APIGatewayEvent) {
  // router.get('/subcategories/:id', async function (req, res, next) {
  export async function portalsGetSubCategories(event: APIGatewayEvent) {
  // router.get('/indicators/:id', async function (req, res, next) {
  export async function portalsGetIndicators(event: APIGatewayEvent) {
*/

/* GET home page. */
// GET /
export async function portalsGetList() {
  await doDBOpen();

  // get the topics
  let sql = 'select * from portals';
  // const [rows, fields] = await connection.execute(sql);
  const rows = await doDBQuery(sql);
  console.log('PORTALS', rows);

  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows)
  }
}

/**
  * GET /:id
  */
export async function portalsGetById(event: APIGatewayEvent) {
  const id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing ID" })
    }
  }

  await doDBOpen();

  // get the topics
  let sql = `select * from portals where id = ${id}`;
  const rows = await doDBQuery(sql);

  console.log('PORTAL', rows);

  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows)
  }
}

// router.post('/addelement/:elttype/:eltval/:eltparent', async function (req, res, next) {
export async function portalsPostAddElement(event: APIGatewayEvent) {
  const id = event.pathParameters?.id;
  let parent = event.pathParameters?.eltparent;
  let elttype = event.pathParameters?.elttype;
  let eltval = event.pathParameters?.eltval;

  if (parent == null || elttype == null || eltval == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  // get the topics
  let idElts = parent.split('_');
  let portal = idElts[0].replace('p', '');
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
    body: JSON.stringify('created element')
  }
}

// router.post('/addmapping/:elttype/:eltid/:eltparent', async function (req, res, next) {
export async function portalsPostAddMapping(event: APIGatewayEvent) {
  let parent = event.pathParameters?.eltparent;
  let elttype = event.pathParameters?.elttype;
  let eltId = event.pathParameters?.eltid;
  if (parent == null || elttype == null || eltId == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  // get the topics
  let idElts = parent.split('_');
  let portal = idElts[0].replace('p', '');
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
}

// router.post('/addindicator', async function (req, res, next) {
export async function portalsPostAddIndicator(event: APIGatewayEvent) {
  const body = JSON.parse(event.body || '{}');
  let parent = body.eltparent;
  let elttype = body.elttype;
  let eltval = body.eltval;
  let elturl = body.elturl;
  let eltlink = body.eltlink;

  if (parent == null || elttype == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  // get the topics
  //let eltindicator = event.pathParameters?.eltindicator;
  let idElts = parent.split('_');
  let portal = idElts[0].replace('p', '');
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
    body: JSON.stringify('created indicator')
  }

}

// router.post('/addindicatormapping', async function (req, res, next) {
export async function portalsPostAddIndicatorMapping(event: APIGatewayEvent) {
  const body = JSON.parse(event.body || '{}');
  let parent = body.eltparent;
  let elttype = body.elttype;
  let eltid = body.eltid;
  if (parent == null || elttype == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  // get the topics
  let idElts = parent.split('_');
  let portal = idElts[0].replace('p', '');
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
    body: JSON.stringify('created indicator mapping')
  }
}

// router.post('/deleteelement', async function (req, res, next) {
export async function portalsPostDeleteElement(event: APIGatewayEvent) {
  const body = JSON.parse(event.body || '{}');
  console.log(body);
  let eltid = body.eltid;
  let eltval = body.eltval;
  let elttype = body.elttype;
  if (elttype == null || eltid == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  let idElts = eltid.split('_');

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
    body: JSON.stringify('element deleted')
  }
}

// router.post('/editelement', async function (req, res, next) {
export async function portalsPostEditElement(event: APIGatewayEvent) {
  const body = JSON.parse(event.body || '{}');
  console.log(body);

  let eltid = body.eltid;
  let eltval = body.eltval;
  let elttype = body.elttype;
  if (elttype == null || eltid == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  let idElts = eltid.split('_');

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
    body: JSON.stringify('element updated')
  }
}

/* GET an individual element by ID */
// router.get('/element/:elt/:id', async function (req, res, next) {
export async function portalsGetElementById(event: APIGatewayEvent) {
  let id = event.pathParameters?.id;
  let elt = event.pathParameters?.elt;
  if (elt == null || id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
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
    body: JSON.stringify(rows)
  }
}

/* GET topics */
// router.get('/topics/:id', async function (req, res, next) {
export async function portalsGetTopics(event: APIGatewayEvent) {
  let id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  // get the topics
  let sql = `select * from portal_topics where portal_id = ${id}`;
  const rows = await doDBQuery(sql);
  await doDBClose();

  console.log('TOPICS', rows);

  return {
    statusCode: 200,
    body: JSON.stringify(rows)
  }
}

/* GET categories */
// router.get('/categories/:id', async function (req, res, next) {
export async function portalsGetCategories(event: APIGatewayEvent) {
  let id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  //get the categories
  let sql = `select id, topic, id_category, name from portal_category_topic_map m 
join portal_categories pc on pc.id_category = m.category
where m.portal = ${id}`;
  const rows = await doDBQuery(sql);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows)
  }
}

/* GET subcategories */
// router.get('/subcategories/:id', async function (req, res, next) {
export async function portalsGetSubCategories(event: APIGatewayEvent) {
  let id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  //get the categories
  let sql = `select id, topic, category, id_subcategory, name from portal_subcategory_category_map m 
  join portal_subcategories sc on sc.id_subcategory = m.subcategory
  where m.portal = ${id}`;
  const rows = await doDBQuery(sql);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows)
  }
}

/* GET indicators */
// router.get('/indicators/:id', async function (req, res, next) {
export async function portalsGetIndicators(event: APIGatewayEvent) {
  let id = event.pathParameters?.id;
  if (id == null) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing param values" })
    }
  }

  await doDBOpen();

  //get the categories
  let sql = `SELECT * FROM portal_indicator_map m
  join portal_indicators i on i.id = m.indicator
  where m.portal = ${id} order by i.title`;
  const rows = await doDBQuery(sql);
  await doDBClose();

  return {
    statusCode: 200,
    body: JSON.stringify(rows)
  }
}
