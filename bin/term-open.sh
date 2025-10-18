#!/usr/bin/env bash

set -Eeuo pipefail

script="$HOME/bin/popup/term-open.sh"
title="term-open-cmd"

nohup alacritty \
    --title "$title" \
    --working-directory "$HOME" \
    --command "$script" \
    > "/tmp/${title}.out" 2>&1 &
