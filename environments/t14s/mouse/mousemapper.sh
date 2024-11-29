#!/usr/bin/env bash

# Dependencies:
# libinput (dep of sway)
# ~/nixos-config/keyboard/xbindkeys/mx_master_3_bindings.sh
# ~/nixos-config/keyboard/smart_shift_buffer.sh
# solaar (must be running in order to execute smart_shift_buffer.sh)

set -euo pipefail

# Workaround for an issue where swaymsg fails with "Unable to retrieve socket path" if invoked too early
echo "SWAYSOCK=$SWAYSOCK" # This daemon might fail here with "unbound variable SWAYSOCK", forcing a restart

mouse_name="MX Master 3"
smart_shift_buffer_path="/dev/shm/smart_shift_buffer"
script_dir="$(dirname "$(realpath "$0")")"
keycontrol_path="${script_dir}/keycontrol.sh"
mouse_device="$(libinput list-devices | grep "$mouse_name" -A1 | grep -o '/dev/input/event[0-9]*')"

echo "Found ${mouse_name} at ${mouse_device}"

if [ ! -f "$smart_shift_buffer_path" ]; then
    echo -n 0 > "$smart_shift_buffer_path"
fi

function execute() {
    event_name="$1"
    smart_shift_buffer="$(cat "$smart_shift_buffer_path")"
    if [[ "$smart_shift_buffer" == "0" ]]; then
        "$keycontrol_path" "Dumb Shift ${event_name}"
    elif [[ "$smart_shift_buffer" == "1" ]]; then
        "$keycontrol_path" "Smart Shift ${event_name}"
    fi
}

function process_wheel_event() {
    horizontal_value="$1"
    if [[ "$horizontal_value" = "0"* ]]; then
        # Assuming vertical scroll event, which we don't care about
        :
    elif [[ "$horizontal_value" = "-"* ]]; then
        execute "Scroll Left"
    else
        # Assuming it is a positive number
        execute "Scroll Right"
    fi
}

function process_button_event() {
    button="$1"
    state="$2"
    if [ "$button" = "BTN_LEFT" ]; then
        if [ "$state" = "pressed," ]; then
            execute "Press Left"
        elif [ "$state" = "released," ]; then
            execute "Release Left"
        else
            echo "Unexpected state $state" >> "$HOME/mousemapper.sh.log"
        fi
    else
        :
    fi
}

function parse_event_line() {
    action="$2"

    if [ "${action}" = "POINTER_SCROLL_WHEEL" ]; then
        # When scrolling the wheel horizontally, each line will look something like this:
        # event7   POINTER_SCROLL_WHEEL    101 +14.105s	vert 0.00/0.0 horiz -15.00/-120.0* (wheel)
        # shellcheck disable=SC2001
        horizontal_value="$(echo "$@" | sed 's/.*horiz \([^ ]\+\).*/\1/')"
        process_wheel_event "$horizontal_value"
    elif [ "${action}" = "POINTER_BUTTON" ]; then
        # When clicking the left button, each line will look something like this:
        # event7   POINTER_BUTTON          +3.756s	BTN_LEFT (272) pressed, seat count: 1
        # event7   POINTER_BUTTON          +3.836s	BTN_LEFT (272) released, seat count: 0
        button="$4"
        state="$6"
        process_button_event "$button" "$state"
    fi
}

while read -r line; do
    # shellcheck disable=SC2086
    parse_event_line ${line}
done < <(stdbuf -oL libinput debug-events --device "$mouse_device" & )
