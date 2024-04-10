#!/usr/bin/env bash

# Usage:
# ./get-tls-chain.sh google.com
# ./get-tls-chain.sh google.com 443

set -Eeuo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

domain="$1"
port="${2:-443}"

ces() {
  openssl s_client -showcerts -servername "$domain" -connect "${domain}:${port}" </dev/null 2>/dev/null
}

ces "$domain" "$port" | "$scriptdir/extract-certs.sh"
