#!/usr/bin/env bash

set -euo pipefail

set -x

ln -s "$(pwd)/config.yaml" "$HOME/.config/solaar/config.yaml"
ln -s "$(pwd)/rules.yaml" "$HOME/.config/solaar/rules.yaml"
