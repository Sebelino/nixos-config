#!/usr/bin/env bash

pid_file=/tmp/timer.sh.pid
pid="$(cat "$pid_file")"
kill "$pid"
rm -f /tmp/timer.sh.txt
rm -f "$pid_file"
