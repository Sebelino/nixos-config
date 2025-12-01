#!/usr/bin/env bash

set -euo pipefail

if [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    current_layout="$(swaymsg -t get_inputs | jq -r '.[].xkb_active_layout_name | select(. != null)' | sort -u)"
    if [ "$current_layout" = "Solemak" ]; then
        new_layout="sesebel"
    else
        new_layout="solemak"
    fi
    swaymsg input type:keyboard xkb_layout "$new_layout"
    echo "$new_layout"
else
    out="$(setxkbmap -query | grep solemak)"
    if [ -z "$out" ]; then
        new_layout="solemak"
    else
        new_layout="sesebel"
    fi
    setxkbmap "$new_layout"
fi
