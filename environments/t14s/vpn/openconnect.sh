#!/usr/bin/env bash

# This script assumes your smartcard is inserted.
# Requires following packages to be installed:
# extra/pcsc-tools

set -euo pipefail

VPN_SERVER="sam.sll.se"
OPENCONNECT_BIN_PATH="$HOME/src/openconnect/openconnect"
TOKEN_URL_PATH=/tmp/tokenurl.txt # Cache the token URL to avoid unnecessary p11tool calls
CERT_TOKEN_URL_PATH=/tmp/certtokenurl.txt # Cache the token URL to avoid unnecessary p11tool calls
TUN_IFACE="vpn0" # Will be shown in the output of `ip link show`

set -x

if ! pcsc_scan -c | grep "Card inserted"; then
    echo "Please insert smart card."
    exit 1
fi

if [ ! -d "/sys/class/net/${TUN_IFACE}" ]; then
    # If not already done, create a network interface for OpenConnect to use. Will disappear on reboot.
    # See https://www.infradead.org/openconnect/nonroot.html
    sudo ip tuntap add "$TUN_IFACE" mode tun user "$USER"
fi

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
# Add --dump-http-traffic, --printcookie, -vvvv if needed
"$OPENCONNECT_BIN_PATH" \
    -c "$certtokenurl" \
    --protocol=pulse \
    --useragent 'Pulse-Secure/22.2.1.1295' \
    --os=win \
    --authgroup eTjänstekort \
    -i vpn0 \
    -s 'sudo -E /etc/vpnc/vpnc-script' \
    "$VPN_SERVER"
