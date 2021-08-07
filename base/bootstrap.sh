#!/usr/bin/env bash

set -euo pipefail

luks_passphrase="$1"

SSID="Olssons-5G"

sudo su

loadkeys /etc/kbd/keymaps/i386/qwerty/sv-latin1.map.gz

wpa_passphrase "$SSID" | tee /etc/wpa_supplicant.conf
systemctl restart wpa_supplicant.service

bash ./partitioning.sh "$luks_passphrase"
