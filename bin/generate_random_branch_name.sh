#!/usr/bin/env bash

set -euo pipefail

words="$(shuf -n2 /usr/share/dict/words | sed "s/'.*//" | tr '[:upper:]' '[:lower:]' | tr '\n' '-')"
words=${words::-1}

today="$(date '+%m-%d')"

echo "${today}-${words}-Sebelino"
