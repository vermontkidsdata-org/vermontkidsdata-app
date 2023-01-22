export function getHeaders(contentType: string): { [header: string]: string } {
    return {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": contentType,
        "Access-Control-Allow-Methods": "GET",
    };
}

export function httpResponse(statusCode: number, body: any): any {
  return {
    body: JSON.stringify(body),
    headers: getHeaders("application/json"),
    statusCode,
  };
}

export function httpMessageResponse(statusCode: number, message: string): any {
  return {
    body: JSON.stringify({
      message
    }),
    headers: getHeaders("application/json"),
    statusCode,
  };
}
