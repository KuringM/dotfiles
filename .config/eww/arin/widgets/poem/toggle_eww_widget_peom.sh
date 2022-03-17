#!/bin/bash

## Files and CMD
FILE="/tmp/eww_launch_poem.widget"
CFG="$HOME/.config/eww/arin/widgets/poem"
EWW=`which eww`

## Run eww daemon if not running already
if [[ ! `pidof eww` ]]; then
	${EWW} daemon
	sleep 1
fi

## Open widgets
run_eww() {
	${EWW} --config "$CFG" open-many poem
}

## Launch or close widgets accordingly
if [[ ! -f "$FILE" ]]; then
	touch "$FILE"
	run_eww
else
	${EWW} --config "$CFG" close poem
	rm "$FILE"
fi
