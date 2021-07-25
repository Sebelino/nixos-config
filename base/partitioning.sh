#!/usr/bin/env bash

set -euo pipefail

luks_passphrase="$1"

DEVICE="/dev/sda"

# Close anything that is open (from a possible previous run of the script) before proceeding
cryptsetup luksClose enc-pv || true

sgdisk --print "$DEVICE"

echo ""
echo "Wipe this partition?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

echo "Setting up partitions..."

set -x

sgdisk --zap-all "$DEVICE"
sgdisk --new=1::+500MB "$DEVICE"
sgdisk --typecode=1:ef00 "$DEVICE"
sgdisk --new=:: "$DEVICE"
sgdisk --change-name=1:efiboot "$DEVICE"
sgdisk --change-name=2:lvmroot "$DEVICE"

lvmroot_partition="${DEVICE}2"

echo "$luks_passphrase" | cryptsetup --batch-mode luksFormat "$lvmroot_partition"
echo "$luks_passphrase" | cryptsetup luksOpen "$lvmroot_partition" enc-pv

pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -L 8G -n swap vg
lvcreate -l '100%FREE' -n root vg

mkfs.fat /dev/sda1
mkfs.ext4 -L root /dev/vg/root
mkswap -L swap /dev/vg/swap