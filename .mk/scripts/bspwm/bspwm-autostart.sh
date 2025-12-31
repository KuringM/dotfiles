#!/usr/bin/env bash

## some feature
## wallpaper auto change
pgrep -f wp_autochange.sh || /bin/bash ~/MK/mbin/general/wp_autochange.sh &
## use colemak keyboard
/bin/bash ~/MK/mbin/general/setxmodmap-colemak.sh

## launch eww bar
#/bin/bash /home/kuring/MK/mbin/eww/eww_autoupdate.sh
#/bin/bash ~/.config/eww/arin/launch_bar

/bin/bash ~/MK/mbin/polybar/launch-polybar.sh dark

#/bin/bash ~/MK/mbin/general/onlyExternalDisplay.sh
#/bin/bash ~/MK/mbin/polybar/polybar_toggle.sh



# application
pgrep dunst || dunst &
pgrep picom || picom -b
pgrep nm-applet || nm-applet &
#pgrep blueman-applet || blueman-applet &
pgrep fcitx5 || fcitx5 &
#pgrep flameshot || flameshot &
pgrep optimus-manager-qt || optimus-manager-qt &

pgrep -x sxhkd > /dev/null || sxhkd &
