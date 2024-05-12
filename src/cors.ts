export function getHeaders(contentType: string, addOpenCors?: boolean): { [header: string]: string } {
  return {
    "Content-Type": contentType,
    ...(
      addOpenCors ? {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET",
      } : {}),
  };
}

export function httpResponse(statusCode: number, body: any, addOpenCors?: boolean): any {
  return {
    body: JSON.stringify(body),
    headers: getHeaders("application/json", addOpenCors),
    statusCode,
  };
}

export function httpMessageResponse(statusCode: number, message: string, addOpenCors?: boolean): any {
  return {
    body: JSON.stringify({
      message,
    }),
    headers: getHeaders("application/json", addOpenCors),
    statusCode,
  };
}
