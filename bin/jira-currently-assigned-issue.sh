#!/usr/bin/env bash

set -euo pipefail

source "/home/sebelino/nixos-config/secrets/jira-token.sh"

jira issue list -a "$(jira me)" --status Ongoing --plain | tail -n 1 | cut -d $'\t' -f2
