import {APIGatewayProxyEventV2, APIGatewayProxyResultV2} from 'aws-lambda';
import { Liquid } from 'liquidjs';

const engine = new Liquid();

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
    const tpl = engine.parse('Welcome to {{v}}, id={{id}}!');
    const rendered = await engine.render(tpl, {v: "Liquid", id: chartId});

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html'
      },
      body: rendered
    };
  }
}
