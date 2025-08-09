#!/usr/bin/env bash

set -euo pipefail

# If I have made any changes to a *.service file, reload those changes
systemctl --user daemon-reexec
systemctl --user daemon-reload

sudo systemctl enable --now bluetooth
sudo systemctl enable --now pacman-filesdb-refresh.timer
sudo systemctl enable --now docker

# Adjust time
sudo systemctl enable --now systemd-timesyncd

# Used by virt-manager
# Enabling this may cause `reboot` to hang for 5 seconds https://www.reddit.com/r/archlinux/comments/1h1ucdu/a_5second_delay_after_powering_off/
sudo systemctl enable --now libvirtd
sudo systemctl enable --now libvirtd.socket
sudo systemctl enable --now libvirtd-ro.socket
sudo systemctl enable --now libvirtd-admin.socket

# Smart card reader
sudo systemctl enable --now pcscd

# at command
sudo systemctl enable --now atd
sudo systemctl restart atd

# Keyboard automation tool
systemctl --user enable --now ydotool

## Unclear if this one is needed
#systemctl enable --now --user xdg-desktop-portal-wlr

# Custom daemon for acting on certain mouse events
systemctl --user enable --now mousemapper
#systemctl --user enable --now jira-refresh-currently-assigned-issue

# Daily notification
# To list timers:
# systemctl --user list-timers
systemctl --user enable --now daily-notify.timer
