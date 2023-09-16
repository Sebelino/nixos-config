#!/usr/bin/env bash

set -euo pipefail

sudo systemctl enable --now bluetooth
sudo systemctl enable --now pacman-filesdb-refresh.timer
sudo systemctl enable --now docker

# Used by virt-manager
sudo systemctl enable --now libvirtd

## Unclear if this one is needed
#systemctl enable --now --user xdg-desktop-portal-wlr
