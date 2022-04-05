#!/bin/env bash

dunstify "This Month" "$(cal --color=always | sed "s/..7m/<b><span color=\"red\">/;s/..27m/<\/span><\/b>/")
$(date "+%Y/%b/%d %I:%M%p")" && notify-send "Appointments" "$(calcurse -d3 -t)"
