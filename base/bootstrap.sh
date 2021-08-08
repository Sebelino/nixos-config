#!/usr/bin/env bash

# * Copy this script to the root dir of a NixOS Live CD USB
# * On the machine where you want to install NixOS, run:
# sudo su
# mkdir /temp
# mount /dev/sdb2 /temp
# /temp/bootstrap.sh <WIFI_PASSPHRASE> <LUKS_PASSPHRASE>

set -euo pipefail

set -x

wifi_passphrase="$1"
luks_passphrase="$2"

SSID="Olssons-5G"

loadkeys /etc/kbd/keymaps/i386/qwerty/sv-latin1.map.gz

echo "$wifi_passphrase" | wpa_passphrase "$SSID" | tee /etc/wpa_supplicant.conf
systemctl restart wpa_supplicant.service

nix-env --install git
git clone https://github.com/Sebelino/nixos-config /tmp/nixos-config

bash /tmp/nixos-config/base/partitioning.sh "$luks_passphrase"
