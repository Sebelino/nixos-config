#!/usr/bin/env bash

set -Eeuo pipefail

set -x

if false; then
fi

tempdir="$(mktemp -d)"

git clone https://aur.archlinux.org/yay "$tempdir"
cd "$tempdir"

makepkg -si --noconfirm

# Enable colored output in pacman and yay
sudo sed -i 's/#Color/Color/' /etc/pacman.conf

yay -S --noconfirm sway swaylock swayidle swaybg wmenu

mkdir -p "$HOME/.config/sway"
cp /etc/sway/config "$HOME/.config/sway/config"
sed -i 's/$term foot/$term alacritty/' "$HOME/.config/sway/config"

nixospath=/home/sebelino/nixos-config-tmp
cat "$nixospath/environments/t14s/extra-sway-config" >> "$HOME/.config/sway/config"

yay -S --noconfirm xorg-xwayland wofi
yay -S --noconfirm alacritty chromium parted vlc ack p7zip git-lfs git-crypt openssh

# Sway uses seatd, which requires me to be added to this group
sudo usermod -aG seat sebelino

sudo systemctl enable --now seatd