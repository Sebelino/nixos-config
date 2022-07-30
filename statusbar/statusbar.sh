#!/usr/bin/env sh

pkill xmobar

pkill trayer

xmobar &!

sleep 0.2 # Race condition where xmobar might cover up trayer if the latter is faster to start

trayer \
    --SetDockType true \
    --expand true \
    --edge top \
    --align right \
    --width 10 \
    --height 17 \
    --distancefrom right \
    --distance 150 \
    --tint 0x000000 \
    --transparent true \
    --alpha 0 \
    &!
