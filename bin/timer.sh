#!/usr/bin/env bash

set -Eeuo pipefail

echo $$ > /tmp/timer.sh.pid

mins="$1"

TIMER_FILE="/tmp/timer.sh.txt"
SECONDS_LEFT=$((mins * 60))

while [ $SECONDS_LEFT -gt 0 ]; do
    MINUTES=$((SECONDS_LEFT / 60))
    SECONDS=$((SECONDS_LEFT % 60))
    printf "⏰%02d:%02d\n" $MINUTES $SECONDS > "$TIMER_FILE"
    sleep 1
    SECONDS_LEFT=$((SECONDS_LEFT - 1))
done

# Final message in Waybar
echo "" > "$TIMER_FILE"

# Send system notification
notify-send "⏰ Time's up!"

# Play notification sound
paplay /usr/share/sounds/freedesktop/stereo/complete.oga
