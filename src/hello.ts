import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from 'aws-lambda';

export async function main(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  console.log({message: 'hello starting', event});

// Lambda compile error
  return {
    body: JSON.stringify({message: 'Successful lambda invocation for New Breed'}),
    statusCode: 200,
  };
}
