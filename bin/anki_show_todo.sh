#!/usr/bin/env bash

set -Eeuo pipefail

count="$(python3 "$HOME/nixos-config/bin/anki_get_todo.py")"
notify-send --urgency=low "Anki todo count" "<span color='#57dafd' font='26px'>$count</span>"
