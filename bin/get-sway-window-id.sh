#!/usr/bin/env bash

set -Eeuo pipefail

# Extract all windows with their names and IDs
windows=$(swaymsg -t get_tree | jq -r '
  recurse(.nodes[]?, .floating_nodes[]?)
  | select(.name != null and .type == "con")
  | "\(.id)\t\(.name)"'
)

# Let the user select a window using fzf
selection=$(echo "$windows" | fzf --prompt="Select a window: ")

# If user made a selection, extract and print the ID
if [[ -n "$selection" ]]; then
  window_id=$(echo "$selection" | cut -f1)
  echo "$window_id"
fi
