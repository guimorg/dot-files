#!/usr/bin/env sh
SPACE_ID="${NAME#space.}"
if [ "$FOCUSED_WORKSPACE" = "$SPACE_ID" ]; then
  sketchybar --set "$NAME" background.drawing=on background.color=0xff89b4fa label.color=0xff11111b
else
  sketchybar --set "$NAME" background.drawing=off label.color=0xffcdd6f4
fi
