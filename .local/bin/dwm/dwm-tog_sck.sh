#!/bin/bash

result=$(ps ax|grep -v grep|grep screenkey)
if [ "$result" == "" ]; then
  eval "screenkey --bg-color white --font-color black --font SauceCodePro --opacity 0.9 -t 2 &" && notify-send "ScreenKey" "On"
else
  eval "killall screenkey" && notify-send "ScreenKey" "Off"
fi
