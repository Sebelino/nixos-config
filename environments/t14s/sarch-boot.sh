#!/usr/bin/env bash

set -euo pipefail

set -x

cd "$HOME/misc/iso/sarch-archiso/"
isofile="$(ls ./output/*.iso)"
qemu-img create -f qcow2 sarch.img 10G

qemu-system-x86_64 -enable-kvm -cdrom "$isofile" -boot order=d -drive file=sarch.img -m 2G -cpu host -smp 2
