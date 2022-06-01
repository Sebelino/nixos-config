#!/usr/bin/env bash

set -euo pipefail

content="$1"

outfile="/dev/shm/smart_shift_buffer"

echo "$content" > "$outfile"
