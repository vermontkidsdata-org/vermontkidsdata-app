import { lambdaHandler } from './ai-start-openai-completion';

(async () => {
  const event = {
    "id": "1249",
    "sortKey": 0,
    "query": "Please compare the mental health state of Vermont's children in 2022 vs 2019.",
    "stream": true
  };
  
  const result = await lambdaHandler(event);
  console.log(result);
})();
