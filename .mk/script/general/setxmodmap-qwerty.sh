#!/bin/bash

#setxkbmap us -option caps:swapescape -option ctrl:swap_lalt_lctl -option lv3:ralt_alt && notify-send "Set QWERTY Keyboard"
setxkbmap us -option -option ctrl:swap_lalt_lctl -option caps:swapescape && notify-send "Set QWERTY Keyboard"

xset r rate 250 30


