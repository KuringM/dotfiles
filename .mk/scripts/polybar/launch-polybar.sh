#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
if [ "$1" == "test" ]
then
	polybar -c $HOME/.config/polybar/test/bar main 2>&1 | tee -a /tmp/polybar_test.log & disown
elif [ "$1" == "light-td" ]
then
	polybar -c $HOME/.config/polybar/Sky\&Sea/bar-light top 2>&1 | tee -a /tmp/polybar.log & disown
	polybar -c $HOME/.config/polybar/Sky\&Sea/bar-light down 2>&1 | tee -a /tmp/polybar.log & disown
elif [ "$1" == "dark-td" ]
then
	polybar -c $HOME/.config/polybar/Sky\&Sea/bar-dark top 2>&1 | tee -a /tmp/polybar.log & disown
	polybar -c $HOME/.config/polybar/Sky\&Sea/bar-dark down 2>&1 | tee -a /tmp/polybar.log & disown
elif [ "$1" == "dark" ]
then
	polybar -c $HOME/.config/polybar/Sky\&Sea/bar-dark dark 2>&1 | tee -a /tmp/polybar.log & disown
else 
	polybar -c $HOME/.config/polybar/Sky\&Sea/bar-light light 2>&1 | tee -a /tmp/polybar.log & disown
fi

echo "Bars launched..."
