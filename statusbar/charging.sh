#!/bin/bash

set -euo pipefail

complain() {
    echo "<fc=#FF0000>ERROR</fc>"
    exit 0
}

trap complain ERR

status="$(acpi -a | awk -F': ' '{print $2}')"

if [ "$status" = 'off-line' ]; then
    echo "<fc=#FFA000>■■■■■■</fc>"
else
    echo "■■■■■■"
fi
