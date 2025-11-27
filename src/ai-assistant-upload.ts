import { APIGatewayProxyEventV2WithRequestContext, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, AssistantFunction, AssistantDocument, PublishedAssistant, getAllAssistants } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";
import { ulid } from "ulid";
import { AssistantExportData } from "./ai-assistant-download";

const SERVICE = 'ai-assistant-upload';

const pt = makePowerTools({ prefix: SERVICE });

export interface AssistantImportOptions {
  mode: 'create' | 'update' | 'replace';
  dryRun?: boolean;
  preserveId?: boolean;
  targetType?: string;
}

export interface AssistantImportRequest {
  exportData: AssistantExportData;
  options: AssistantImportOptions;
}

export async function lambdaHandler(
  event: APIGatewayProxyEventV2WithRequestContext<any>
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: SERVICE, event });
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  if (!event.body) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing request body",
      })
    }
  }

  try {
    const requestBody: AssistantImportRequest = JSON.parse(event.body);
    const { exportData, options } = requestBody;

    if (!exportData || !exportData.assistant) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Missing export data or assistant definition",
        })
      }
    }

    const { mode, dryRun = false, preserveId = false, targetType } = options;
    const sourceAssistant = exportData.assistant;
    const targetAssistantType = targetType || sourceAssistant.type;

    // Validate mode
    if (!['create', 'update', 'replace'].includes(mode)) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Invalid mode. Must be 'create', 'update', or 'replace'",
        })
      }
    }

    // Check for existing assistants with the same type
    const existingAssistants = await getAllAssistants({ type: targetAssistantType });
    
    let targetAssistantId: string;
    let existingAssistant = null;

    if (mode === 'create') {
      if (existingAssistants.length > 0) {
        return {
          statusCode: 409,
          body: JSON.stringify({
            message: "Assistant with this type already exists. Use 'update' or 'replace' mode.",
            existingAssistantId: existingAssistants[0]!.id
          })
        }
      }
      targetAssistantId = preserveId ? sourceAssistant.id : ulid().toLowerCase();
    } else {
      // update or replace mode
      if (existingAssistants.length === 0) {
        return {
          statusCode: 404,
          body: JSON.stringify({
            message: "No existing assistant found to update/replace",
          })
        }
      }
      existingAssistant = existingAssistants[0];
      targetAssistantId = existingAssistant.id;
    }

    // Prepare the new assistant data
    const newAssistant = {
      id: targetAssistantId,
      type: targetAssistantType,
      name: sourceAssistant.name,
      definition: {
        ...sourceAssistant.definition,
        // Update any environment-specific references here
        modified: new Date().toISOString()
      },
      active: sourceAssistant.active,
      ...(sourceAssistant.sandbox && { sandbox: sourceAssistant.sandbox }),
    };

    if (dryRun) {
      return {
        statusCode: 200,
        body: JSON.stringify({
          message: "Dry run completed successfully",
          operation: mode,
          targetAssistantId,
          changes: {
            assistant: newAssistant,
            functionsToImport: exportData.functions.length,
            documentsToImport: exportData.documents.length,
            hasPublishedAssistant: !!exportData.publishedAssistant
          }
        })
      }
    }

    // Perform the actual import
    pt.logger.info({ 
      message: 'Starting assistant import', 
      mode, 
      targetAssistantId,
      sourceId: sourceAssistant.id 
    });

    // 1. Create/Update the assistant
    await Assistant.put(newAssistant);

    // 2. Handle functions
    if (mode === 'replace' && existingAssistant) {
      // TODO: Delete existing functions for replace mode
      // This would require a helper function to delete all assistant functions
    }

    // Import functions
    for (const func of exportData.functions) {
      const newFunction = {
        ...func,
        assistantId: targetAssistantId,
        // Keep the same functionId or generate new one if needed
      };
      await AssistantFunction.put(newFunction);
    }

    // 3. Handle documents
    if (mode === 'replace' && existingAssistant) {
      // TODO: Delete existing documents for replace mode
      // This would require a helper function to delete all assistant documents
    }

    // Import documents
    for (const doc of exportData.documents) {
      const newDocument = {
        ...doc,
        assistantId: targetAssistantId,
      };
      await AssistantDocument.put(newDocument);
    }

    // 4. Handle published assistant if present
    if (exportData.publishedAssistant) {
      const envName = process.env.VKD_ENVIRONMENT || 'unknown';
      const newPublishedAssistant = {
        ...exportData.publishedAssistant,
        type: targetAssistantType,
        envName,
        assistantId: targetAssistantId,
        // Note: openAIAssistantId would need to be updated when actually publishing to OpenAI
      };
      await PublishedAssistant.put(newPublishedAssistant);
    }

    pt.logger.info({ 
      message: 'Assistant import completed successfully', 
      targetAssistantId,
      functionsImported: exportData.functions.length,
      documentsImported: exportData.documents.length
    });

    return {
      statusCode: 201,
      body: JSON.stringify({
        message: "Assistant imported successfully",
        operation: mode,
        assistant: {
          ...newAssistant,
          functionsCount: exportData.functions.length,
          documentsCount: exportData.documents.length
        },
        importedFrom: exportData.metadata
      })
    }

  } catch (error) {
    pt.logger.error({ message: 'Error importing assistant', error });
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Error importing assistant",
        error: (error as Error).message
      })
    }
  }
}

export const handler = prepareAPIGateway(lambdaHandler);