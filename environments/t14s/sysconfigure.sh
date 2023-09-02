#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

source "${scriptdir}/../../lib/common.sh"

symlink "sway" "$HOME/.config/sway"
symlink "vcs/gitconfig" "$HOME/.gitconfig"
symlink "security/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
symlink "shell/zshrc" "$HOME/.zshrc"
symlink "shell/zshenv" "$HOME/.zshenv"
symlink "shell/p10k.zsh" "$HOME/.p10k.zsh"
