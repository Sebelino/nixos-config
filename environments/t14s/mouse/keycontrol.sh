#!/usr/bin/env bash

# Dependencies:
# ydotool
# sway
# jq
# libnotify (dep of solaar, drawio-desktop)

set -euo pipefail

argument="$1"

get_app_name() {
    swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | if .app_id != null then .app_id else .window_properties.instance end'
}

# Keycodes for ydotool can be found in /usr/include/linux/input-event-codes.h
# Note that you need to specify the keycodes for the actual physical keys.
# Meaning, if you change your keyboard layout, you will need to change the values below.

kc_Hyper_L=12 # KEY_MINUS
kc_Shift_R=57 # KEY_SPACE
kc_F5=63      # KEY_F5
kc_Ctrl=58    # KEY_CAPSLOCK
kc_Space=51   # KEY_COMMA
kc_W=17       # KEY_W
kc_T=33       # KEY_F

case "$argument" in
    'Forward Button')
        app_name="$(get_app_name)"
        if [ "$app_name" = "chromium" ]; then
            # Close tab
            ydotool key $kc_Ctrl:1 $kc_W:1 $kc_W:0 $kc_Ctrl:0
        elif [ "$app_name" = "anki" ]; then
            # Click "Show Answer"
            ydotool key $kc_Space:1 $kc_Space:0
        else
            # Kill window
            notify-send --urgency=low 'Kill window'
            ydotool key $kc_Hyper_L:1 $kc_Shift_R:1 $kc_T:1 $kc_T:0 $kc_Shift_R:0 $kc_Hyper_L:0
        fi
    ;;
    'Middle Button')
        app_name="$(get_app_name)"
        if [ "$app_name" = "chromium" ]; then
            # Refresh page
            ydotool key $kc_F5:1 $kc_F5:0
        else
            notify-send --urgency=low 'Ineffective middle click'
        fi
    ;;
    *) notify-send --urgency=low 5 "Unrecognized argument to keycontrol.sh: $argument"
    ;;
esac
