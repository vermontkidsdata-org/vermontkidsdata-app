import * as datasetApiPost from './dataset-api-post';
import { prepareAPIGateway } from './lambda-utils';

export const handlerPost = prepareAPIGateway(datasetApiPost.lambdaHandler);
