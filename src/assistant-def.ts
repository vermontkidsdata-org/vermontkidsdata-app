import OpenAI from "openai";
import { FILE_MAP } from "./ai-utils";

export type VKDAssistant = OpenAI.Beta.Assistants.Assistant;

export type VKDFunction = OpenAI.FunctionDefinition & {
  _vkd?: {
    query?: string,
    chartType?: string, // If something other than the default chart is wanted, e.g. 'stackedcolumnchart'
    urlPath?: string,   // If you want to completely replace the URL path
    defaultSeries?: string, // If you want to set a default series name, this is usually needed for charts that display a value for "Vermont"
  }
}

export type VKDFunctionTool = {
  type: "function",
  function: VKDFunction,
};

const SERIES_PARAMETER = "series";
const CATEGORY_PARAMETER = "category";

function YEAR_PARAMETER({ minYear, type }: { minYear?: number, type?: string }): OpenAI.FunctionParameters {
  const min = minYear ?? 2018;
  return {
    type: "string",
    description: `The year of interest. Should be greater than or equal to ${min}. If the request is for before ${min}, request data
          for ${min} and tell the user that the data is only available from ${min} onwards.`,
    ...(type ? {
      _vkd: {
        type
      }
    } : {})
  };
}

function SCHOOL_YEAR_PARAMETER({ minYear, type }: { minYear?: number, type?: string }): OpenAI.FunctionParameters {
  const min = minYear ?? 2017;
  return {
    type: "string",
    description: `The school year, which should be a string of the form 'SSSS-EEEE' where SSSS is the starting school year (e.g. 2020) 
      and EEEE is the ending school year (e.g. 2021). The ending year should always be one greater than the starting year.
      Should be greater than or equal to ${min}. If the request is for before ${min}, request data
      for ${min} and tell the user that the data is only available from ${min} onwards.`,
    ...(type ? {
      _vkd: {
        type
      }
    } : {})
  }
}

