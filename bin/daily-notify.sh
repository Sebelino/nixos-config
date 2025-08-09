#!/usr/bin/env bash

set -Eeuo pipefail

notify-send "Daily Reminder" "This is your daily notification!"
paplay /usr/share/sounds/freedesktop/stereo/complete.oga
