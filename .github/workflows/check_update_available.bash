#! /usr/bin/env bash
set -euo pipefail

INDEX_URL='https://ziglang.org/download/index.json'

# get current version and date
current_version=$(jq -r '.version' index.json)
current_date=$(jq -r '.date' index.json)

# update index
curl -s "$INDEX_URL" | jq '.master' > index.json

# get updated version and date
updated_version=$(jq -r '.version' index.json)
updated_date=$(jq -r '.date' index.json)

# check if update is available
update_available=$([[ $current_version != "$updated_version" ]] && echo 'true' || echo 'false')
echo "update_available=${update_available}" >> $GITHUB_OUTPUT

# build GitHub step summary
echo "| state   | version            | date            |" >> $GITHUB_STEP_SUMMARY
echo "| ------- | ------------------ | --------------- |" >> $GITHUB_STEP_SUMMARY
echo "| current | ${current_version} | ${current_date} |" >> $GITHUB_STEP_SUMMARY
echo "| updated | ${updated_version} | ${updated_date} |" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "update available: __${update_available}__" >> $GITHUB_STEP_SUMMARY
