#!/usr/bin/env bash

PID_FILE="/tmp/timer.sh.pid"
TIMER_FILE="/tmp/timer.sh.txt"
PAUSE_FILE="/tmp/timer.sh.pause"

pid="$(cat "$PID_FILE")"
kill "$pid"
rm -f "$PID_FILE"
rm -f "$TIMER_FILE"
rm -f "$PAUSE_FILE"
