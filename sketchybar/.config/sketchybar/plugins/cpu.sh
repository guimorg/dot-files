#!/usr/bin/env sh
CPU=$(ps -A -o %cpu | awk 'NR>1 {s+=$1} END {printf "%.0f%%", s}')
sketchybar --set "$NAME" label="$CPU"
