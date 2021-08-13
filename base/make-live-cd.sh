#!/usr/bin/env bash

set -euo pipefail

USB_DEVICE="/dev/sda"

fdisk -l "$USB_DEVICE"

echo ""
echo "Is this the USB you want to overwrite?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

set -x

nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

cp result/iso/nixos-21.11pre-git-x86_64-linux.iso "$USB_DEVICE"

# Remove generated symlink
rm result
