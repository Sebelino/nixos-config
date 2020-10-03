#!/bin/sh

xrandr
xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --primary \
       --output HDMI-1 --off \
       --output HDMI-2 --off \
       --output DP-1 --off \
       --output DP-2 --off \
       --verbose

pkill xmobar ; xmobar &
