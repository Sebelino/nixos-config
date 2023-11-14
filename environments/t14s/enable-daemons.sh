#!/usr/bin/env bash

set -euo pipefail

sudo systemctl enable --now bluetooth
sudo systemctl enable --now pacman-filesdb-refresh.timer
sudo systemctl enable --now docker

# Adjust time
sudo systemctl enable --now systemd-timesyncd

# Used by virt-manager
sudo systemctl enable --now libvirtd

# Smart card reader
sudo systemctl enable --now pcscd

# Keyboard automation tool
systemctl --user enable --now ydotool

## Unclear if this one is needed
#systemctl enable --now --user xdg-desktop-portal-wlr

# Custom daemon for acting on certain mouse events
systemctl --user enable --now mousemapper

# If I have made any changes to a *.service file, reload those changes
systemctl --user daemon-reload
