#!/bin/bash

setxkbmap us colemak -option -option caps:swapescape -option ctrl:swap_lalt_lctl -option lv3:ralt_alt && notify-send "Set Colemak Keyboard"
xset r rate 250 30

