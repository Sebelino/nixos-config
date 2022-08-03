#!/usr/bin/env sh

GCALENDAR_URL="https://calendar.google.com/calendar"
OUTLOOK_URL="https://outlook.office.com/calendar/view/week"

url="$OUTLOOK_URL"

google-chrome "-app=$url" &!
chromium "-app=$url" &!
