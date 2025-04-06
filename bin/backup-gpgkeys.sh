#!/usr/bin/env bash

set -Eeuo pipefail

# Assuming you downloaded it here
source_dir="$HOME/Downloads"
gpgkey_path="$source_dir/gpgkeys.7z"
tmp_dir="$source_dir/gpg_temp"

ls "$gpgkey_path" # Exit if the file is not found

read -r -p "Enter 7z password: " -s password_7z

rm -rf "$tmp_dir"
mkdir -p "$tmp_dir"
cd "$tmp_dir"
cp "$gpgkey_path" .

7z x -p"${password_7z}" gpgkeys.7z # Prompts for 7zip password

gpg --export-secret-keys --armor --output "private-current.asc"
gpg --export --armor --output "public-current.asc"

gpg --import-options show-only --import private-current.asc > current.txt
gpg --import-options show-only --import myprivkeys.asc > backup.txt

if diff current.txt backup.txt; then
    echo "No changes in private key. Exiting."
    rm -r "$tmp_dir"
    exit 0
else
    echo "Changes in private key. Backing up."
    mv myprivkeys.asc "myprivkeys.$(date -r myprivkeys.asc +%Y-%m-%dT%H_%M_%S).asc"
    mv mypubkeys.asc "mypubkeys.$(date -r mypubkeys.asc +%Y-%m-%dT%H_%M_%S).asc"
    mv private-current.asc myprivkeys.asc
    mv public-current.asc mypubkeys.asc
fi

7z a -p"$password_7z" -mhe new.gpgkeys.7z myprivkeys*.asc mypubkeys*.asc

cd "$source_dir"
mv "$tmp_dir/new.gpgkeys.7z" gpgkeys.7z
rm -r "$tmp_dir"
echo "$gpgkey_path updated."
