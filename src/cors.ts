export function getHeaders(contentType: string): { [header: string]: string } {
    return {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": contentType,
        "Access-Control-Allow-Methods": "GET",
    };
}
