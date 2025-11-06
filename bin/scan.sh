#!/usr/bin/env bash

set -Eeuo pipefail

epson_device_substring=epkowa

devices_output="$(scanimage -f "%d|" | tr '|' '\n')"
device_name="$(echo "$devices_output" | grep "$epson_device_substring")"
out_path="$HOME/misc/scans/$(date '+%Y%m%d_%H%M%S').png"
scanimage --device-name "$device_name" --format=png > "$out_path"

echo "Scanned image saved to: $out_path"
