#!/usr/bin/env bash

set -Eeuo pipefail

addon_path="$(find ~/.thunderbird/ -name owl@beonex.com.xpi)"

owl_original_path=/tmp/owl.xpi

# Make copy, but only if it is not already there
if [ ! -f "$owl_original_path" ]; then
    cp "$addon_path" "$owl_original_path"
fi

tempdir="$(mktemp -d)"
cd "$tempdir"

cp "$owl_original_path" .
unzip "$(basename "$owl_original_path")" -d temp
cd temp

git init
git add .
git config user.email "dummy@example.com"
git config commit.gpgsign false
git commit -m "temp"

sed -i '/showWarningBar(ticket);/d' ui/license-bar/license-bar.js
sed -i '/if (ticket.expiredIn < kOld) {/i\  return;' license.js

git diff | bat

zip -q -r ../edited.zip ./*
cp ../edited.zip "$addon_path"

cd "$HOME"
rm -rf "$tempdir"
