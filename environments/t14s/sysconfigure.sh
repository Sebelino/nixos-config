#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

source "${scriptdir}/../../lib/common.sh"

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

# Needed by waybar (keyboard-state)
sudo usermod -aG input sebelino
