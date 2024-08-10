#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

# Needed to install tor-browser-aur currently (2024-02-19)
gpg --quiet --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org > /dev/null

missing_packages="$(comm -23 <(sort -u < "$scriptdir/pkgs-apps.txt") <(pacman -Q | cut -d' ' -f1 | sort -u))"

if [ -z "$missing_packages" ]; then
  echo "No packages to install."
else
  yay -S --needed --noconfirm "$missing_packages"
fi


"$scriptdir/install-teams-for-linux.sh"
