import {APIGatewayProxyEventV2, APIGatewayProxyResultV2} from 'aws-lambda';

export async function main(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log('event 👉', event);
I am an error!
  return {
    body: JSON.stringify({message: 'Successful lambda invocation for Dave'}),
    statusCode: 200,
  };
}
