#!/usr/bin/env bash

set -Eeuo pipefail

external_display="$(swaymsg -t get_outputs | jq -r '.[].name' | grep -v eDP-1 | head -n1)"
echo "External display: $external_display"
wl-present mirror eDP-1 --fullscreen-output "$external_display" --fullscreen
