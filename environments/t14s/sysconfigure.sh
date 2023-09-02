#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

source "${scriptdir}/../../lib/common.sh"

symlink "sway" "$HOME/.config/sway"
symlink "vcs/gitconfig" "$HOME/.gitconfig"
