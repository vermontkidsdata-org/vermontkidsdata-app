import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { Assistant, getAssistantKey, getAllAssistantFunctions, getAllAssistantDocuments, PublishedAssistant, getPublishedAssistantKey } from "./db-utils";
import { makePowerTools, prepareAPIGateway } from "./lambda-utils";
import { validateAPIAuthorization } from "./ai-utils";

const SERVICE = 'ai-assistant-download';

const pt = makePowerTools({ prefix: SERVICE });

export interface AssistantExportData {
  assistant: {
    id: string;
    type: string;
    sandbox?: string;
    name: string;
    definition: any;
    active: boolean;
  };
  functions: any[];
  documents: any[];
  publishedAssistant?: any;
  metadata: {
    exportedAt: string;
    exportedFrom: string;
    version: string;
  };
}

export async function lambdaHandler(
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> {
  pt.logger.info({ message: SERVICE, event });
  const ret = validateAPIAuthorization(event);
  if (ret) {
    return ret;
  }

  const id = event.pathParameters?.id;
  if (!id) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Missing assistant id",
      }),
    }
  }

  try {
    // Get the assistant
    const assistant = await Assistant.get(getAssistantKey(id));
    if (!assistant?.Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({
          message: "Assistant not found",
        }),
      }
    }

    const assItem = assistant.Item;

    // Get related data
    const [functions, documents] = await Promise.all([
      getAllAssistantFunctions(id),
      getAllAssistantDocuments(id)
    ]);

    // Try to get published assistant info (may not exist)
    let publishedAssistant = null;
    try {
      const envName = process.env.VKD_ENVIRONMENT || 'unknown';
      const pubAss = await PublishedAssistant.get(getPublishedAssistantKey(assItem.type, envName));
      if (pubAss?.Item) {
        publishedAssistant = {
          ...pubAss.Item,
          entity: undefined,
        };
      }
    } catch (error) {
      pt.logger.warn({ message: 'No published assistant found', error });
    }

    // Create export data
    const exportData: AssistantExportData = {
      assistant: {
        id: assItem.id,
        type: assItem.type,
        sandbox: assItem.sandbox as string | undefined,
        name: assItem.name,
        definition: assItem.definition,
        active: assItem.active,
      },
      functions: functions.map((f) => ({
        assistantId: f.assistantId,
        functionId: f.functionId,
        name: f.name,
        description: f.description,
        _vkd: f._vkd,
        seriesParameter: f.seriesParameter,
        categoryParameter: f.categoryParameter,
        otherParameters: f.otherParameters,
      })),
      documents: documents.map((d) => ({
        assistantId: d.assistantId,
        identifier: d.identifier,
        bucket: d.bucket,
        key: d.key,
      })),
      ...(publishedAssistant && { publishedAssistant }),
      metadata: {
        exportedAt: new Date().toISOString(),
        exportedFrom: process.env.VKD_ENVIRONMENT || 'unknown',
        version: '1.0.0',
      }
    };

    pt.logger.info({ 
      message: 'Assistant export completed', 
      assistantId: id,
      functionsCount: functions.length,
      documentsCount: documents.length,
      hasPublishedAssistant: !!publishedAssistant
    });

    return {
      statusCode: 200,
      body: JSON.stringify(exportData),
    }
  } catch (error) {
    pt.logger.error({ message: 'Error exporting assistant', error, assistantId: id });
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Error exporting assistant",
        error: (error as Error).message
      })
    }
  }
}

export const handler = prepareAPIGateway(lambdaHandler);