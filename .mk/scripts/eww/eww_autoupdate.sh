#!/bin/bash

while true; do
	/bin/bash ~/.config/eww/arin/scripts/weather_info --getdata
	/bin/bash ~/.config/eww/arin/scripts/poem_info --update
	sleep 15m
done
