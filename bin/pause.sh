#!/usr/bin/env bash

set -Eeuo pipefail

notify-send "⏸️ Pause timer toggled."

PAUSE_FILE="/tmp/timer.sh.pause"

if [ -f "$PAUSE_FILE" ]; then
    rm -f "$PAUSE_FILE"
else
    touch "$PAUSE_FILE"
fi
