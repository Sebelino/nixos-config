#!/usr/bin/env bash

set -Eeuo pipefail

headset_sink_id="$(pw-dump | jq '.[] | select(.info.props."media.name" == "Plattan 2 BT").id')"

wpctl set-default "$headset_sink_id"
