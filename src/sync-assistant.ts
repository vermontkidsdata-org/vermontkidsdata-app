import { createReadStream, readdirSync, statSync } from "fs";
import OpenAI from "openai";
import { FileObject, FileObjectsPage } from "openai/resources";
import { VectorStoreFile } from "openai/resources/vector-stores/files";
import { join } from "path";
import { getAssistantInfo } from "./assistant-def";
const openai = new OpenAI();

/**
 * Syncs the assistant with the config file. We do this for MLOps purposes, as well as because
 * the assistants UI doesn't let us add a lot of additional config information we need.
 */
async function syncAssistant(props: { ns: string }) {
  const { ns } = props;

  const info = await getAssistantInfo(ns, true);

  // const def = await openai.beta.assistants.retrieve(assistantId);
  // console.log(JSON.stringify(def, null, 2));

  // Get current files
  const files: OpenAI.Files.FileObject[] = [];

  for (let currentFiles: FileObjectsPage | undefined = await openai.files.list();
    currentFiles;
    currentFiles = currentFiles.hasNextPage() ? await currentFiles.getNextPage() : undefined) {
    files.push(...currentFiles.data);
  }

  files.forEach((file) => {
    console.log("File: ", file.id, file.filename, file.purpose);
  });

  const filesToAdd: FileObject[] = [],
    filesToRemove: VectorStoreFile[] = [],
    filesToReference: FileObject[] = [];

  // Get files currently in the vector store
  const vsFiles = (await openai.vectorStores.files.list(info.vectorStore)).data;
  console.log('vs', vsFiles);
  // if (1 == 1) process.exit(1);

  // Upload any new files
  for (const file of readdirSync(join(__dirname, "../files"))) {
    if (statSync(join(__dirname, "../files", file)).isFile()) {
      let found = files.find((f) => f.filename === file);
      if (!found) {
        console.log("Uploading file: ", file);

        found = await openai.files.create({
          file: createReadStream(join(__dirname, "../files", file)),
          purpose: "assistants",
        });
      } else {
        console.log("File already exists: ", file);
      }

      filesToReference.push(found);

      // Sync the file to the vector store
      if (!vsFiles.find((f) => f.id === found.id)) {
        filesToAdd.push(found);
      }
    }
  }

  // Now remove any files not in the files to reference
  for (const file of vsFiles) {
    if (!filesToReference.find((f) => f.id === file.id)) {
      filesToRemove.push(file);
    }
  }

  // Add or remove
  console.log("Adding files: ", filesToAdd.map((f) => f.id));
  if (filesToAdd.length > 0) {
    await openai.vectorStores.fileBatches.create(
      info.vectorStore,
      {
        file_ids: filesToAdd.map((f) => f.id),
      },
    );
  }

  console.log("Removing files: ", filesToRemove.map((f) => f.id));
  if (filesToRemove.length > 0) {
    for (const file of filesToRemove) {
      console.log("Removing file from vs: ", file.id);
      await openai.vectorStores.files.delete(file.id, {
        vector_store_id: info.vectorStore,
      });
    }
  }

  // console.log(JSON.stringify(def, null, 2));
  await openai.beta.assistants.update(info.assistantId, info.assistant);

  console.log(`Sync complete, assistant ${info.assistantId} updated`);
}

(async () => {
  const ns = process.env.VKD_ENVIRONMENT;
  if (!ns) {
    throw new Error("VKD_ENVIRONMENT not set");
  }

  await syncAssistant({ ns });
})().catch(console.error);

