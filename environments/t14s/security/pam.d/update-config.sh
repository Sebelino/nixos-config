#!/usr/bin/env bash

set -Eeuo pipefail

sudo cp 50-fprintd.rules /etc/polkit-1/rules.d/50-fprintd.rules
sudo cp swaylock /etc/pam.d/swaylock
sudo cp system-auth /etc/pam.d/system-auth
sudo systemctl restart polkit
sudo systemctl restart fprintd
