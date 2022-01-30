#!/usr/bin/env bash

/bin/bash ~/.local/mbin/general/setxmodmap-colemak.sh &
/bin/bash ~/.local/mbin/general/onlyExternalDisplay.sh &
/bin/bash ~/.local/mbin/general/wp_autochange.sh &
/bin/bash ~/.local/mbin/polybar/launch-polybar.sh &

killall dunst; dunst &
killall picom; picom -b
killall nm-applet; nm-applet &
killall blueman-applet; blueman-applet &
killall fcitx5; fcitx5 &
killall flameshot; flameshot &
killall optimus-manager-qt; optimus-manager-qt &

pgrep -x sxhkd > /dev/null || sxhkd &
