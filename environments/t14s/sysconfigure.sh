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
symlink "audio/cmus/rc" "$HOME/.config/cmus/rc"
