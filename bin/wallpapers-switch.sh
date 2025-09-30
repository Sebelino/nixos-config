#!/usr/bin/env bash

set -Eeuo pipefail

wallpapers_dir="$HOME/nixos-config/windowmanager/wallpapers/eDP-1"

wallpaper_to_switch="$(ls "$wallpapers_dir" | fzf)"

images_path="$HOME/nixos-config/blobs/images"

file_name="$(ls "$images_path" | fzf)"
file_path="${images_path}/${file_name}"

target_path="${images_path}/${file_name}"

symlink_path="$HOME/nixos-config/windowmanager/wallpapers/eDP-1/${wallpaper_to_switch}"

rm "$symlink_path"
ln -s "$target_path" "$symlink_path"

if [ "$target_path" != "$file_path" ]; then
    rm -f "$file_path"
fi

swaymsg reload
