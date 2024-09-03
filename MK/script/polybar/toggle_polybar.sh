#!/bin/bash
# Toggles polybar and resizes bspwm padding.

LOCK_FILE="/tmp/bar.lck"

if [[ ! -f "$LOCK_FILE" ]]; then
    touch "$LOCK_FILE"
    polybar-msg cmd hide; sleep 0.4
    bspc config top_padding 0
else
    rm "$LOCK_FILE"
    bspc config top_padding 5

    sleep 0.4; polybar-msg cmd show
fi
