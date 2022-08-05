#!/usr/bin/env sh

pkill trayer

trayer \
    --SetDockType true \
    --expand true \
    --edge top \
    --align left \
    --width 7 \
    --height 17 \
    --tint 0x000000 \
    --transparent true \
    --alpha 0 \
    &!
