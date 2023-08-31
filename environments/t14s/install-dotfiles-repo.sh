#!/usr/bin/env bash

set -Eeuo pipefail

set -x

tempdir="$(mktemp -d)"

git clone https://github.com/Sebelino/nixos-config "$tempdir"

cd "$tempdir"

git crypt unlock # Prompts for GPG passphrase

git lfs install
git lfs pull

mkdir -p "$HOME/.ssh"
cp ./secrets/id_ed25519 "$HOME/.ssh/"
cp ./ssh/known_hosts "$HOME/.ssh/"
cp ./ssh/id_ed25519.pub "$HOME/.ssh/"
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/id_ed25519"

cd "$HOME"

if [ ! -d "nixos-config" ]; then
    git clone git@github.com:Sebelino/nixos-config
    cd nixos-config/
    git crypt unlock
    git lfs install
    git lfs pull
    git config user.name "Sebastian Olsson"
    git config user.email "sebelino7@gmail.com"
fi

rm -rf "$tempdir"
