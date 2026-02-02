#!/usr/bin/env bash

set -Eeuo pipefail

monitor_a=1
monitor_b=2

ws_temp=11

aerospace focus-monitor $monitor_a

ws_a="$(aerospace list-workspaces --focused)"

aerospace summon-workspace $ws_temp
aerospace focus-monitor $monitor_b

ws_b="$(aerospace list-workspaces --focused)"

aerospace summon-workspace $ws_a

aerospace focus-monitor $monitor_a
aerospace summon-workspace $ws_b
