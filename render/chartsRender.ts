import {APIGatewayEventRequestContextV2, APIGatewayProxyEventV2, APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2} from 'aws-lambda';
import { Liquid } from 'liquidjs';

var engine = new Liquid({
  root: ['views/', 'views/partials/'],
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

    const tpl = await engine.parseFile('charts/chart.liquid');
    const rendered = await engine.render(tpl, {
      title: 'Vermont Kids Data Chart', 
      id: chartId
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

// (async () => {
//   const event = {
//     pathParameters: {
//       chartId: 1234
//     }
//   };
//   console.log(await bar(event as any));
// })();