const functionDefs: VKDFunctionTool[] = [{
  type: "function",
  function: {
    name: "children_in_poverty_under_12_all-chart",
    _vkd: {
      query: 'children_in_poverty_under_12_all:chart',
      urlPath: 'linechart/children_in_poverty_under_12:chart',
    },
    description: `Determine percent of children in poverty within Vermont for a given year. It returns the percent 
    of children in poverty for a certain year. It can give the information either for a particular AHS region in Vermont, or across the
    entire state. Returns a JSON object with two properties: a 'value' which is the value requested, and a 'url' which is the URL of
    a chart that allows to user to explore the data in more detail.`,
    parameters: {
      type: "object",
      properties: {
        location: {
          type: "string",
          description: `The location, either a Building Bright Futures region within Vermont, or across the entire state. Should either be the region name 
          (e.g. Chittendon) or the word 'Vermont' for poverty across the entire state. It returns a JSON object with four fields: 
          "value" which gives the requested value, "url" which gives a URL for a dataset you can reference for more information, 
          "geography" which is the geography the value is for, and "year" which is the year the data is returned for. The geography 
          and year might be different from what you requested if the function can't return the value for the requested geography or year.`,
          enum: [
            "Addison",
            "Bennington",
            "Caledonia and Southern Essex",
            "Central Vermont",
            "Chittenden",
            "Franklin Grand Isle",
            "Lamoille Valley",
            "Northern Windsor and Orange",
            "Orleans and Northern Essex",
            "Rutland",
            "Southeast Vermont",
            "Springfield",
            "Vermont"
          ],
          _vkd: {
            type: SERIES_PARAMETER,
          }
        },
        year: YEAR_PARAMETER({ minYear: 2017, type: CATEGORY_PARAMETER }),
      },
      required: [
        "location",
        "type",
        "year"
      ]
    }
  }
},
{
  type: "function",
  function: {
    name: "avgbenefit_3squares_vt-chart",
    description: `Determine the average '3 squares' benefit for an individual or household within Vermont. Returns a JSON object 
    with two properties: a 'value' which is the value requested, and a 'url' which is the URL of a chart that allows to user to 
    explore the data in more detail.`,
    parameters: {
      type: "object",
      properties: {
        group: {
          type: "string",
          description: "Whether the user is asking about an individual or an entire household (also referred to as a 'family').",
          enum: [
            "individual",
            "household"
          ],
          _vkd: {
            type: SERIES_PARAMETER,
          }
        },
        year: YEAR_PARAMETER({ minYear: 2017, type: CATEGORY_PARAMETER }),
      },
      required: [
        "group"
      ]
    }
  }
},
{
  type: "function",
  function: {
    name: "iep-chart",
    description: `Find the total number of kids in Vermont by school year who have an IEP, which stands for Individualized Education Program. 
    When students are identified as having an educational disability and require special education services to meet their unique learning needs, 
    they are provided an Individualized Education Program (IEP) which is overseen by local public school divisions. An IEP is comprised of 
    specially designed instruction that involves adapting the content, methodology, or delivery of instruction to address the needs of the 
    student and accommodations, modifications, and other supplementary aids and services to ensure their access to the general curriculum so 
    the child can meet the educational standards that apply to all children in the state. 
    
    Returns a JSON object with two properties: a 'value' which is the value requested, and a 'url' which is the URL of a chart that allows
    to user to explore the data in more detail.`,
    parameters: {
      type: "object",
      properties: {
        year: SCHOOL_YEAR_PARAMETER({ minYear: 2017, type: CATEGORY_PARAMETER }),
        type: {
          type: "string",
          description: "The type of data being requested. This should always be the constant value 'IEP'.",
          enum: ["IEP"],
          _vkd: {
            type: SERIES_PARAMETER,
          }
        }
      },
      required: ["year", "type"]
    }
  }
}, {
  type: "function",
  function: {
    name: "get_idea_by_year",
    description: `Return the number of children in Vermont who receive early intervention services under IDEA. The Individuals with 
    Disabilities Education Act (IDEA) is a federal law that makes available a free appropriate public education (FAPE) to eligible 
    children with disabilities throughout the nation and ensures special education and related services to those children. Infants 
    and toddlers, birth through age 2, with disabilities and their families receive early intervention services under IDEA Part C. 
    Children and youth ages 3 through 21 receive special education and related services under IDEA Part B. 
    
    Returns a JSON object with two properties: a 'value' which is the value requested, and a 'url' which is the URL of a chart 
    that allows to user to explore the data in more detail.`,
    _vkd: {
      query: "idea_bc:chart_by_year",
      chartType: 'stackedcolumnchart',
    },
    parameters: {
      type: "object",
      properties: {
        part: {
          type: "string",
          description: "The part of the IDEA act of interest. This can be determined by the age of the children of interest.",
          enum: [
            "IDEA B",
            "IDEA C"
          ],
          _vkd: {
            type: SERIES_PARAMETER,
          }
        },
        year: YEAR_PARAMETER({ minYear: 2018, type: CATEGORY_PARAMETER }),
      },
      required: [
        "part",
        "year"
      ]
    }
  }
}, {
  type: "function",
  function: {
    name: "get_babies_count",
    description: `Return the number of babies born by year in Vermont.
    
    Returns a JSON object with two properties: a 'value' which is the value requested, and a 'url' which is the URL of a chart 
    that allows to user to explore the data in more detail.`,
    _vkd: {
      query: "number_babies:chart",
      chartType: 'linechart',
      defaultSeries: 'Vermont',
    },
    parameters: {
      type: "object",
      properties: {
        year: YEAR_PARAMETER({ minYear: 2017, type: CATEGORY_PARAMETER }),
      },
      required: [
        "part",
        "year"
      ]
    }
  }
}];

export type LimitedAssistantDef = Omit<VKDAssistant, "object" | "id" | "created_at">;

export const assistantDef: LimitedAssistantDef = {
  // id: "asst_nJKMeBh1KxrqsrL9jGheMcHX",
  // object: "assistant",
  // created_at: 1717338669,
  name: "Vermont Kids Data Assistant with Functions",
  description: 'Updated Vermont Kids Data Assistant with functions via MLOps',
  model: "gpt-4o",
  instructions: `You're a Vermont Early Childhood assistant, helping to provide insights and analyis of Vermont's young children based on both the yearly 
  "How Are Vermont's Young Children" or "State of Vermont's Children" reports and the online indicators provided by the website www.vermontkidsdata.org. You
  also have a set of functions that can provide specific data points from these reports. If information is available either from a report or from a function,
  you should favor the function.

  **Instructions:**
  
  You are tasked with analyzing and summarizing early childhood data.  When you are asked a question you will refer to the How Are Vermont's Young Children reports.
  These reports are text files prefaced by how_are_vermonts_young_children and then the year the report was published, for example 
  how_are_vermonts_young_children_2023.txt for the report published in the year 2023.
  
  You will start your analysis by summarizing any data from the most recent report that has been published for the subject asked about.  If there is no specific 
  subject or area of interest asked about, you will try to summarize the overall state of Vermont's young children.
  
  Next you will try to compare this to similar data from previous reports, providing any meaningful insights about trends in the data.  This will include both 
  positive trends or trends that show reason for concern. Assume that your target audience is Vermont legislators and policy makers.
  
  When you give references to uploaded files in the vector store, you should give them in your response as markdown links, using the following JSON object to 
  map file names given in the "file" property to links given in the "url" property. There is also a "name" property that you can use to give a more human-readable
  name for the file. Here is the JSON object you should use:
  
  ` + JSON.stringify(FILE_MAP) + `

  When you give links to the vector store files or an external URL returned from a function, put the markdown link at the end of the sentence. If the same URL comes 
  more than once in a single sentence, only show one link at the end of the sentence.

  Use the previous How Are Vermont's Young Children reports as a guide to the style of writing in your summaries and narratives, except 
  your responses always need to cite their source using markdown-format links to the files you use from the vector store. Use Markdown 
  as the format of your responses. This includes citations, bullet lists, headings, links, and paragraph separation.`,
  tools: [
    {
      type: "code_interpreter"
    },
    {
      type: "file_search"
    },
    ...(functionDefs),
  ],
  top_p: 1,
  temperature: 1,
  tool_resources: {
    file_search: {
      vector_store_ids: [], // Need to add value for the environment
    },
    code_interpreter: {
      file_ids: []
    }
  },
  metadata: {},
  response_format: "auto"
};

