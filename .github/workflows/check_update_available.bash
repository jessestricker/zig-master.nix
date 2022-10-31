#! /usr/bin/env bash
set -euo pipefail

index_url='https://ziglang.org/download/index.json'

# get current version and date
current_version=$(jq -r ".version" index.json)
current_date=$(jq -r ".date" index.json)

# update index
curl -s "${index_url}" | jq ".master" > index.json

# get updated version and date
updated_version=$(jq -r ".version" index.json)
updated_date=$(jq -r ".date" index.json)

# check if update is available
if [[ ${current_version} != "${updated_version}" ]]; then
	update_available="true"
else
	update_available="false"
fi
echo "update_available=${update_available}" >> "${GITHUB_OUTPUT}"

# build GitHub step summary
{
	echo "| state   | version            | date            |"
	echo "| ------- | ------------------ | --------------- |"
	echo "| current | ${current_version} | ${current_date} |"
	echo "| updated | ${updated_version} | ${updated_date} |"
	echo ""
	echo "update available: __${update_available}__"
} >> "${GITHUB_STEP_SUMMARY}"
