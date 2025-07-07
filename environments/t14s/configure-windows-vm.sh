#!/usr/bin/env bash

set -Eeuo pipefail

vmname="win11"
tmpfile="/tmp/${vmname}.xml"
modified="${tmpfile}.mod"

# Dump current domain XML
virsh dumpxml "$vmname" > "$tmpfile"

# Check if <cpu> section exists
if grep -q "<cpu" "$tmpfile"; then
    echo "✅ <cpu> section found. Checking for svm feature..."

    if grep -q "<feature[^>]*name=['\"]svm['\"]" "$tmpfile"; then
        echo "🔁 svm feature exists — updating to policy='require'..."
        xmlstarlet ed \
            -u "/domain/cpu/feature[@name='svm']/@policy" -v "require" \
            -u "/domain/cpu/@mode" -v "host-passthrough" \
            "$tmpfile" > "$modified"
    else
        echo "➕ Adding svm feature..."
        xmlstarlet ed \
            -u "/domain/cpu/@mode" -v "host-passthrough" \
            -s "/domain/cpu" -t elem -n "featureTMP" -v "" \
            -i "//featureTMP" -t attr -n "policy" -v "require" \
            -i "//featureTMP" -t attr -n "name" -v "svm" \
            -r "//featureTMP" -v "feature" \
            "$tmpfile" > "$modified"
    fi
else
    echo "➕ No <cpu> section. Inserting new one with svm..."
    cpu_block="  <cpu mode='host-passthrough'>
    <feature policy='require' name='svm'/>
  </cpu>"
    sed "/<\/domain>/i\\
$cpu_block
" "$tmpfile" > "$modified"
fi

# Redefine domain
virsh define "$modified"
echo "✅ Domain redefined successfully."
