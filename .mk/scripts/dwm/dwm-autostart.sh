#!/bin/bash

/bin/bash ~/MK/mbin/dwm/dwm-status.sh &
/bin/bash ~/MK/mbin/general/tap_to_click.sh &
/bin/bash ~/MK/mbin/general/inverse_scroll.sh &

/bin/bash ~/MK/mbin/general/setxmodmap-colemak.sh &
/bin/bash ~/MK/mbin/general/onlyExternalDisplay.sh &
/bin/bash ~/MK/mbin/general/wp_autochange.sh &

#picom -o 0.95 -i 0.88 --detect-rounded-corners --vsync --blur-background-fixed -f -D 5 -c -b
picom -b
nm-applet &
blueman-applet &
xfce4-power-manager &
~/MK/mbin/dwm/dwm-autostart_wait.sh &
fcitx5 &
flameshot &
optimus-manager-qt &
