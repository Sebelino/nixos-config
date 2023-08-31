#!/usr/bin/env bash

set -Eeuo pipefail

set -x

yay -S --noconfirm pipewire pipewire-docs pipewire-audio pipewire-alsa pipewire-pulse

systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
