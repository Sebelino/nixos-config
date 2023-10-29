#!/usr/bin/env bash

set -euo pipefail

unfocused_output="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused == false).name')"

swaymsg move workspace to "$unfocused_output"
