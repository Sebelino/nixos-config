#!/usr/bin/env bash

grep_string="$1"

while (ps aux | grep -v "color=auto" | grep -i "$grep_string") do sleep 1; done; systemctl suspend
