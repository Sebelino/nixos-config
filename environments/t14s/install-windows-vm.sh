#!/usr/bin/env bash

set -Eeuo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

# Needed for virt-install by the libvirt-qemu user
chmod go+x "$HOME/.local"
chmod go+x "$HOME/.local/share"

image_pool_name="images"
image_name="win11"
vol_name="win11"
vm_name="win11"
iso="$HOME/misc/iso/Win11_24H2_English_x64.iso"

# Check for -f or --force flag
force=false
for arg in "$@"; do
  if [[ "$arg" == "-f" || "$arg" == "--force" ]]; then
    force=true
  fi
done

# Check if VM already exists
if virsh dominfo "$vm_name" &>/dev/null; then
  if ! $force; then
    echo "⚠️  VM '$vm_name' already exists."
    read -rp "Do you want to delete and recreate it? This will erase all data. [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "Aborting."
      exit 1
    fi
  else
    echo "⚠️  VM '$vm_name' exists. Proceeding due to --force."
  fi
  virsh destroy "$vm_name" || true
  virsh undefine --nvram "$vm_name" || true
fi

# Check if volume already exists
if virsh vol-info --pool "$image_pool_name" "$vol_name" &>/dev/null; then
  if ! $force; then
    echo "⚠️  Volume '$vol_name' already exists in pool '$image_pool_name'."
    read -rp "Do you want to delete and recreate it? This will erase the virtual disk. [y/N]: " confirm_vol
    if [[ ! "$confirm_vol" =~ ^[Yy]$ ]]; then
      echo "Aborting."
      exit 1
    fi
  else
    echo "⚠️  Volume '$vol_name' exists. Proceeding due to --force."
  fi
  virsh vol-delete --vol "$vol_name" --pool "$image_pool_name"
fi

# Recreate image pool
virsh pool-destroy --pool "$image_pool_name" || true
virsh pool-delete --pool "$image_pool_name" || true
virsh pool-undefine --pool "$image_pool_name" || true
virsh pool-define --validate --file "${scriptdir}/vm/libvirt/pool-images.xml"
virsh pool-build --pool "$image_pool_name"
virsh pool-start --pool "$image_pool_name"
virsh pool-autostart --pool "$image_pool_name"

# Create volume
virsh vol-create --pool "$image_pool_name" --file "${scriptdir}/vm/libvirt/vol-win11.xml"

image_path="$(virsh vol-path "$image_name" --pool images)"

# Launch VM installation
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
    --graphics spice \
    --machine q35
