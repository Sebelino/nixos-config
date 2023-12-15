#!/usr/bin/env bash

set -euo pipefail

source "/home/sebelino/nixos-config/secrets/jira-token.sh"

jira issue list -a "$(jira me)" --plain | tail -n +2 | cut -d $'\t' -f2
