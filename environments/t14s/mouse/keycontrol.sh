#!/usr/bin/env bash

set -euo pipefail

argument="$1"

# Keycodes for ydotool can be found in /usr/include/linux/input-event-codes.h

case "$argument" in
    killwindow)
        notify-send --urgency=low 'Kill window'
        # Hyper_L + Shift_R + t
        ydotool key 12:1 57:1 33:1 33:0 57:0 12:0
    ;;
    *) notify-send --urgency=low 5 "Unrecognized argument to keycontrol.sh: $argument"
    ;;
esac
