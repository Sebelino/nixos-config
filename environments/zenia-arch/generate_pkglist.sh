#!/usr/bin/env bash

set -euo pipefail

script_dir="$(readlink -f "$(dirname "$0")")"

pacman -Qqe > "$script_dir/pkglist.txt"
