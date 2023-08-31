#!/usr/bin/env bash

set -Eeuo pipefail

set -x

cd ~/Downloads

7z x gpgkeys.7z # Prompts for 7zip password

gpg --import myprivkeys.asc # Prompts for GPG passphrase

gpg --import mypubkeys.asc
shred -u myprivkeys.asc mypubkeys.asc
