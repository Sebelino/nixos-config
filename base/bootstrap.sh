#!/usr/bin/env bash

# * On the machine where you want to install NixOS, run:
# sudo su
# mkdir /temp
# mount /dev/sdb1 /temp
# /temp/bootstrap.sh <LUKS_PASSPHRASE>

set -euo pipefail

set -x

luks_passphrase="$1"

loadkeys /etc/kbd/keymaps/i386/qwerty/sv-latin1.map.gz

# TODO: Can probably be avoided with
# networking.wireless.enable = true;
# in iso.nix
systemctl restart wpa_supplicant.service

# Wait for wpa_supplicant to prevent "Could not resolve host..."
# TODO: Solve this with a retry instead
sleep 15

# Git should already be pre-installed. If it isn't, you can do: nix-env --install git
git clone https://github.com/Sebelino/nixos-config /tmp/nixos-config

bash /tmp/nixos-config/base/partitioning.sh "$luks_passphrase"
