#!/usr/bin/env bash

set -euo pipefail

sgdisk --zap-all /dev/sda
sgdisk --new=1::+500MB /dev/sda
sgdisk --typecode=1:ef00 /dev/sda
sgdisk --new=:: /dev/sda