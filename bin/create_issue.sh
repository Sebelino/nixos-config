#!/usr/bin/env bash

set -euo pipefail

cd ~/src/jira-cli/
source .venv/bin/activate
python3 ./create_issue.py -c config.yaml 2>/tmp/create_issue.log
