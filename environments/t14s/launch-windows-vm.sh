#!/usr/bin/env bash

set -Eeuo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

set -x

# Needed for virt-install by the libvirt-qemu user
chmod go+x "$HOME/.local"
chmod go+x "$HOME/.local/share"

image_pool_name="images"
image_name="win11"
vol_name="win11"

virsh vol-delete --vol "$vol_name" --pool "$image_pool_name"
virsh pool-destroy --pool "$image_pool_name" || true
virsh pool-delete --pool "$image_pool_name" || true
virsh pool-undefine --pool "$image_pool_name" || true
virsh pool-define --validate --file "${scriptdir}/vm/libvirt/pool-images.xml"
virsh pool-build --pool "$image_pool_name"
virsh pool-start --pool "$image_pool_name"
virsh pool-autostart --pool "$image_pool_name"

virsh vol-create --pool "$image_pool_name" --file "${scriptdir}/vm/libvirt/vol-win11.xml"

image_path="$(virsh vol-path "$image_name" --pool images)"

vm_name="win11"

# Destroy VM if it already exists
virsh destroy "$vm_name" || true
virsh undefine --nvram "$vm_name" || true

iso="$HOME/misc/iso/Win11_24H2_English_x64.iso"

WAYLAND_DISPLAY="" virt-install \
    --name "$vm_name" \
    --ram=4096 \
    --vcpus=2 \
    --cpu host \
    --hvm \
    --disk "path=${image_path},size=64" \
    --cdrom "$iso" \
    --osinfo win11 \
    --network default \
    --check path_in_use=off \
    --boot uefi \
    --tpm model=tpm-crb \
    --features smm.state=on \
    --machine q35
