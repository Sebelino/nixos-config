#!/usr/bin/env bash

set -euo pipefail

argument="$1"

get_app_name() {
    swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .app_id'
}

# Keycodes for ydotool can be found in /usr/include/linux/input-event-codes.h

kc_Hyper_L=12
kc_Shift_R=57
kc_F5=63
kc_Ctrl=58
kc_Space=51
kc_W=17
kc_T=33

case "$argument" in
    'Forward Button')
        app_name="$(get_app_name)"
        if [ "$app_name" = "chromium" ]; then
            ydotool key $kc_Ctrl:1 $kc_W:1 $kc_W:0 $kc_Ctrl:0
        elif [ "$app_name" = "anki" ]; then
            ydotool key $kc_Space:1 $kc_Space:0
        else
            notify-send --urgency=low 'Kill window'
            ydotool key $kc_Hyper_L:1 $kc_Shift_R:1 $kc_T:1 $kc_T:0 $kc_Shift_R:0 $kc_Hyper_L:0
        fi
    ;;
    'Middle Button')
        app_name="$(get_app_name)"
        if [ "$app_name" = "chromium" ]; then
            ydotool key $kc_F5:1 $kc_F5:0
        else
            notify-send --urgency=low 'Ineffective middle click'
        fi
    ;;
    *) notify-send --urgency=low 5 "Unrecognized argument to keycontrol.sh: $argument"
    ;;
esac
