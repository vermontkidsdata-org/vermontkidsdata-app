import { census } from '../citysdk-utils';

describe('basic test', () => {
    it('calls census', async () => {
        const result = await census({
            vintage: '2017',
            geoHierarchy: {
              state: "06",
              county: '*',
            },
            sourcePath: ['acs','acs5'],
            values: ['B00001_001E'],
          });
          expect(result[0].B00001_001E).not.toBeNull();
    });
});
