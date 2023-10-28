#!/usr/bin/env bash

set -euo pipefail

VPN_SERVER="sam.sll.se"
OPENCONNECT_BIN_PATH="$HOME/src/openconnect/openconnect"
TOKEN_URL_PATH=/tmp/tokenurl.txt
CERT_TOKEN_URL_PATH=/tmp/certtokenurl.txt

set -x

if [ -f "$TOKEN_URL_PATH" ]; then
    tokenurl="$(cat "$TOKEN_URL_PATH")"
else
    tokenurl="$(p11tool --login --list-all | grep Legit || true)"
    echo -n "$tokenurl" > "$TOKEN_URL_PATH"
fi

if [ -f "$CERT_TOKEN_URL_PATH" ]; then
    certtokenurl=$(cat "$CERT_TOKEN_URL_PATH")
else
    # Prompts for PIN code
    certtokenurl=$(p11tool --login --list-certs "$tokenurl" | grep "URL.*%43" | cut -d ' ' -f2)
    echo -n "$certtokenurl" > "$CERT_TOKEN_URL_PATH"
fi

# Prompts for PIN code
"$OPENCONNECT_BIN_PATH" \
    -c "$certtokenurl" \
    --protocol=pulse \
    --useragent 'Pulse-Secure/22.2.1.1295' \
    --os=win \
    --authgroup eTjänstekort \
    -i vpn0 \
    -s 'sudo -E /etc/vpnc/vpnc-script' \
    --printcookie \
    --dump-http-traffic \
    -vvvv \
    "$VPN_SERVER"
