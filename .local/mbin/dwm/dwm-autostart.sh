#!/bin/bash

/bin/bash ~/.local/mbin/dwm/dwm-status.sh &
/bin/bash ~/.local/mbin/dwm/dwm-wp_autochange.sh &
#picom -o 0.95 -i 0.88 --detect-rounded-corners --vsync --blur-background-fixed -f -D 5 -c -b
picom -b
/bin/bash ~/.local/mbin/dwm/dwm-tap_to_click.sh &
/bin/bash ~/.local/mbin/dwm/dwm-inverse_scroll.sh &
/bin/bash ~/.local/mbin/dwm/setxmodmap-colemak.sh &
nm-applet &
xfce4-power-manager &
~/.local/mbin/dwm/dwm-autostart_wait.sh &
fcitx5 &
flameshot &
