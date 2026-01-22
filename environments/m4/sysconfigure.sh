#!/usr/bin/env bash

set -Eeuo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

source "${scriptdir}/../../lib/common.sh"

symlink "display/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
