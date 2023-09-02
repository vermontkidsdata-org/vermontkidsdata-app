export interface ServerMetadata {
  "transforms": {
    [columnName: string]: {
      "op": string
    }[]
  }
}

const sm: ServerMetadata = {"transforms":{"Category": [{"op": "striptag"}]}}