"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getMatchObject = void 0;
exports.getMatchObject = (resources) => {
    const matchObject = { Parameters: expect.any(Object), Resources: {} };
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidGVzdHV0aWxzLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsidGVzdHV0aWxzLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQVdhLFFBQUEsY0FBYyxHQUFHLENBQUMsU0FBb0IsRUFBZSxFQUFFO0lBQ2hFLE1BQU0sV0FBVyxHQUFnQixFQUFFLFVBQVUsRUFBRSxNQUFNLENBQUMsR0FBRyxDQUFDLE1BQU0sQ0FBQyxFQUFFLFNBQVMsRUFBRSxFQUFFLEVBQUUsQ0FBQztJQUNuRixNQUFNLENBQUMsSUFBSSxDQUFDLFNBQVMsQ0FBQyxDQUFDLE9BQU8sQ0FBQyxDQUFDLEdBQUcsRUFBRSxFQUFFO1FBQ3JDLFFBQVEsU0FBUyxDQUFDLEdBQUcsQ0FBQyxDQUFDLElBQUksRUFBRTtZQUMzQixvR0FBb0c7WUFDcEcsS0FBSyxrQkFBa0I7Z0JBQ3JCLElBQUksR0FBRyxDQUFDLFVBQVUsQ0FBQywyQkFBMkIsQ0FBQyxFQUFFO29CQUMvQyxXQUFXLENBQUMsU0FBUyxDQUFDLEdBQUcsQ0FBQyxHQUFHO3dCQUMzQixVQUFVLEVBQUU7NEJBQ1YsY0FBYyxFQUFFO2dDQUNkLFNBQVMsRUFBRSxNQUFNLENBQUMsR0FBRyxDQUFDLEtBQUssQ0FBQzs2QkFDN0I7eUJBQ0Y7cUJBQ0YsQ0FBQztpQkFDSDtnQkFDRCxNQUFNO1lBQ1IsMkNBQTJDO1lBQzNDLEtBQUssdUJBQXVCO2dCQUMxQixXQUFXLENBQUMsU0FBUyxDQUFDLEdBQUcsQ0FBQyxHQUFHO29CQUMzQixVQUFVLEVBQUUsRUFBRSxJQUFJLEVBQUUsTUFBTSxDQUFDLEdBQUcsQ0FBQyxNQUFNLENBQUMsRUFBRTtpQkFDekMsQ0FBQztnQkFDRixNQUFNO1lBQ1IsMkJBQTJCO1lBQzNCLEtBQUssMkJBQTJCO2dCQUM5QixXQUFXLENBQUMsU0FBUyxDQUFDLEdBQUcsQ0FBQyxHQUFHO29CQUMzQixVQUFVLEVBQUU7d0JBQ1YsT0FBTyxFQUFFLE1BQU0sQ0FBQyxHQUFHLENBQUMsTUFBTSxDQUFDO3FCQUM1QjtpQkFDRixDQUFDO2dCQUNGLE1BQU07WUFDUixrRkFBa0Y7WUFDbEYsS0FBSyw0QkFBNEI7Z0JBQy9CLFdBQVcsQ0FBQyxTQUFTLENBQUMsR0FBRyxDQUFDLEdBQUc7b0JBQzNCLFVBQVUsRUFBRSxNQUFNLENBQUMsR0FBRyxDQUFDLE1BQU0sQ0FBQztpQkFDL0IsQ0FBQztnQkFDRixNQUFNO1lBQ1IsMERBQTBEO1lBQzFELEtBQUssNkJBQTZCO2dCQUNoQyxXQUFXLENBQUMsU0FBUyxDQUFDLEdBQUcsQ0FBQyxHQUFHO29CQUMzQixVQUFVLEVBQUU7d0JBQ1YsaUJBQWlCLEVBQUUsTUFBTSxDQUFDLEdBQUcsQ0FBQyxLQUFLLENBQUM7d0JBQ3BDLGdCQUFnQixFQUFFLE1BQU0sQ0FBQyxHQUFHLENBQUMsTUFBTSxDQUFDO3FCQUNyQztpQkFDRixDQUFDO2dCQUNGLE1BQU07WUFDUjtnQkFDRSxNQUFNO1NBQ1Q7SUFDSCxDQUFDLENBQUMsQ0FBQztJQUNILE9BQU8sV0FBVyxDQUFDO0FBQ3JCLENBQUMsQ0FBQyIsInNvdXJjZXNDb250ZW50IjpbImludGVyZmFjZSBNYXRjaE9iamVjdCB7XHJcbiAgICBQYXJhbWV0ZXJzPzogUmVjb3JkPHN0cmluZywgdW5rbm93bj47XHJcbiAgICBSZXNvdXJjZXM6IFJlY29yZDxzdHJpbmcsIHVua25vd24+O1xyXG59XHJcblxyXG5pbnRlcmZhY2UgUmVzb3VyY2VzIHtcclxuICAgIFtrZXk6IHN0cmluZ106IHtcclxuICAgICAgICBUeXBlOiBzdHJpbmc7XHJcbiAgICB9O1xyXG59XHJcblxyXG5leHBvcnQgY29uc3QgZ2V0TWF0Y2hPYmplY3QgPSAocmVzb3VyY2VzOiBSZXNvdXJjZXMpOiBNYXRjaE9iamVjdCA9PiB7XHJcbiAgICBjb25zdCBtYXRjaE9iamVjdDogTWF0Y2hPYmplY3QgPSB7IFBhcmFtZXRlcnM6IGV4cGVjdC5hbnkoT2JqZWN0KSwgUmVzb3VyY2VzOiB7fSB9O1xyXG4gICAgT2JqZWN0LmtleXMocmVzb3VyY2VzKS5mb3JFYWNoKChyZXMpID0+IHtcclxuICAgICAgc3dpdGNoIChyZXNvdXJjZXNbcmVzXS5UeXBlKSB7XHJcbiAgICAgICAgLy8gQ3VzdG9tIERlcGxveW1lbnRzIHBvbGljaWVzIGluY2x1ZGUgYSBoYXNoIHRvIHRoZSBkZXBsb3ltZW50IGFydGlmYWN0IGFuZCB3aWxsIGNoYW5nZSBmcmVxdWVudGx5LlxyXG4gICAgICAgIGNhc2UgJ0FXUzo6SUFNOjpQb2xpY3knOlxyXG4gICAgICAgICAgaWYgKHJlcy5zdGFydHNXaXRoKCdDdXN0b21DREtCdWNrZXREZXBsb3ltZW50JykpIHtcclxuICAgICAgICAgICAgbWF0Y2hPYmplY3QuUmVzb3VyY2VzW3Jlc10gPSB7XHJcbiAgICAgICAgICAgICAgUHJvcGVydGllczoge1xyXG4gICAgICAgICAgICAgICAgUG9saWN5RG9jdW1lbnQ6IHtcclxuICAgICAgICAgICAgICAgICAgU3RhdGVtZW50OiBleHBlY3QuYW55KEFycmF5KSxcclxuICAgICAgICAgICAgICAgIH0sXHJcbiAgICAgICAgICAgICAgfSxcclxuICAgICAgICAgICAgfTtcclxuICAgICAgICAgIH1cclxuICAgICAgICAgIGJyZWFrO1xyXG4gICAgICAgIC8vIENvZGUgcGF0aCBpcyBhIGhhc2ggdGhhdCBhbHdheXMgY2hhbmdlcy5cclxuICAgICAgICBjYXNlICdBV1M6OkxhbWJkYTo6RnVuY3Rpb24nOlxyXG4gICAgICAgICAgbWF0Y2hPYmplY3QuUmVzb3VyY2VzW3Jlc10gPSB7XHJcbiAgICAgICAgICAgIFByb3BlcnRpZXM6IHsgQ29kZTogZXhwZWN0LmFueShPYmplY3QpIH0sXHJcbiAgICAgICAgICB9O1xyXG4gICAgICAgICAgYnJlYWs7XHJcbiAgICAgICAgLy8gTGF5ZXIgY29udGVudCBpcyBhIGhhc2guXHJcbiAgICAgICAgY2FzZSAnQVdTOjpMYW1iZGE6OkxheWVyVmVyc2lvbic6XHJcbiAgICAgICAgICBtYXRjaE9iamVjdC5SZXNvdXJjZXNbcmVzXSA9IHtcclxuICAgICAgICAgICAgUHJvcGVydGllczoge1xyXG4gICAgICAgICAgICAgIENvbnRlbnQ6IGV4cGVjdC5hbnkoT2JqZWN0KSxcclxuICAgICAgICAgICAgfSxcclxuICAgICAgICAgIH07XHJcbiAgICAgICAgICBicmVhaztcclxuICAgICAgICAvLyBDZm4gUHJvcGVydGllcyBpbmNsdWRlIGFsbCB0aGUgcmVzb3VyY2UgaGFzaGVzIGFuZCB3aWxsIGNoYW5nZSBvbiBldmVyeSBkZXBsb3kuXHJcbiAgICAgICAgY2FzZSAnQVdTOjpDbG91ZEZvcm1hdGlvbjo6U3RhY2snOlxyXG4gICAgICAgICAgbWF0Y2hPYmplY3QuUmVzb3VyY2VzW3Jlc10gPSB7XHJcbiAgICAgICAgICAgIFByb3BlcnRpZXM6IGV4cGVjdC5hbnkoT2JqZWN0KSxcclxuICAgICAgICAgIH07XHJcbiAgICAgICAgICBicmVhaztcclxuICAgICAgICAvLyBEZXBsb3ltZW50IGFydGlmYWN0cyBhcmUgaGFzaGVzIHRoYXQgY2hhbmdlIGZyZXF1ZW50bHkuXHJcbiAgICAgICAgY2FzZSAnQ3VzdG9tOjpDREtCdWNrZXREZXBsb3ltZW50JzpcclxuICAgICAgICAgIG1hdGNoT2JqZWN0LlJlc291cmNlc1tyZXNdID0ge1xyXG4gICAgICAgICAgICBQcm9wZXJ0aWVzOiB7XHJcbiAgICAgICAgICAgICAgU291cmNlQnVja2V0TmFtZXM6IGV4cGVjdC5hbnkoQXJyYXkpLFxyXG4gICAgICAgICAgICAgIFNvdXJjZU9iamVjdEtleXM6IGV4cGVjdC5hbnkoT2JqZWN0KSxcclxuICAgICAgICAgICAgfSxcclxuICAgICAgICAgIH07XHJcbiAgICAgICAgICBicmVhaztcclxuICAgICAgICBkZWZhdWx0OlxyXG4gICAgICAgICAgYnJlYWs7XHJcbiAgICAgIH1cclxuICAgIH0pO1xyXG4gICAgcmV0dXJuIG1hdGNoT2JqZWN0O1xyXG4gIH07Il19