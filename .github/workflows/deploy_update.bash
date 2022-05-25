#! /usr/bin/env bash
set -euo pipefail

latest_version=$(jq -r '.version' index.json)
tag_name="v${latest_version}"

git commit -a -m "update: ${tag_name}"
git tag "$tag_name"
git push origin HEAD "refs/tags/${tag_name}"
