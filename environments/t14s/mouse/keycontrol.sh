#!/usr/bin/env bash

set -euo pipefail

argument="$1"

# Keycodes for ydotool can be found in /usr/include/linux/input-event-codes.h

kc_Hyper_L=12
kc_Shift_R=57
key_T=33
key_F5=63

case "$argument" in
    'Forward Button')
        notify-send --urgency=low 'Kill window'
        # Hyper_L + Shift_R + t
        ydotool key $kc_Hyper_L:1 $kc_Shift_R:1 $key_T:1 $key_T:0 $kc_Shift_R:0 $kc_Hyper_L:0
    ;;
    'Middle Button')
        app_name="$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .app_id')"
        if [ "$app_name" = "chromium" ]; then
            # F5
            ydotool key $key_F5:1 $key_F5:0
        else
            notify-send --urgency=low 'Ineffective middle click'
        fi
    ;;
    *) notify-send --urgency=low 5 "Unrecognized argument to keycontrol.sh: $argument"
    ;;
esac
