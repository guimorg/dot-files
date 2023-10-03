#!/usr/bin/env bash

DIR="$HOME/.config/polybar"

killall polybar
sleep 2

for m in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$m polybar --reload power &
	MONITOR=$m polybar --reload clock &
	MONITOR=$m polybar --reload spotify &
	MONITOR=$m polybar --reload workspaces &
	MONITOR=$m polybar --reload cava &
	MONITOR=$m polybar --reload sound &
	# MONITOR=$m polybar --reload weather &
	MONITOR=$m polybar --reload settings &
	sleep 1
done
