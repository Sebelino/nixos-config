#!/usr/bin/env bash

set -euo pipefail

set -x

mkdir -p "$HOME/misc/iso/sarch"
cd "$HOME/misc/iso/sarch/"
git init
cp -r /usr/share/archiso/configs/releng releng
git add .
git commit -m "feat: Initial commit"
