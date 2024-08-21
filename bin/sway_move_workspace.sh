#!/usr/bin/env bash

set -Eeuo pipefail

# Should match the first part of any of the strings given by `swaymsg -t get_outputs | jq -r '.[].name'`
monitor_prefix="$1"

requested_display_name="$(swaymsg -t get_outputs | jq -r ".[] | select(.name | startswith(\"$monitor_prefix\")).name")"

swaymsg move workspace to "$requested_display_name"
