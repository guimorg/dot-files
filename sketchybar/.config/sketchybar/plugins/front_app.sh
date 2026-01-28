#!/usr/bin/env sh
if [ -n "$INFO" ]; then
  sketchybar --set "$NAME" label="$INFO"
else
  sketchybar --set "$NAME" label=""
fi
