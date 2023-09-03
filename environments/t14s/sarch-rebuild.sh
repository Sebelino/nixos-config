#!/usr/bin/env bash

set -euo pipefail

set -x

cd "$HOME/misc/iso/sarch/"

sudo rm -r "$HOME/misc/iso/sarch/work"

sudo mkarchiso -v -w "$HOME/misc/iso/sarch/work" -o "$HOME/misc/iso/sarch/output" releng/
