#!/usr/bin/env bash

set -x

pkill -x multibg-wayland
exec multibg-wayland /home/sebelino/nixos-config/windowmanager/wallpapers > "/tmp/multibg-wayland.${XDG_VTNR}.${USER}.out.log" 2> "/tmp/multibg-wayland.${XDG_VTNR}.${USER}.err.log"
