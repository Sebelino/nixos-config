#!/usr/bin/env bash

set -Eeuo pipefail

images_path="$HOME/nixos-config/blobs/images"

if [ $# -eq 1 ]; then
    file_path="$1"
    file_name="$(basename "$file_path")"
else
    file_name="$(ls "$images_path" | fzf)"
    file_path="${images_path}/${file_name}"
fi

target_path="${images_path}/${file_name}"

if [ ! -f "$target_path" ]; then
    cp "$file_path" "$target_path"
fi

symlink_path="$HOME/nixos-config/windowmanager/wallpaper"

rm "$symlink_path"
ln -s "$target_path" "$symlink_path"

if [ "$target_path" != "$file_path" ]; then
    rm -f "$file_path"
fi

swaymsg reload
