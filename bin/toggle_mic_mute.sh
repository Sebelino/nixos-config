#!/usr/bin/env bash

set -Eeuo pipefail

src="$(pactl --format=json list sources | jq '.[] | select(.description=="Jabra Evolve 65")')"

source_index="$(echo "$src" | jq '.index')"

is_muted="$(echo "$src" | jq '.mute')"

set -x

pactl set-source-mute "$source_index" toggle

if [ "$is_muted" = "true" ]; then
    message="🎤 ON"
else
    message="⭘︎ OFF"
fi

notify-send --urgency=low "Toggle mic" "$message"
