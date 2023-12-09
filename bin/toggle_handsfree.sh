#!/usr/bin/env bash

# Toggle between mic + crappy sound vs. no mic + good sound on a Bluetooth headset

set -Eeuo pipefail

a2dp_profile_name="a2dp-sink"
hfp_profile_name="headset-head-unit-msbc"

pw_dump="$(pw-dump)"
headset_device_id="$(echo "$pw_dump" | jq '.[] | select(.info.props."device.form-factor" == "headset").id')"
active_profile_index="$(echo "$pw_dump" | jq ".[] | select(.id == $headset_device_id).info.params.Profile[].index")"
profile_list="$(echo "$pw_dump" | jq ".[] | select(.id == $headset_device_id).info.params.EnumProfile")"
a2dp_profile_index=$(echo "$profile_list" | jq ".[] | select(.name == \"$a2dp_profile_name\").index")
handsfree_profile_index=$(echo "$profile_list" | jq ".[] | select(.name == \"$hfp_profile_name\").index")

if [ "$active_profile_index" = "$a2dp_profile_index" ]; then
    # Switch to handsfree profile (with mic, worse audio)
    wpctl set-profile "$headset_device_id" "$handsfree_profile_index"
    notify-send --urgency=low "Toggle audio profile" "🎤 HFP"
else
    # Switch to A2DP profile (no mic, better audio)
    wpctl set-profile "$headset_device_id" "$a2dp_profile_index"
    notify-send --urgency=low "Toggle audio profile" "🎧 A2DP"
fi