/**
 * Need to remove the _vkd properties because the OpenAI API chokes on them.
 * @param obj assistant definition
 * @returns assistant definition with _vkd properties removed
 */
export function removeVkdProperties(obj: any): any {
  if (typeof obj === "object" && obj !== null) {
    if (Array.isArray(obj)) {
      // Recurse through array elements
      return obj.map((item) => removeVkdProperties(item));
    } else {
      // Recurse through object keys
      const newObj: any = {};
      for (const key in obj) {
        if (key !== "_vkd") {
          newObj[key] = removeVkdProperties(obj[key]);
        }
      }
      return newObj;
    }
  } else {
    return obj;
  }
}

export interface AssistantInfo {
  assistantId: string;
  vectorStore: string;
}

/**
 * Keep track of assistant IDs and vector store IDs by VKD_ENVIRONMENT.
 */
export const ASSISTANTS_MAP: Record<string, AssistantInfo> = {
  qa: {
    assistantId: 'asst_oTyK60tswWI1TYECBvng1lfn',
    vectorStore: 'vs_iViHvHye2QTf3i1D2ivNuLkM',
  },
  prod: {
    assistantId: 'asst_grARLJVpFhQS7H5decnIbuP0',
    vectorStore: 'vs_lI4uWc5bPp1bWnErFaIZbQ0l'
  },
  sandbox: {
    assistantId: 'asst_f0j3Q0YM8vmzBRMXHaCBLwp2',
    vectorStore: 'vs_LPTIjaUcvRbgIKztzD7MdwIJ',
  }
}

/**
 * Get information on the assistant.
 * @param ns VKD_ENVIRONMENT to get info for
 * @param clean if passed and true, remove _vkd properties from the assistant definition. Normally you don't pass this; this is for MLOps.
 * @returns assistant ID, vector store ID, and assistant definition
 */
export function getAssistantInfo(ns: string, clean?: boolean): {
  assistantId: string,
  vectorStore: string,
  assistant: LimitedAssistantDef
} {
  const assistantInfo = ASSISTANTS_MAP[ns];

  // Verify the format if clean is passed
  if (clean) {
    // Make sure each function has a category parameter and either a series parameter or defaultSeries value
    for (const tool of assistantDef.tools) {
      if (tool.type !== "function") {
        continue;
      }

      console.log(`Verifying function ${tool.function.name}`);

      const has = {
        category: false,
        series: false,
      };
      for (const param of Object.values(tool.function.parameters?.properties ?? {})) {
        if ((param as any)._vkd?.type === CATEGORY_PARAMETER) {
          has.category = true;
        }
        if ((param as any)._vkd?.type === SERIES_PARAMETER) {
          has.series = true;
        }
      }

      if (!has.category || !has.series && !(tool.function as VKDFunction)._vkd?.defaultSeries) {
        throw new Error(`Function ${tool.function.name} is missing a category parameter or a series parameter/defaultSeries.`);
      }
    }
  }

  // Seek out and destroy the _vkd properties in the nested assistantDef object
  const def = (clean ? removeVkdProperties(assistantDef) : assistantDef) as LimitedAssistantDef;
  def.tool_resources?.file_search?.vector_store_ids?.push(assistantInfo.vectorStore);
  def.name += ` (${ns})`;

  return {
    ...assistantInfo,
    assistant: def
  };
}
