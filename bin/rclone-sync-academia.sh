#!/usr/bin/env bash

rclone bisync -P "$HOME/gdrive/academia" "google-drive:/academia" --drive-skip-gdocs
