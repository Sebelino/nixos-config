#!/usr/bin/env bash

set -Eeuo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

pacman_conf_path="$scriptdir/packages/pacman.conf"

if [ ! -L "/etc/pacman.conf" ]; then
    echo "Backing up /etc/pacman.conf..."
    sudo mv /etc/pacman.conf /etc/pacman.conf.bak
    echo "Converting /etc/pacman.conf into symlink..."
    sudo ln -s "$pacman_conf_path" /etc/pacman.conf
fi
