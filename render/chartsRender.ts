import {APIGatewayEventRequestContextV2, APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2} from 'aws-lambda';
import { Liquid } from 'liquidjs';
import * as path from 'path';

var engine = new Liquid({
  root: [path.join(__dirname, 'views/'), path.join(__dirname, 'views/partials/')],
  extname: '.liquid'
});

export async function bar(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);

  if (event.pathParameters == null || event.pathParameters.chartId == null) {
    return {
      statusCode: 400
    }; 
  } else {
    const chartId = event.pathParameters.chartId;
    const apiurl = process.env.apiurl || '';

    console.log(`backend URL ${apiurl}`);

    const tpl = await engine.parseFile('charts/chart.liquid');
    const rendered = await engine.render(tpl, {
      title: 'Vermont Kids Data Chart', 
      id: chartId,
      apiurl: apiurl
    });

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html'
      },
      body: rendered
    };
  }
}
