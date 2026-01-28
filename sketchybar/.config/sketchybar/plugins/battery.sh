#!/usr/bin/env sh
PERCENT=$(pmset -g batt | awk -F';' 'NR==2 {gsub(/[^0-9]/, "", $1); print $1}')
if [ -z "$PERCENT" ]; then
  sketchybar --set "$NAME" label="--"
  exit 0
fi
if [ "$PERCENT" -ge 90 ]; then
  ICON=""
elif [ "$PERCENT" -ge 60 ]; then
  ICON=""
elif [ "$PERCENT" -ge 30 ]; then
  ICON=""
else
  ICON=""
fi
if pmset -g batt | grep -q "AC Power"; then
  ICON=""
fi
sketchybar --set "$NAME" icon="$ICON" label="${PERCENT}%"
