#!/usr/bin/env bash

rclone bisync -P "$HOME/gdrive/music" "google-drive:/music" --drive-skip-gdocs
