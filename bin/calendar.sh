#!/usr/bin/env bash

set -Eeuo pipefail

gcalendar_url="https://calendar.google.com/calendar"
outlook_url="https://outlook.office.com/calendar/view/week"

url="$gcalendar_url"

chromium "-app=$url" &
