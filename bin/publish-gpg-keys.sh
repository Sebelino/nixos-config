#!/usr/bin/env bash

set -Eeuo pipefail

gpg --keyserver hkps://keys.openpgp.org --send-keys 3271408B7D89D8F195355ADF44A32D5FB19A1B2C
gpg --keyserver hkps://keys.openpgp.org --send-keys 5FD5A4F4ECB264182D3F75B0BFA99599C03F1B51
gpg --keyserver hkps://keyserver.ubuntu.com --send-keys 3271408B7D89D8F195355ADF44A32D5FB19A1B2C
gpg --keyserver hkps://keyserver.ubuntu.com --send-keys 5FD5A4F4ECB264182D3F75B0BFA99599C03F1B51

keybase pgp update

gh gpg-key delete 44A32D5FB19A1B2C --yes || true
gpg --armor --export 44A32D5FB19A1B2C | gh gpg-key add -
