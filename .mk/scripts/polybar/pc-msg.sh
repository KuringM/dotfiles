#!/bin/env bash

while getopts ":cmd" o; do case "${o}" in
	c) notify-send "🖥 CPU hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head)\\n(100% per core)" ;;
	m) notify-send "🧠 Memory hogs" "$(ps axch -o cmd:15,%mem --sort=-%mem | head)" ;;
	d) notify-send "💽 Disk space" "$(df -h --output=target,used,size)" ;;
esac done

