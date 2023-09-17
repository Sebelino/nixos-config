#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

source "${scriptdir}/../../lib/common.sh"

if [ ! -L "$HOME/.ssh/id_ed25519" ]; then
    echo "Converting .ssh/ files into symlinks..."
    rm "$HOME/.ssh/id_ed25519"
    rm -f "$HOME/.ssh/id_ed25519.pub"
fi

symlink "sway" "$HOME/.config/sway"
symlink "vcs/gitconfig" "$HOME/.gitconfig"
symlink "security/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
symlink "shell/zdotdir.zshenv" "$HOME/.zshenv"
symlink "shell/zsh" "$HOME/.config/zsh"
symlink "terminal/alacritty" "$HOME/.config/alacritty"
symlink "editor/nvim" "$HOME/.config/nvim"
symlink "audio/cmus/rc" "$HOME/.config/cmus/rc"
symlink "keyboard/xkb" "$HOME/.xkb"
symlink "statusbar/waybar" "$HOME/.config/waybar"
symlink "../../secrets/id_ed25519" "$HOME/.ssh/id_ed25519"
symlink "../../ssh/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
symlink "../../theme/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
symlink "../../theme/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
symlink "../../theme/gtkrc-2.0" "$HOME/.gtkrc-2.0"
symlink "browser/chromium/chromium-flags.conf" "$HOME/.config/chromium-flags.conf"

chmod 600 "$HOME/.ssh/id_ed25519"

# Needed by waybar (keyboard-state)
sudo usermod -aG input sebelino
sudo usermod -aG docker sebelino
sudo usermod -aG libvirt sebelino

sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
sudo cp "$scriptdir/login/autologin.conf" /etc/systemd/system/getty@tty1.service.d/autologin.conf

sudo cp "$scriptdir/smartcard/opensc.conf" /etc/opensc.conf
