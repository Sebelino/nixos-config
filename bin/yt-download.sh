#!/usr/bin/env bash

set -Eeuo pipefail

url="$1"

yt-dlp -x -o output "$url" && ffmpeg -i output.opus output.mp3 && rm output.opus
