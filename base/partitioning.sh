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

nixos-generate-config --root /mnt

lvmroot_uuid="$(blkid "${lvmroot_partition}" -s UUID -o value)"

echo "
boot.initrd.luks.devices = {
  lvmroot = {
    device = \"/dev/disk/by-uuid/${lvmroot_uuid}\";
    preLVM = true;
    allowDiscards = true;
  };
};
" >> /mnt/etc/nixos/configuration.nix

set +x

echo ""
echo "Now type:"
echo "vim /mnt/etc/nixos/configuration.nix"
echo "and move up the section at the bottom of the file that begins with 'boot.initrd.luks.devices'."
echo ""
echo "When done, run:"
echo "nixos-install --no-root-passwd"
echo "reboot"