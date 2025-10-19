#!/usr/bin/env bash

set -Eeuo pipefail

echo $$ > /tmp/timer.sh.pid

mins="$1"
mode="${2:-}"
TIMER_FILE="/tmp/timer.sh.txt"
PAUSE_FILE="/tmp/timer.sh.pause"
SECONDS_LEFT=$((mins * 60))

if [ -f "$PAUSE_FILE" ]; then
  notify-send "⚠ Error: Timer is already running (and paused)."
  paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
  exit 1
fi

if [ "$mode" == "--skip-second-beep" ]; then
    notify-send "⏰ Timer set for $mins minutes (no second beep)."
elif [ "$mode" == "" ]; then
    notify-send "⏰ Timer set for $mins minutes."
else
    notify-send "⚠ Invalid flag: ${mode}."
    paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
    exit 1
fi

while [ $SECONDS_LEFT -gt 0 ]; do
    if [ -f "$PAUSE_FILE" ]; then
        printf "⏸️%02d:%02d\n" $MINUTES $SECONDS > "$TIMER_FILE"
    fi
    while [ -f "$PAUSE_FILE" ]; do
        sleep 1
    done

    MINUTES=$((SECONDS_LEFT / 60))
    SECONDS=$((SECONDS_LEFT % 60))
    printf "⏰%02d:%02d\n" $MINUTES $SECONDS > "$TIMER_FILE"
    sleep 1
    SECONDS_LEFT=$((SECONDS_LEFT - 1))
done

echo "" > "$TIMER_FILE"
notify-send "⏰ Time's up!"
paplay /usr/share/sounds/freedesktop/stereo/complete.oga # Indicates soft deadline

if [ "$mode" != "--skip-second-beep" ]; then
    sleep 7
    paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga # Indicates hard deadline
fi
