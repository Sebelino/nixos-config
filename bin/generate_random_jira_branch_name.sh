#!/usr/bin/env bash

set -euo pipefail

jira_issue_path="/tmp/jira-currently-assigned-issue.txt"

if [ ! -f "$jira_issue_path" ]; then
    "$HOME/bin/jira-refresh-currently-assigned-issue.sh"
fi

jira_issue=$(cat "$jira_issue_path")

words="$(shuf -n2 /usr/share/dict/words | sed "s/'.*//" | tr '[:upper:]' '[:lower:]' | tr '\n' '-')"
words=${words::-1}

today="$(date '+%m-%d')"

echo "${jira_issue}-${words}-${today}-Sebelino"
