#!/usr/bin/env bash

set -euo pipefail

pacman -Qqe > ~/nixos-config/environments/p14s/pkglist.txt
