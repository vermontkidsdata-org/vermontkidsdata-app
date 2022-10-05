export interface LambdaResponse {
  body: string,
  headers: { [header: string]: string },
  statusCode: number
}

// Validate it has CORS headers
export function expectCORS(ret: LambdaResponse): void {
  expect(Object.entries(ret.headers).filter(h => h[0] == 'Access-Control-Allow-Origin').length).toBe(1);
}
