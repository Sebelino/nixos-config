#!/usr/bin/env bash

set -Eeuo pipefail

notify-send --urgency=low "✅ Done!"

paplay /home/sebelino/nixos-config/blobs/sounds/notification.ogg
