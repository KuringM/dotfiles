#!/bin/bash

# Get id of touchpad
id=`xinput list | grep "Touchpad" | cut -d'=' -f2 | cut -d'[' -f1`

# my first test
#shutdown_touchpad ()
#{
#	xinput --disable $id
#	touch $name
#}
#name="/tmp/Log.txt"
#if [ -f $name ]; thenQQQQQ;
#	xinput --enable $id
#	rm $name
#	echo "turn on touchpad"
#else
#	shutdown_touchpad
#	echo "shut down touchpad"
#fi
status=`xinput --list-props $id | grep "Device Enabled" | cut -d':' -f2`
if [ $status -eq 1 ]; then
	xinput set-prop $id "Device Enabled" 0
else
	xinput set-prop $id "Device Enabled" 1
fi
