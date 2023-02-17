import { Options } from '@middy/http-cors';

export const CORSConfigDefault = {
  getOrigin: (incomingOrigin: string | undefined, options: Options): string => {
    console.log({ source: 'CORSConfigDefault', incomingOrigin, options });

    if (incomingOrigin == null ||
      !(incomingOrigin.endsWith('vtkidsdata.org') ||
        incomingOrigin === 'http://localhost:3000' ||
        incomingOrigin === 'http://ui.qa.vtkidsdata.org:3000' ||
        incomingOrigin === 'http://ui.dev.vtkidsdata.org:3000')) {
      return 'FORBIDDEN';
    } else {
      return incomingOrigin;
    }
  },
  credentials: true,
  methods: "GET, PUT, POST, DELETE",
  headers: "Content-Type"
};

export const CORSConfigOpen = {
  origin: '*',
  credentials: false,
  methods: "GET",
  headers: "Content-Type"
};

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
