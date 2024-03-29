#!/usr/bin/env bash

# Dependencies:
# xdotool
# /dev/shm

set -euo pipefail

button=$1

hScrollIndexBuffer="/dev/shm/mx_master_3_scroll_buffer"
smart_shift_buffer="/dev/shm/smart_shift_buffer"

# Create temporarily file if it doesn't already exist
if [ ! -f "$hScrollIndexBuffer" ]; then
    printf "L\n0\n" > "$hScrollIndexBuffer"
fi

# Horizontal scroll sensitivity reduction
hScrollModulo=2

temporizeHorizontalScroll() {

  local newDirection=$@;

  readarray -t buffer < "$hScrollIndexBuffer"
  local oldDirection=${buffer[0]}
  local value=${buffer[1]}

  if [ "$oldDirection" = "$newDirection" ]; then
    # increment
    value=$((value+1))
    value=$((value%$hScrollModulo))
  else
    # reset on direction change
    value=1
  fi

  # write buffer
  printf "$newDirection\n$value\n" > $hScrollIndexBuffer || value=0

  # temporize scroll
  if [ ${value} -ne 0 ]; then
      exit
  fi
}


case "$button" in

  "Scroll_L")
    temporizeHorizontalScroll "L"
    windowname=$(xdotool getwindowfocus getwindowname)
    smart_shift_buffer=$(cat /dev/shm/smart_shift_buffer)
    if [[ $smart_shift_buffer == *"1"* ]]; then
        if [[ $windowname == *"Chromium"* ]]; then
            xdotool key --clearmodifiers Control_L+Page_Up # Previous tab
        fi
    else
        if [[ $windowname == *"YouTube - Chromium"* ]]; then
            xdotool key --clearmodifiers Left # Rewind <<< 5 seconds
        fi
    fi
    ;;

  "Scroll_R")
    temporizeHorizontalScroll "R"
    windowname=$(xdotool getwindowfocus getwindowname)
    smart_shift_buffer=$(cat /dev/shm/smart_shift_buffer)
    if [[ $smart_shift_buffer == *"1"* ]]; then
        if [[ $windowname == *"Chromium"* ]]; then
            xdotool key --clearmodifiers Control_L+Page_Down # Next tab
        fi
    else
        if [[ $windowname == *"YouTube - Chromium"* ]]; then
            xdotool key --clearmodifiers Right # Rewind >>> 5 seconds
        fi
    fi
    ;;
esac
