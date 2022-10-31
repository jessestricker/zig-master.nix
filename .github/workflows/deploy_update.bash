#! /usr/bin/env bash
set -euo pipefail

version=$(jq -r ".version" index.json)
date=$(jq -r ".date" index.json)
tag_name="v${version}"

git commit -a -m "update: ${tag_name} (${date})"
git tag "${tag_name}"
git push origin HEAD "refs/tags/${tag_name}"
