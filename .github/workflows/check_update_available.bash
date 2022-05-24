#! /usr/bin/env bash
set -euo pipefail

INDEX_URL='https://ziglang.org/download/index.json'

current_version=$(jq -r '.master.version' index.json)
curl -s -o 'index.json' "$INDEX_URL"
latest_version=$(jq -r '.master.version' index.json)

echo "current: ${current_version}"
echo " latest: ${current_version}"

update_available=$([[ "$current_version" != "$latest_version" ]] && echo 'true' || echo 'false')
echo "::set-output name=update_available::${update_available}"
