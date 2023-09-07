#!/usr/bin/env bash

set -euo pipefail

gpgkey_path="$HOME/misc/iso/sarch/releng/airootfs/root/gpgkey.pem"

set -x

gpg --export-secret-keys --armor --output "$gpgkey_path"
