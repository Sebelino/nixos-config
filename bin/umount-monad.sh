#!/usr/bin/env bash

set -Eeuo pipefail

veracrypt -d /veracrypt
sudo umount /mnt
sudo umount /mnt # Sometimes it's not umounted for some reason. Doesn't hurt to try again.
