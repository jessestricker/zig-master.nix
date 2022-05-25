#! /usr/bin/env bash
set -euo pipefail

INDEX_URL='https://ziglang.org/download/index.json'

current_version=$(jq -r '.version' index.json)
current_date=$(jq -r '.date' index.json)

curl -s "$INDEX_URL" | jq '.master' > index.json

updated_version=$(jq -r '.version' index.json)
updated_date=$(jq -r '.date' index.json)

update_available=$([[ "$current_version" != "$updated_version" ]] && echo 'true' || echo 'false')
echo "::set-output name=update_available::${update_available}"

echo "| state   | version            | date            |" >> $GITHUB_STEP_SUMMARY
echo "| ------- | ------------------ | --------------- |" >> $GITHUB_STEP_SUMMARY
echo "| current | ${current_version} | ${current_date} |" >> $GITHUB_STEP_SUMMARY
echo "| updated | ${updated_version} | ${updated_date} |" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "update available: __${update_available}__" >> $GITHUB_STEP_SUMMARY
