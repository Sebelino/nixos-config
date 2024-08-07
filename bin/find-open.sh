#!/usr/bin/env bash

set -Eeuo pipefail

script="$HOME/bin/find-open/cmd.sh"
title="find-open-cmd"

nohup alacritty \
    --title "$title" \
    --working-directory "$HOME" \
    --command "$script" &
