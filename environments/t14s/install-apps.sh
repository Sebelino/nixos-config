#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

# Needed to install tor-browser-aur currently (2024-02-19)
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org

yay -S --needed --noconfirm - < "$scriptdir/pkgs-apps.txt"

"$scriptdir/install-teams-for-linux.sh"
