import argparse
import json
import sys

from attr import attributes

parser = argparse.ArgumentParser()
parser.add_argument('--file', required=True, help='input file, JSON')
args = parser.parse_args()

    #   "S1601_C05_010EA": {
    #     "label": "Annotation of Estimate!!Speak English  less than \"very well\"!!Percent of specified language speakers!!Population 5 years and over!!SPEAK A LANGUAGE OTHER THAN ENGLISH!!Other Indo-European languages!!18 to 64 years old",
    #     "concept": "LANGUAGE SPOKEN AT HOME",
    #     "predicateType": "string",
    #     "group": "S1601",
    #     "limit": 0,
    #     "predicateOnly": true
    #   },

with open (args.file, "r", encoding='utf-8') as f:
    variables = json.loads (f.read())["variables"]

def calc_base_var(var):
    if var.endswith('EA') or var.endswith('MA'):
        return f'{var[0:len(var)-2]}E'
    elif var.endswith('M'):
        return f'{var[0:len(var)-1]}E'
    else:
        print(f'unknown var format {var}')
        sys.exit(1)

variablesRef = {}
for variable in variables:
    if (variable.endswith('E')):
        variablesRef[variable] = variables[variable]
        variablesRef[variable]['attributes'] = ''

for variable in variables:
    if (not variable.endswith('E')):
        basevar = calc_base_var(variable)
        basevarinfo = variablesRef[basevar]
        if basevarinfo['attributes'] != '':
            basevarinfo['attributes'] += ','
        basevarinfo['attributes'] += variable

for variable in variablesRef:
    concept = variablesRef[variable]['concept']
    label = variablesRef[variable]['label'].replace("'", r"\'")
    group = variablesRef[variable]['group']
    predicateType = variablesRef[variable]['predicateType']
    limit = variablesRef[variable]['limit']
    attributes = variablesRef[variable]['attributes']
    print(f"insert into acs_variables (`tableType`, `variable`, `concept`, `label`, `predicateType`, `group`, `limit`, `attributes`, `year`) values ('subject', '{variable}', '{concept}', '{label}', '{predicateType}', '{group}', '{limit}', '{attributes}', 2016);")
