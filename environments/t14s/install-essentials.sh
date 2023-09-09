#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

yay -S --needed --noconfirm - < "$scriptdir/pkgs-essentials.txt"

# This package was somehow installed automatically. It interferes with xdg-desktop-portal(-wlr).
if pacman -Qi "xdg-desktop-portal-gnome" 2>/dev/null; then
    echo "Found xdg-desktop-portal-gnome. Uninstalling it..."
    yay -R --noconfirm xdg-desktop-portal-gnome
fi
