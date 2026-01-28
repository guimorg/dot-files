#!/usr/bin/env sh
VOL=$(osascript -e 'output volume of (get volume settings)')
MUTED=$(osascript -e 'muted of (get volume settings)')
if [ "$MUTED" = "true" ]; then
  ICON=""
else
  if [ "$VOL" -ge 60 ]; then
    ICON=""
  elif [ "$VOL" -ge 30 ]; then
    ICON=""
  else
    ICON=""
  fi
fi
sketchybar --set "$NAME" icon="$ICON" label="${VOL}%"
