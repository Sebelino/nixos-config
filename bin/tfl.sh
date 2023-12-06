#!/usr/bin/env bash

set -euo pipefail

set -x

teams-for-linux \
    --enable-features=UseOzonePlatform \
    --ozone-platform=wayland \
    --disableMeetingNotifications

# You can confirm that the app is launched with Wayland by running `xlsclients`.
