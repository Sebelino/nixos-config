#!/usr/bin/env bash

set -Eeuo pipefail

set -x

pacman -S --noconfirm less man-db

# If user doesn't already exist, create it
if ! getent passwd sebelino; then
    useradd -m -G wheel,video,audio -s /usr/bin/zsh sebelino
    passwd sebelino
    touch /home/sebelino/.zshrc
fi

echo "%wheel ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99_wheel_nopasswd
