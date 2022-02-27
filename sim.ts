// Local Lambda simulator
import * as express from 'express';
import * as path from 'path';

interface ConfigFile {
    "port": number;
    "apiurl": string;       // wherever the data API lambda is, e.g. https://jrnkzrwp0l.execute-api.us-east-1.amazonaws.com/prod"
}

const config = require ('./.env.json');

const app = express();
const port = config.port;
// import * as chartsRender from 'render/chartsRender';
const chartsRender = require(path.join(__dirname, 'render/chartsRender'))

app.get('/', (req, res) => {
    res.send('Hello World!')
})

interface LambdaResult {
    statusCode: number;
    headers: { [key: string]: string },
    body: string
}

app.get('/render/chart/bar/:id', async (req, res) => {
    // const ret = `Hello World from render2 ${req.params.id}`;
    const event = {
        pathParameters: {
            chartId: req.params.id
        }
    };
    console.log('config', config);
    process.env.apiurl = config.apiurl;
    const ret = await chartsRender.bar(event as any);
    
    // console.log(ret);
    res.send(ret.body); 
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})