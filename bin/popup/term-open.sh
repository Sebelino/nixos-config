#!/usr/bin/env bash

while true; do
  if ! read -rep "> " cmd; then
    exit 0
  fi

  # Skip empty lines
  [[ -z "$cmd" ]] && continue

  eval "$cmd"
  status=$?

  if [[ $status -eq 0 ]]; then
    sleep 0.5
    exit 0
  else
    echo "Command failed with status $status. Try again."
    echo
  fi
done
