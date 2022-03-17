#!/usr/bin/env bash

## scripts
/home/kuring/.local/mbin/eww/eww_autoupdate.sh
pgrep -f wp_autochange.sh || /bin/bash ~/.local/mbin/general/wp_autochange.sh &
#/bin/bash ~/.local/mbin/polybar/launch-polybar.sh dark
sleep 1s; /bin/bash ~/.config/eww/arin/launch_bar
/bin/bash ~/.local/mbin/general/setxmodmap-colemak.sh
#/bin/bash ~/.local/mbin/general/onlyExternalDisplay.sh
#/bin/bash ~/.local/mbin/polybar/polybar_toggle.sh

# application
pgrep dunst || dunst &
pgrep picom || picom -b
pgrep nm-applet || nm-applet &
#pgrep blueman-applet || blueman-applet &
pgrep fcitx5 || fcitx5 &
#pgrep flameshot || flameshot &
pgrep optimus-manager-qt || optimus-manager-qt &

pgrep -x sxhkd > /dev/null || sxhkd &
