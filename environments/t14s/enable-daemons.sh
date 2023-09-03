#!/usr/bin/env bash

set -euo pipefail

sudo systemctl enable --now bluetooth
sudo systemctl enable --now pacman-filesdb-refresh.timer
