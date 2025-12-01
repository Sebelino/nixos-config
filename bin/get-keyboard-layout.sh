#!/usr/bin/env bash

set -euo pipefail

# Get current keyboard layout for Waybar display
if [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    current_layout="$(swaymsg -t get_inputs | jq -r '.[].xkb_active_layout_name | select(. != null)' | sort -u)"
    if [ "$current_layout" = "Solemak" ]; then
        echo "🏴‍☠"
    elif [ "$current_layout" = "Swedish" ]; then
        echo "🇸🇪"
    else
        echo "???"
    fi
else
    # Fallback for X11
    out="$(setxkbmap -query | grep layout | awk '{print $2}')"
    if [ "$out" = "solemak" ]; then
        echo "SOL"
    elif [ "$out" = "sesebel" ]; then
        echo "SWE"
    else
        echo "???"
    fi
fi
