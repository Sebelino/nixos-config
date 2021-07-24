#!/usr/bin/env bash

set -euo pipefail

DEVICE="/dev/sda"

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