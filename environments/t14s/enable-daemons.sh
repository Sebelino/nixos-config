#!/usr/bin/env bash

set -euo pipefail

# If I have made any changes to a *.service file, reload those changes
systemctl --user daemon-reload

sudo systemctl enable --now bluetooth
sudo systemctl enable --now pacman-filesdb-refresh.timer
sudo systemctl enable --now docker

# Adjust time
sudo systemctl enable --now systemd-timesyncd

# Used by virt-manager
sudo systemctl enable --now libvirtd

# Smart card reader
sudo systemctl enable --now pcscd

# at command
sudo systemctl restart atd

# Keyboard automation tool
systemctl --user enable --now ydotool

## Unclear if this one is needed
#systemctl enable --now --user xdg-desktop-portal-wlr

# Custom daemon for acting on certain mouse events
systemctl --user enable --now mousemapper
systemctl --user enable --now jira-refresh-currently-assigned-issue
