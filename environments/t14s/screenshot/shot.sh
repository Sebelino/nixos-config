#!/usr/bin/env bash

set -Eeuo pipefail

tmpfile="/tmp/screenshot.ppm"
grim -g "$(slurp)" -t ppm - > "$tmpfile"
outdir="$HOME/misc/screenshots"
outfile="$outdir/$(date "+%Y-%m-%d_%H-%M-%S").png"
satty --filename - --fullscreen --early-exit --save-after-copy --output-filename "$outfile" < "$tmpfile"
