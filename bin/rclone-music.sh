#!/usr/bin/env bash

rclone sync -P "$HOME/gdrive/music" "google-drive:/music"
