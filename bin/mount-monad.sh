#!/usr/bin/env bash

set -Eeuo pipefail

sudo mount /dev/sda3 /mnt
veracrypt --text --mount /mnt/monad.hc /veracrypt --pim=0 --keyfiles="" --protect-hidden=no --hash=sha512 --encryption=aes
