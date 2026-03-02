#!/usr/bin/env bash

set -Eeuo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

source "${scriptdir}/../../lib/common.sh"

symlink "display/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
symlink "keyboard/karabiner" "$HOME/.config/karabiner"
symlink "shell/zsh/zshrc" "$HOME/.zshrc"
symlink "shell/zsh/aliases.zsh" "$HOME/.config/zsh/aliases.zsh"
symlink "editor/nvim" "$HOME/.config/nvim"

