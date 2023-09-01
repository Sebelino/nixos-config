#!/usr/bin/env bash

symlink() {
    src="$scriptdir/$1"
    dst="$2"

    dstdir="$(dirname "$dst")"
    mkdir -p "$dstdir"

    if [ -h "$dst" -a ! -e "$dst" ]; then
        echo "Error: Symlink is broken: $dst"
        exit 1
    elif [ -L "$dst" ]; then
        echo "Already symlinked: $dst"
    elif [ -f "$dst" ]; then
        echo "Error: Already exists and is a file: $dst" >&2
        exit 1
    else
        echo "Symlinking: $src -> $dst"
        ln -s "$src" "$dst"
    fi
}

copy() {
    src="$scriptdir/$1"
    dst="$2"

    if [ ! -f "$dst" ]; then
        echo "Copying: $src -> $dst"
        cp "$src" "$dst"
    else
        echo "Already present: $dst"
    fi
}
