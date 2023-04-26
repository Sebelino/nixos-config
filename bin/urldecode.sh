#!/usr/bin/env bash

set -Eeuo pipefail

python3 -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()), end='');"
