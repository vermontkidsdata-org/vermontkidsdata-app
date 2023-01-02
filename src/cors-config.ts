import { Options } from '@middy/http-cors';

export class CORSConfig implements Options {
  constructor(private env: NodeJS.ProcessEnv) {
  }

  get origin(): string {
    return "*";
  };

  get methods(): string {
    return "PUT, POST, DELETE";
  };

  get headers(): string {
    return 'Content-Type'
  };
}
