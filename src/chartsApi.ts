import {APIGatewayProxyEventV2, APIGatewayProxyResultV2} from 'aws-lambda';

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

    let series = [{ name: 'All Students', data: [50,52] },
      { name: 'Free and Reduced Lunch', data: [35,38] },
      { name: 'Special Education', data: [13,17] },
      { name: 'Historically Marginalized', data: [36,39] }
    ];
    let categories = [ 'Jan', 'Feb' ];

    return {
      body: JSON.stringify({
        "id": chartId,
        "series": series,
        "categories": categories
        }
      ),
      statusCode: 200
    };
  }
}
