#!/usr/bin/env bash

rclone sync -P "$HOME/gdrive/academia" "google-drive:/academia"
