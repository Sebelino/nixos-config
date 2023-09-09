#!/usr/bin/env bash

set -euo pipefail

sudo systemctl enable --now bluetooth
sudo systemctl enable --now pacman-filesdb-refresh.timer
sudo systemctl enable --now docker

## Unclear if this one is needed
#systemctl enable --now --user xdg-desktop-portal-wlr
