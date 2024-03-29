#!/usr/bin/env bash

set -euo pipefail

set -x

cd "$HOME/misc/iso/sarch/"

isofile="$(ls ./output/*.iso)"
usb_device="$(ls /dev/disk/by-id/usb* | grep -v "part")"

sudo dd bs=4M if="$isofile" of="$usb_device" conv=fsync oflag=direct status=progress
