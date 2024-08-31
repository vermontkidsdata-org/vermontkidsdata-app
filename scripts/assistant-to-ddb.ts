import { ASSISTANTS_MAP, CATEGORY_PARAMETER, getAssistantInfo, SERIES_PARAMETER, VKDFunction } from "../src/assistant-def";
import { Assistant, AssistantFunction, AssistantMap, getAllAssistantFunctions, getAllAssistants, getAssistantFunctionKey, getAssistantKey, makeParamDef } from "../src/db-utils";

console.log("Assistant to DDB");

const ns = process.env.VKD_ENVIRONMENT;
if (ns == null) {
    console.error("VKD_ENVIRONMENT is not set");
    process.exit(1);
}

(async () => {
    // First clear out the existing records
    const assistants = await getAllAssistants(ns);
    for (const assistant of assistants) {
        console.log(`Delete Assistant: ${assistant.id}`);
        await Assistant.delete(getAssistantKey(assistant.id));

        const assistantFunctions = await getAllAssistantFunctions(assistant.id);
        for (const assistantFunction of assistantFunctions) {
            console.log(`Delete Function: ${assistant.id}.${assistantFunction.functionId} (${assistantFunction.name})`);
            await AssistantFunction.delete(getAssistantFunctionKey(assistant.id, assistantFunction.functionId));
        }
    }

    const assistant = getAssistantInfo(ns, false);
    if (assistant == null) {
        console.error("Assistant not found");
        process.exit(1);
    }

    // reduce the assistant to the assistant definition
    const assistantWithoutFunctions = {
        ...assistant.assistant,
        tools: assistant.assistant.tools.filter((tool) => tool.type !== 'function'),
    };

    // Make id the current timestamp
    const assistantId = Date.now().toString();

    console.log(`Write Assistant: ${assistantId} (${ns})`);
    await Assistant.put({
        id: assistantId,
        ns,
        name: assistantWithoutFunctions.name || `VKD assistant for ${ns}`,
        definition: assistantWithoutFunctions,
    });

    // Write the functions
    for (const tool of assistant.assistant.tools) {
        if (tool.type === 'function') {
            const vkdFunc = tool.function as VKDFunction;
            const vkdFuncMetadata = vkdFunc._vkd;
            let categoryParameter: ReturnType<typeof makeParamDef> | undefined;
            let seriesParameter: ReturnType<typeof makeParamDef> | undefined;
            let otherParameters: ReturnType<typeof makeParamDef>[] = [];
            if (vkdFunc.parameters?.properties) {
                for (const [paramName, param] of Object.entries(vkdFunc.parameters.properties)) {
                    if (param._vkd.type === CATEGORY_PARAMETER) {
                        categoryParameter = makeParamDef(paramName, param.type, param.description, param.enum, param._vkd);
                    } else if (param._vkd.type === SERIES_PARAMETER) {
                        seriesParameter = makeParamDef(paramName, param.type, param.description, param.enum, param._vkd);
                    } else {
                        otherParameters.push(makeParamDef(paramName, param.type, param.description, param.enum, param._vkd));
                    }
                }
            }
            
            const functionId = Date.now().toString();
            console.log(`Write Function: ${assistantId}.${functionId} (${vkdFunc.name})`);
            await AssistantFunction.put({
                assistantId,
                functionId,
                name: vkdFunc.name,
                _vkd: vkdFuncMetadata,
                description: vkdFunc.description,
                categoryParameter,
                seriesParameter,
                otherParameters
            });
        }
    }

    // Write the assistant variants
    for (const assistantMapItem of Object.entries(ASSISTANTS_MAP)) {
        const assistantKey = assistantMapItem[0];
        const assistantInfo = assistantMapItem[1];
        if (assistantKey.startsWith(ns)) {
            const variant = assistantKey === ns ? '' : assistantKey.slice(ns.length + 1);
            console.log(`Write AssistantMap: ${ns} ${variant}`);
            await AssistantMap.put({
                namespace: ns,
                variant,
                assistantId: assistantInfo.assistantId,
                vectorStore: assistantInfo.vectorStore,
            });
        }
    }
})();