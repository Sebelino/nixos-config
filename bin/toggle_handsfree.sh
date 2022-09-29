#!/usr/bin/env bash

# Toggle between mic + crappy sound vs. no mic + good sound on a Bluetooth headset

set -Eeuo pipefail

card="$(pactl --format=json list cards | jq -r '.[] | select(.driver == "module-bluez5-device.c")')"

card_name="$(echo "$card" | jq -r '.name')"

active_profile="$(echo "$card" | jq -r '.active_profile')"

nonactive_profile="$(echo "$card" | jq -r ".profiles | del(.off) | del(.$active_profile) | keys[]")"

set -x

pactl set-card-profile "$card_name" "$nonactive_profile"
