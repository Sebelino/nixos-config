#!/usr/bin/env sh

URL="https://calendar.google.com/calendar"

google-chrome "-app=$URL" &!
chromium "-app=$URL" &!
