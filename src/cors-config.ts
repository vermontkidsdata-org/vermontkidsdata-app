import { Options } from '@middy/http-cors';

export class CORSConfig implements Options {
  constructor(private env: NodeJS.ProcessEnv, private isPreflight?: boolean) {
  }

  get origin(): string {
    const ret = "*";
    console.log(`CORSConfig.origin() call: returning ${ret}`);
    return ret;
  };

  get methods(): string {
    const ret = "PUT, POST, DELETE";
    console.log(`CORSConfig.methods() call: returning ${ret}`);
    return ret;
  };

  get headers(): string {
    const ret = "Content-Type";
    console.log(`CORSConfig.headers() call: returning ${ret}`);
    return ret;
  };
}
