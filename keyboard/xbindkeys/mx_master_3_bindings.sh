#!/usr/bin/env bash

# Dependencies:
# xdotool
# /dev/shm

set -euo pipefail

button=$1

hScrollIndexBuffer="/dev/shm/mx_master_3_scroll_buffer"

# Create temporarily file if it doesn't already exist
if [ ! -f "$hScrollIndexBuffer" ]; then
    printf "L\n0\n" > "$hScrollIndexBuffer"
fi

# Horizontal scroll sensitivity reduction
hScrollModulo=3

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
    notify-send --urgency=low "Scroll <<<"
    if [[ $(xdotool getwindowfocus getwindowname) == *"Google Chrome"* ]]; then
        echo hoy > /home/sebelino/HOY.txt
        xdotool key --clearmodifiers ctrl+shift+Tab # Previous tab
    fi
    ;;

  "Scroll_R")
    temporizeHorizontalScroll "R"
    notify-send --urgency=low "Scroll >>>"
    if [[ $(xdotool getwindowfocus getwindowname) == *"Google Chrome"* ]]; then
        xdotool key --clearmodifiers ctrl+Tab # Next tab
    fi
    ;;
esac
