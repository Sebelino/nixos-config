#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

yay -S --needed --noconfirm - < "$scriptdir/pkgs-apps.txt"
