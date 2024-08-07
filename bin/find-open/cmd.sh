#!/usr/bin/env bash

set -Eeuo pipefail

export FZF_DEFAULT_COMMAND="find . -not -path '*/.*'"

filepath="$(fzf)"
filepath="$(readlink -f "$filepath")"

if [[ "$filepath" == *.pdf ]]; then
    nohup zathura "$filepath" &
elif [[ "$filepath" == *.drawio ]]; then
    nohup drawio "$filepath" &
elif [[ "$filepath" == *.jpg ]]; then
    nohup feh "$filepath" &
elif [[ "$filepath" == *.png ]]; then
    nohup feh "$filepath" &
else
    nvim "$filepath"
fi

# drawio -> drawio
# text file -> nvim
# png -> feh

sleep 0.01 # Some delay is needed to prevent this process to kill the child process
