#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

"$scriptdir/xmobar.sh" &!
"$scriptdir/trayer.sh" &!
