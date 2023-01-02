export function canonicalize(value: string): string {
  return value.toLowerCase().trim().replace(/[ \t\n]+/g, ' ');
}
