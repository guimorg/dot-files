#!/usr/bin/env sh
PLAYER=""
if osascript -e 'application "Music" is running' | grep -q true; then
  PLAYER="Music"
elif osascript -e 'application "Spotify" is running' | grep -q true; then
  PLAYER="Spotify"
fi
if [ -z "$PLAYER" ]; then
  sketchybar --set "$NAME" label=""
  exit 0
fi
STATE=$(osascript -e "tell application \"$PLAYER\" to player state as string")
if [ "$STATE" != "playing" ]; then
  sketchybar --set "$NAME" label=""
  exit 0
fi
ARTIST=$(osascript -e "tell application \"$PLAYER\" to artist of current track as string")
TITLE=$(osascript -e "tell application \"$PLAYER\" to name of current track as string")
if [ -n "$TITLE" ]; then
  sketchybar --set "$NAME" label="$ARTIST - $TITLE"
else
  sketchybar --set "$NAME" label=""
fi
