#!/usr/bin/env bash

# After booting into the NixOS live cd, do:
# sudo su
# loadkeys /etc/kbd/keymaps/i386/qwerty/sv-latin1.map.gz
# wpa_passphrase Olssons-5G | tee /etc/wpa_supplicant.conf
# (Enter Wifi password)
# systemctl restart wpa_supplicant.service
# bash <(curl -sL <THIS_SCRIPT>) <MY_LUKS_PASSPHRASE>

set -euo pipefail

luks_passphrase="$1"

DEVICE="/dev/sda"

boot_partition="${DEVICE}1"

# Close anything that is open (from a possible previous run of the script) before proceeding
umount "$boot_partition" 2> /dev/null || true
umount /dev/vg/root 2> /dev/null || true
swapoff /dev/vg/swap 2> /dev/null || true
cryptsetup luksClose vg-root 2> /dev/null || true
cryptsetup luksClose vg-swap 2> /dev/null || true
cryptsetup luksClose enc-pv 2> /dev/null || true

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

mkfs.vfat /dev/sda1
mkfs.ext4 -L root /dev/vg/root
mkswap -L swap /dev/vg/swap

mkdir -p /mnt
mount /dev/vg/root /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/vg/swap

lvmroot_uuid="$(blkid "${lvmroot_partition}" -s UUID -o value)"

nix-env --install git

BASE_DIR="/mnt/tmp"

mkdir -p "$BASE_DIR"
cd "${BASE_DIR}"
git clone https://github.com/Sebelino/nixos-config

install_dir="${BASE_DIR}/nixos-config/base"
nixos_dir="${install_dir}/etc/nixos"

nixos-generate-config --root "/mnt" --dir "/tmp/nixos-config/base/etc/nixos"
echo "\"${lvmroot_uuid}\"" >> "${nixos_dir}/hardware-lvmroot-uuid.nix"

mkdir -p /mnt/etc/nixos

# Need to strip off the /mnt prefix here because of the chrooting later
ln -s "/tmp/nixos-config/base/etc/nixos/configuration.nix" /mnt/etc/nixos/configuration.nix

nixos-install
reboot