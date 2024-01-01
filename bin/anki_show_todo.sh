#!/usr/bin/env bash

set -Eeuo pipefail

count="$(python3 "$HOME/nixos-config/bin/anki_get_todo.py")"
notify-send --urgency=low "Anki todo count" "$count"
