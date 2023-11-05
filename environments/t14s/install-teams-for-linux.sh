#!/usr/bin/env bash

# Install older version of teams-for-linux (1.3.12) to work around Wayland bug:
# https://github.com/IsmaelMartinez/teams-for-linux/issues/1001

set -euo pipefail

version="1.3.12-1"
output_dirname="aur-bf5d06505a9b73fa9cfd0e21d8b8c63e8d1f2948"

if [ "$( pacman -Qm teams-for-linux )" = "teams-for-linux ${version}" ]; then
    echo "teams-for-linux already installed."
    exit 0
fi

tarball_url="https://aur.archlinux.org/cgit/aur.git/snapshot/${output_dirname}.tar.gz"
build_dir="/tmp/teams-for-linux-builddir"

rm -rf "$build_dir" # If builddir is there from a previous execution, remove it

mkdir -p "$build_dir"
cd "$build_dir"
wget "$tarball_url"
tar xf "${output_dirname}.tar.gz"
cd "$output_dirname"
makepkg -si --noconfirm
