#!/usr/bin/env bash

LOC=$(readlink -f "$0")
DIR=$(dirname "$LOC")
export IDENTIFIER="unicode"

. "$DIR/statusbar/sb-backlight"
. "$DIR/statusbar/sb-clock"
. "$DIR/statusbar/sb-kernel"
. "$DIR/statusbar/sb-nettraf"
. "$DIR/statusbar/sb-memory"
. "$DIR/statusbar/sb-volume"

#xsetroot -name "$(sb-nettraf) $(sb-backlight) $(sb-volume) $(sb-clock) $(sb-memory) $(sb-kernel)"
xsetroot -name "$(sb-backlight) $(sb-volume) $(sb-clock) $(sb-memory) $(sb-kernel)"
