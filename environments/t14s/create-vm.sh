#!/usr/bin/env bash

# The intention is to create a VM programmatically using this script instead of
# using virt-manager. Note the --boot uefi parameter.

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

set -x

image_pool_name="images"

virsh pool-delete --pool "$image_pool_name" || true
virsh pool-undefine --pool "$image_pool_name" || true
virsh pool-define --validate --file "${scriptdir}/vm/libvirt/pool-images.xml"
virsh pool-build "$image_pool_name"

vm_name="win81"

# Destroy VM if it already exists
virsh destroy "$vm_name" || true
virsh undefine --nvram "$vm_name" || true

virt-install \
    --name "$vm_name" \
    --ram=4096 \
    --vcpus=2 \
    --cpu host \
    --hvm \
    --disk path=/var/lib/libvirt/images/dualboot,size=64 \
    --cdrom "$HOME/misc/iso/Win8.1_SingleLang_English_x64.iso" \
    --osinfo win8.1 \
    --network default \
    --check path_in_use=off \
    --boot uefi
