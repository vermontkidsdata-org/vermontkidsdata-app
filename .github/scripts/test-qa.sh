#!/bin/bash
set -e
set -x

curl https://api.qa.vtkidsdata.org/table/table/66?columns=Age,IFSP,IEP,504 >table-66.json

ID=`cat table-66.json | jq -r ".id"`
if [ "$ID" != 66 ]; then
  exit 1
fi

TITLE=`cat table-66.json | jq -r ".metadata.config.title"`
if [[ "$TITLE" != *"Student support services"* ]]; then
  exit 1
fi
