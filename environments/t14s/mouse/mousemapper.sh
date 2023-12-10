#!/usr/bin/env bash

# Dependencies:
# libinput (dep of sway)
# ~/nixos-config/keyboard/xbindkeys/mx_master_3_bindings.sh
# ~/nixos-config/keyboard/smart_shift_buffer.sh
# solaar (must be running in order to execute smart_shift_buffer.sh)

set -euo pipefail

# Workaround for an issue where swaymsg fails with "Unable to retrieve socket path" if invoked too early
echo "SWAYSOCK=$SWAYSOCK" # This daemon might fail here with "unbound variable SWAYSOCK", forcing a restart

mouse_name="Logitech MX Master 3"
smart_shift_buffer_path="/dev/shm/smart_shift_buffer"
script_dir="$(dirname "$(realpath "$0")")"
keycontrol_path="${script_dir}/keycontrol.sh"
mouse_device="$(libinput list-devices | grep "$mouse_name" -A1 | grep -o '/dev/input/event[0-9]*')"

echo "Found ${mouse_name} at ${mouse_device}"

function execute() {
    event_name="$1"
    smart_shift_buffer="$(cat "$smart_shift_buffer_path")"
    if [[ "$smart_shift_buffer" == "1" ]]; then
        "$keycontrol_path" "Smart Shift ${event_name}"
    fi
}

function process_wheel_event() {
    horizontal_value="$1"
    if [[ "$horizontal_value" = "0"* ]]; then
        # Assuming vertical scroll event, which we don't care about
        return
    elif [[ "$horizontal_value" = "-"* ]]; then
        execute "Scroll Left"
    else
        # Assuming it is a positive number
        execute "Scroll Right"
    fi
}

function parse_event_line() {
    # When scrolling the wheel horizontally, each line will look something like this:
    # event11  POINTER_SCROLL_WHEEL    +0.798s	vert 0.00/0.0 horiz -15.00/-120.0* (wheel)
    action="$2"
    horizontal_value="${7-:}"

    if [ "${action}" = "POINTER_SCROLL_WHEEL" ]; then
        process_wheel_event "$horizontal_value"
    fi
}

while read -r line; do
    # shellcheck disable=SC2086
    parse_event_line ${line}
done < <(stdbuf -oL libinput debug-events --device "$mouse_device" & )
