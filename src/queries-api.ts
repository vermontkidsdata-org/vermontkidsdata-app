import { prepareAPIGateway } from './lambda-utils';
import * as queriestApiDelete from './queries-api-delete';
import * as queriestApiGet from './queries-api-get';
import * as queriestApiGetList from './queries-api-getList';
import * as queriestApiPost from './queries-api-post';
import * as queriestApiPut from './queries-api-put';

export const handlerGet = prepareAPIGateway(queriestApiGet.lambdaHandler);
export const handlerGetList = prepareAPIGateway(queriestApiGetList.lambdaHandler);
export const handlerPost = prepareAPIGateway(queriestApiPost.lambdaHandler);
export const handlerDelete = prepareAPIGateway(queriestApiDelete.lambdaHandler);
export const handlerPut = prepareAPIGateway(queriestApiPut.lambdaHandler);
