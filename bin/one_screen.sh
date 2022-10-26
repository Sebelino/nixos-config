#!/usr/bin/env bash

set -euo pipefail

set -x

xrandr
xrandr --output eDP-1-1 --mode 1920x1080 --pos 0x0 --primary \
       --output eDP-1 --mode 1920x1080 --pos 0x0 --primary \
       --output HDMI-1 --off \
       --output HDMI-2 --off \
       --output HDMI-1-1 --off \
       --output HDMI-1-2 --off \
       --output HDMI-A-0 --off \
       --output DP-1 --off \
       --output DP-1-1 --off \
       --output DP-1-2 --off \
       --output DP-2 --off \
       --output DisplayPort-0 --off \
       --verbose

pkill xmobar ; xmobar &

# Adjust desktop background
"$HOME/.fehbg" &
