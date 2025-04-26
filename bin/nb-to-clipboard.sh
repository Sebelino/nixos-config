#!/usr/bin/env bash

set -Eeuo pipefail

nb_path="$1"
nb_path_no_extension="${nb_path%.*}"
out_path="${nb_path_no_extension}.py"

jupyter nbconvert --to script "$nb_path" && mv "$out_path" /tmp/tmp.py && cat /tmp/tmp.py | wl-copy
