interface MatchObject {
    Parameters?: Record<string, unknown>;
    Resources: Record<string, unknown>;
}

interface Resources {
    [key: string]: {
        Type: string;
    };
}

export const getMatchObject = (resources: Resources): MatchObject => {
    const matchObject: MatchObject = { Parameters: expect.any(Object), Resources: {} };
    Object.keys(resources).forEach((res) => {
      switch (resources[res].Type) {
        // Custom Deployments policies include a hash to the deployment artifact and will change frequently.
        case 'AWS::IAM::Policy':
          if (res.startsWith('CustomCDKBucketDeployment')) {
            matchObject.Resources[res] = {
              Properties: {
                PolicyDocument: {
                  Statement: expect.any(Array),
                },
              },
            };
          }
          break;
        // Code path is a hash that always changes.
        case 'AWS::Lambda::Function':
          matchObject.Resources[res] = {
            Properties: { Code: expect.any(Object) },
          };
          break;
        // Layer content is a hash.
        case 'AWS::Lambda::LayerVersion':
          matchObject.Resources[res] = {
            Properties: {
              Content: expect.any(Object),
            },
          };
          break;
        // Cfn Properties include all the resource hashes and will change on every deploy.
        case 'AWS::CloudFormation::Stack':
          matchObject.Resources[res] = {
            Properties: expect.any(Object),
          };
          break;
        // Deployment artifacts are hashes that change frequently.
        case 'Custom::CDKBucketDeployment':
          matchObject.Resources[res] = {
            Properties: {
              SourceBucketNames: expect.any(Array),
              SourceObjectKeys: expect.any(Object),
            },
          };
          break;
        default:
          break;
      }
    });
    return matchObject;
  };