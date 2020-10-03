#!/bin/sh

set -x

xrandr

laptop=eDP-1
left=DP-2  # Plug in Charger slot
right=DP-1 # Plug in slot closer to my body, smaller block-ish shape
# To rotate a display, add "--rotate right"

laptop_width=1920
laptop_height=1080
monitors_width=2560
monitors_height=1440

laptop_position_y="$(expr $monitors_width - $laptop_width / 2)"

xrandr \
    --output $left    --mode "${monitors_width}x${monitors_height}" --pos 0x0 \
    --output $right   --mode "${monitors_width}x${monitors_height}" --pos 2560x0 \
    --output $laptop  --mode "${laptop_width}x${laptop_height}" --pos "${laptop_position_y}x${monitors_height}" --primary \
    --verbose

pkill -9 -f xmobar
pkill -f xmobar ; xmobar -x1 &!
