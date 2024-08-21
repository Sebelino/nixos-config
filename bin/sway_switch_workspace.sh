#!/usr/bin/env bash

set -Eeuo pipefail

# Should match the first part of any of the strings given by `swaymsg -t get_outputs | jq -r '.[].name'`
monitor_prefix="$1"

workspace_number="$(swaymsg -t get_workspaces | jq ".[] | select(.output | startswith(\"$monitor_prefix\")) | select(.visible == true).num")"

swaymsg workspace "$workspace_number"
