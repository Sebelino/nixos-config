#!/usr/bin/env bash

set -x

pkill -x kanshi
exec kanshi > "/tmp/kanshi.${XDG_VTNR}.${USER}.out.log" 2> /tmp/kanshi.${XDG_VTNR}.${USER}.err.log
