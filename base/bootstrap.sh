#!/usr/bin/env bash

# * Copy this script to the root dir of a NixOS Live CD USB:
# sudo mount /dev/sda2 /mnt
# sudo cp bootstrap.sh /mnt/
# sudo umount /mnt
# * On the machine where you want to install NixOS, run:
# sudo su
# mkdir /temp
# mount /dev/sdb2 /temp
# /temp/bootstrap.sh <WIFI_SSID> <WIFI_PASSPHRASE> <LUKS_PASSPHRASE>

set -euo pipefail

set -x

wifi_ssid="$1"
wifi_passphrase="$2"
luks_passphrase="$3"

loadkeys /etc/kbd/keymaps/i386/qwerty/sv-latin1.map.gz

echo "$wifi_passphrase" | wpa_passphrase "$wifi_ssid" | tee /etc/wpa_supplicant.conf
systemctl restart wpa_supplicant.service

nix-env --install git
git clone https://github.com/Sebelino/nixos-config /tmp/nixos-config

bash /tmp/nixos-config/base/partitioning.sh "$luks_passphrase"
