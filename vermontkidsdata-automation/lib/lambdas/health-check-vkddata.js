require('dotenv').config('.env');
const axios = require('axios');

const { LightsailClient, RebootRelationalDatabaseCommand, RebootInstanceCommand } = require("@aws-sdk/client-lightsail");
const { SecretsManagerClient, GetSecretValueCommand, GetSecretValueCommandInput } = require("@aws-sdk/client-secrets-manager");

exports.handler = async function(event, context) {

    // get secrets from AWS

    const secretsManagerClient = new SecretsManagerClient({ region: "us-east-1" });
    let secretsInput = {
        SecretId: 'arn:aws:secretsmanager:us-east-1:439348011602:secret:lightsail/automation-NiR8c8'
    };
    const secretsCommand = new GetSecretValueCommand(secretsInput);
    let secrets = await secretsManagerClient.send(secretsCommand);
    let secret = JSON.parse(secrets.SecretString)
    console.log(secret);

    const options = {
        credentials: {
            accessKeyId: secret['lightsail-access-key-id'],
            secretAccessKey: secret['lightsail-secret-access-key']
        },
        region: 'us-east-1'
    };

    const client = new LightsailClient(options);

    let vkddatainput = {
        instanceName: 'VKD-DATA'
    }

    const vkddatacommand = new RebootInstanceCommand(vkddatainput);

    let dbinput = {
        relationalDatabaseName: 'VKD-DB2'
    }
    const dbcommand = new RebootRelationalDatabaseCommand(dbinput);

    let healthy = true;

    try{
        let resp = await axios.get('https://data.vermontkidsdata.org');
        console.log(resp.status);
        if(resp.status != 200 ){
            /*
            try {
                const wpdata = await client.send(vkddatacommand);
                console.log(wpdata);
                const dbdata = await client.send(dbcommand);
                console.log(dbdata);
                // process data.
            } catch (error) {
                console.log(error);
                // error handling.
            }

             */
        } //end check

    } catch(e) {
        console.log(e.message);
        //restart
        try {
            const wpdata = await client.send(vkddatacommand);
            console.log(wpdata);
            const dbdata = await client.send(dbcommand);
            console.log(dbdata);
            // process data.
        } catch (error) {
            console.log(error);
            // error handling.
        }
    }

};