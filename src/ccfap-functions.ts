
export const getCCFAPByYearFunction = {
    "_vkd": {
        "chartType": "columnchartfiltered",
        "query": "ccfap_filtered:chart",
        "defaultSeries": "Vermont"
    },
    "name": "get_ccfap_by_year",
    "categoryParameter": {
        "name": "year_filter",
        "description": "The year of interest. You must always pass this parameter to the function. Should be greater than or equal to 2017. If the request is for before 2017, request data\n          for 2017 and tell the user that the data is only available from 2017 onwards.",
        "type": "string",
        "_vkd": {
            "type": "category"
        }
    },
    "seriesParameter": {
        "name": "county_filter",
        "description": "The specific geography in Vermont. This can either be a county (as enumerated in the parameter definition), or Vermont-wide. You must always pass this parameter to the function. If the user does not specify a county that closely matches one in the enumeration, use 'Vermont' for this parameter value.",
        "type": "string",
        "enum": [
            "Addison", "Bennington", "Caledonia", "Essex", "Franklin", "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington", "windham", "Windsor"
        ],
        "_vkd": {
            "type": "series"
        }
    },
    "description": "Find the number of child care providers per year in Vermont. The user can also request a specific County in Vermont, a specific Program Type, and a specific Tier level. All three of these are optional for the user to enter, but You must always pass all four parameters to the function. Af the user does not specify any or all, use '-- All --' for the associated parameter.\n    \n    Returns a JSON object with two properties: a 'value' which is the value requested, and a 'url' which is the URL of a chart \n    that allows to user to explore the data in more detail.",
    "otherParameters": [{
        "name": "program_filter",
        "description": "The program type of interest. This can either be one of the program types (as enumerated in the parameter definition), or the user can omit it. You must always pass this parameter to the function. The user may specify something that is not quite the program type in the enumeration, but it could be a prefix: so, if the user specifies 'licensed', that should be equivalent to 'Licensed FCCH'. If the user does not specify a program type that closely matches one in the enumeration, use '-- All --' for this parameter value.",
        "type": "string",
        "enum": [
            "Afterschool Child Care Program", "CBCCPP", "CBCCPP - Non-Recurring", "LECC", "Licensed FCCH", "Registered FCCH"
        ]
    }, {
        "name": "stars_filter",
        "description": "The program tier level (also called STARS level) to limit the providers by. This can either be one of the tier levels (as enumerated in the parameter definition), or the user can omit it. You must always pass this parameter to the function. If the user does not specify a tier level that closely matches one in the enumeration, use '-- All --' for this parameter value.",
        "type": "string",
        "enum": [
            "1 Star", "2 Star", "3 Star", "4 Star", "5 Star", "4 or 5 Star"
        ]
    }
  ]
};