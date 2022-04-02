import argparse
import json

with open ('datasets.json', "r", encoding='utf-8') as f:
    datasets = json.loads (f.read())["dataset"]

for dataset in datasets:
    c_vintage = dataset.get("c_vintage") or 'null'
    c_dataset = dataset["c_dataset"]
    print(f"insert into census_datasets (vintage, dataset) values ({c_vintage}, '{'/'.join(c_dataset)}');")