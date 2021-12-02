#!/usr/bin/env bash

set -euo pipefail

set -x

external_monitor_output=$(xrandr | grep "^\(DP-1\|DP-2\|HDMI-1\|HDMI-2\) connected" -A1)

second_monitor_name="$(echo $external_monitor_output | head -n1 | cut -d' ' -f1)"
second_monitor_resolution="$(echo "$external_monitor_output" | tail -1 | awk '{print $1}')"

SECOND_MONITOR_NAME="$second_monitor_name"
SECOND_MONITOR_RESOLUTION="$second_monitor_resolution"

#SECOND_MONITOR_NAME="HDMI-1"
#SECOND_MONITOR_RESOLUTION="1920x1080"

#SECOND_MONITOR_NAME="DP-2"
#SECOND_MONITOR_RESOLUTION="2560x1440"

second_monitor_height="$(echo $SECOND_MONITOR_RESOLUTION | cut -d'x' -f2)"

xrandr
xrandr --output eDP-1 --mode 1920x1080 --pos "0x${second_monitor_height}" --primary \
       --output "$SECOND_MONITOR_NAME" --mode "$SECOND_MONITOR_RESOLUTION" --pos 0x0 \
       --verbose
