#!/usr/bin/env bash

file="$1"
width="$2"
height="$3"
x="$4"
y="$5"

case "$(file -Lb --mime-type "$file")" in 
  image/*)
    viu -w "$width" -x "$x" -y "$y" "$1"
    ;;
esac

pistol "$file"
