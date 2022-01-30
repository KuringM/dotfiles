#!/bin/bash
# Toggles bspwm focus mode.
# modify bspwm border_width window_gap

LOCK_FILE="/tmp/bspwm-tglGap.lck"

if [[ ! -f "$LOCK_FILE" ]]; then
    touch "$LOCK_FILE"
		bspc config border_width         2
		bspc config window_gap           5
else
    rm "$LOCK_FILE"
		bspc config border_width         0
		bspc config window_gap           0

fi
