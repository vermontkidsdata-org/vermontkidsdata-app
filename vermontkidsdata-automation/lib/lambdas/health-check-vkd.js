require('dotenv').config('.env');
const axios = require('axios');

const { LightsailClient, RebootRelationalDatabaseCommand, RebootInstanceCommand, GetInstanceStateCommand, StartInstanceCommand } = require("@aws-sdk/client-lightsail");
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

    let wpinput = {
        instanceName: 'VKD-WP'
    }

    const statecommand = new GetInstanceStateCommand(wpinput);
    const wpcommand = new RebootInstanceCommand(wpinput);
    const startcommand = new StartInstanceCommand(wpinput);

    let dbinput = {
        relationalDatabaseName: 'VKD-DB2'
    }
    const dbcommand = new RebootRelationalDatabaseCommand(dbinput);

    let healthy = true;

    try{

        let instanceState = await client.send(statecommand);
        let stateName = instanceState.state.name
        console.log(stateName);

        if(stateName === 'running'){
            //try to reboot if it's unresponsive
            try{
                let resp = await axios.get('https://vermontkidsdata.org');
                console.log('RUNNING INSTANCE HTTP STATUS',resp.status);
                if(resp.status != 200){
                    try {
                        const wpdata = await client.send(wpcommand);
                        console.log(wpdata)
                        let dbdata = await client.send(dbcommand);
                        console.log(dbdata);
                        // process data.
                    } catch (error) {
                        console.log(error);
                        // error handling.
                    }
                }

            } catch(e){ console.log(e); }

        } else if(stateName ==='stopped' || stateName === 'stopping'){
            console.log('INSTANCE STOPPED');
            let wpdata = await client.send(startcommand);
            console.log('STARTED VKD', wpdata);
            let dbdata = await client.send(dbcommand);
            console.log(dbdata);
        } else {

        }


    } catch(e) {
        console.log(e.message);
        //restart
        try {
            const wpdata = await client.send(wpcommand);
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