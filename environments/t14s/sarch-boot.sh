#!/usr/bin/env bash

set -euo pipefail

set -x

isofile="$(find "$HOME/misc/iso/sarch/output/" -name '*.iso')"
run_archiso -i "$isofile"
