#!/bin/sh

out=`setxkbmap -query | grep solemak`

if [ -z "$out" ]; then
    setxkbmap solemak
else
    # TODO Create this one. Same as SE except the button for toggling is the same as for Solemak.
    setxkbmap se_sebelino
fi

