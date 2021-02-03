#!/bin/sh

target="$1"

function fn() {
    jsonfile="$1"
    temp_dst="/tmp/tmp.json"

    cat "$jsonfile" | jq --indent 4 > "$temp_dst"
    #cat "$jsonfile" | python -mjson.tool > "$temp_dst"

    cat "$temp_dst" > "$jsonfile"

    rm "$temp_dst"
}

for f in $(find "$target" -name "*.json"); do
    echo "Formatting $f..."
    fn "$f"
done
