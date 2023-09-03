#!/usr/bin/env bash

set -euo pipefail

set -x

cd "$HOME/misc/iso/sarch/"
isofile="$(ls ./output/*.iso)"
run_archiso -i "$isofile"
