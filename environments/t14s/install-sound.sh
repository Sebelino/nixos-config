#!/usr/bin/env bash

set -Eeuo pipefail

set -x

yay -S \
    pipewire \
    pipewire-docs \
    pipewire-audio \
    pipewire-pulse \
    wireplumber \
    --needed \
    --noconfirm

systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
