#!/usr/bin/env bash

# Dependencies:
# ydotool
# sway
# jq
# libnotify (dep of solaar, drawio-desktop)

set -euo pipefail

argument="$1"

get_focused_app() {
    swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true)'
}

youtube_seek() {
    inertia_factor="$1"
    direction="$2"
    seek_buffer="/dev/shm/youtube_seek_buffer"
    if [ ! -f "$seek_buffer" ]; then
        echo -n 1 > "$seek_buffer"
        return # We incremented the value from 0 to 1, so let's exit
    fi
    current_value="$(cat "/dev/shm/youtube_seek_buffer")"
    if [ "$current_value" = "0" ]; then
        ydotool key "$direction:1" "$direction:0"
    fi
    echo -n "$(( (current_value + 1) % inertia_factor ))" > "$seek_buffer"
}

jq_app_id='if .app_id != null then .app_id else .window_properties.instance end'

# Keycodes for ydotool can be found in /usr/include/linux/input-event-codes.h
# Note that you need to specify the keycodes for the actual physical keys.
# Meaning, if you change your keyboard layout, you will need to change the values below.

kc_Hyper_L=12 # KEY_MINUS
kc_Tab=42     # KEY_LEFTSHIFT
kc_Shift_R=57 # KEY_SPACE
kc_F5=63      # KEY_F5
kc_Ctrl=58    # KEY_CAPSLOCK
kc_Space=51   # KEY_COMMA
kc_W=17       # KEY_W
kc_T=33       # KEY_F
kc_M=50       # KEY_M
kc_Left=105   # KEY_LEFT
kc_Right=106  # KEY_RIGHT

case "$argument" in
    'Forward Button')
        app_name="$(get_focused_app | jq -r "$jq_app_id")"
        if [ "$app_name" = "chromium" ]; then
            # Close tab
            ydotool key $kc_Ctrl:1 $kc_W:1 $kc_W:0 $kc_Ctrl:0
        elif [ "$app_name" = "anki" ]; then
            # Click "Show Answer"
            ydotool key $kc_Space:1 $kc_Space:0
        elif [ "$app_name" = "teams-for-linux" ]; then
            # Mute mic
            ydotool key $kc_Ctrl:1 $kc_Shift_R:1 $kc_M:1 $kc_M:0 $kc_Shift_R $kc_Ctrl
        else
            # Kill window
            notify-send --urgency=low 'Kill window'
            ydotool key $kc_Hyper_L:1 $kc_Shift_R:1 $kc_T:1 $kc_T:0 $kc_Shift_R:0 $kc_Hyper_L:0
        fi
    ;;
    'Middle Button')
        app_name="$(get_focused_app | jq -r "$jq_app_id")"
        if [ "$app_name" = "chromium" ]; then
            # Refresh page
            ydotool key $kc_F5:1 $kc_F5:0
        else
            notify-send --urgency=low 'Ineffective middle click'
        fi
    ;;
    'Dumb Shift Scroll Left')
        # Let go of the Smart Shift button while scrolling left
        app_data="$(get_focused_app)"
        app_name="$(echo "$app_data" | jq -r "$jq_app_id")"
        if [ "$app_name" = "chromium" ]; then
            app_title="$(echo "$app_data" | jq -r ".name")"
            if [[ "$app_title" == *" YouTube"* ]]; then
                youtube_seek 3 $kc_Left
            fi
        fi
    ;;
    'Dumb Shift Scroll Right')
        # Let go of the Smart Shift button while scrolling right
        app_data="$(get_focused_app)"
        app_name="$(echo "$app_data" | jq -r "$jq_app_id")"
        if [ "$app_name" = "chromium" ]; then
            app_title="$(echo "$app_data" | jq -r ".name")"
            if [[ "$app_title" == *" YouTube"* ]]; then
                youtube_seek 3 $kc_Right
            fi
        fi
    ;;
    'Smart Shift Scroll Left')
        # Hold the Smart Shift button while scrolling left
        app_name="$(get_focused_app | jq -r "$jq_app_id")"
        if [ "$app_name" = "chromium" ]; then
            ydotool key $kc_Ctrl:1 $kc_Shift_R:1 $kc_Tab:1 $kc_Tab:0 $kc_Shift_R:0 $kc_Ctrl:0
        else
            notify-send --urgency=low 'Ineffective mode shift left scroll'
        fi
    ;;
    'Smart Shift Scroll Right')
        # Hold the Smart Shift button while scrolling right
        app_name="$(get_focused_app | jq -r "$jq_app_id")"
        if [ "$app_name" = "chromium" ]; then
            ydotool key $kc_Ctrl:1 $kc_Tab:1 $kc_Tab:0 $kc_Ctrl:0
        else
            notify-send --urgency=low 'Ineffective mode shift right scroll'
        fi
    ;;
    *) notify-send --urgency=low 5 "Unrecognized argument to keycontrol.sh: $argument"
    ;;
esac
