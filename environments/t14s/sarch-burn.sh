#!/usr/bin/env bash

set -euo pipefail

cd "$HOME/misc/iso/sarch-archiso/"

isofile="$(ls ./output/*.iso)"
usb_device="$(ls /dev/disk/by-id/usb* | grep -v "part")"

set -x

sudo dd bs=4M if="$isofile" of="$usb_device" conv=fsync oflag=direct status=progress
