export interface ParameterBody {
    name: string, // "year",
    description: string, // string, // "The year of interest. Should be greater than or equal to 2017. If the request is for before 2017, request data\n          for 2017 and tell the user that the data is only available from 2017 onwards.",
    type: string, // "string",
    _vkd: {
        type: {
            "type": "category"
        }
    }
}

export interface FunctionBody {
    _vkd?: {
        chartType?: string, // "linechart",
        query?: string, // "number_babies:chart",
        defaultSeries?: string, // "Vermont"
    },
    name: string, // "get_babies_count",
    description?: string, // : "Return the actual number of babies born by year in Vermont.\n    \n    Returns a JSON object with two properties: a 'value' which is the value requested, and a 'url' which is the URL of a chart \n    that allows to user to explore the data in more detail.",
    categoryParameter: ParameterBody,
    seriesParameter?: ParameterBody,
    otherParameters?: ParameterBody[]
}
