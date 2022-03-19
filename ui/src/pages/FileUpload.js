import {Link, Outlet} from "react-router-dom";
import Layout from "./Layout";
import { Upload } from "@aws-sdk/lib-storage";
import { S3Client, S3 } from "@aws-sdk/client-s3";

const bucket = "master-localdevbranch-uploadsbucket86f42938-1x6dlq695pl4z";

const upload = (file) => {
    var file = file.target.files[0];
    const target = { Bucket:bucket, Key:file.name, Body:file };
    const creds = {
        // NOTE: THIS HAS BEEN DISABLED - DON'T ADD A NEW ONE
        accessKeyId: "AKIAWMSZOUJJOTMZCWDG",
        secretAccessKey: "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"
    };
    try {
        const parallelUploads3 = new Upload({
            client: new S3({
                region:"us-east-1",
                credentials:creds
            }) || new S3Client({}),
            tags: [{
                Key: "assessment",
                Value: "AOE Assessment Upload"}],
            leavePartsOnError: false, // optional manually handle dropped parts
            params: target,
        });

        parallelUploads3.on("httpUploadProgress", (progress) => {
            console.log(progress);
        });

        parallelUploads3.done();

    } catch (e) {
        console.log(e);
    }
}

const FileUpload = () => {
    return (
        <div>
            <input type="file" onChange={upload}  />
        </div>
    )
};

export default FileUpload;