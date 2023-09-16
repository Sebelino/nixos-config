#!/usr/bin/env bash

set -Eeuo pipefail

device_name="$(lsblk -J | jq -r '.blockdevices[] | select(.type == "disk") | .name')"

device_file="/dev/${device_name}"

# Assert exactly one disk was found
ls "${device_file}"

# Print all disks
lsblk

echo ""
echo "Create a new partition in this disk?: --> ${device_file} <--"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

set -x

sgdisk --new=:: "$device_file"

# Print disk with partition
lsblk "${device_file}"
