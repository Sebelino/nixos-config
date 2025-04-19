#!/usr/bin/env bash

set -Eeuo pipefail

url="$1"

basedir=/tmp/speedrun-framecheck
rm -rf "$basedir"
mkdir -p "$basedir"
cd "$basedir"

download_path="temp.mp4"

if [[ "$url" == *"twitch.tv"* ]]; then
	streamlink "$url" 720p60,360p,best -o "$download_path"
elif [[ "$url" == *"youtube.com"* ]]; then
	yt-dlp -o "$download_path" -f 298/134 --hls-prefer-ffmpeg "$url"
else
	echo "Unsupported URL format. Please provide a Twitch or YouTube link."
	exit 1
fi

framerate="$(ffprobe -show_streams "$download_path" 2>&1 | grep fps | awk '{split($0,a,"fps")}END{print a[1]}' | awk '{print $NF}')"

frames_path="temp_frames.mp4"

ffmpeg -i "$download_path" -vf \
	"drawtext=fontfile=IBMPlexMono-Regular.ttf: text=(${framerate}) %{n}: start_number=1: x=10: y=10: fontcolor=black: fontsize=16: box=1: boxcolor=white: boxborderw=5" \
	-preset ultrafast -c:a copy "$frames_path"

cp ~/bin/first_target_frame.py "$basedir"

python first_target_frame.py 2>/dev/null | tee output.txt

echo "Output written to $basedir/output.txt"
