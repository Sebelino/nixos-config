#!/bin/sh

status=`acpi -a | awk -F': ' '{print $2}'`

if [ $status = 'off-line' ]; then
    echo "<fc=#FFA000>■■■■■■</fc>"
else
    echo "■■■■■■"
fi
