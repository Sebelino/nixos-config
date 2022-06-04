#!/usr/bin/env bash

set -euo pipefail

urxvt -name center_window -e sh -c 'vim ~/scratchpad.txt' &!
