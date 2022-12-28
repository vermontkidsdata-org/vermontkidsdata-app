#!/bin/bash
set -e

curl https://api.qa.vtkidsdata.org/table/table/66?columns=Age,IFSP,IEP,504 >table-66.json

if [ `cat table-66.json | jq -r ".id"` != 66 ]; then
  exit 1
fi

if [ `cat table-66.json | jq -r ".metadata.config.tile"` != *Student support services* ]; then
  exit 1
fi
