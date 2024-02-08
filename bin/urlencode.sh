#!/usr/bin/env bash

set -Eeuo pipefail

python3 -c "import sys; from urllib.parse import quote_plus; print(quote_plus(sys.stdin.read().strip()), end='');"
