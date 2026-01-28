#!/usr/bin/env sh
is_running() {
  osascript -e "application \"$1\" is running" 2>/dev/null | grep -q true
}

if is_running "AeroSpace" || is_running "Aerospace"; then
  sketchybar --set app.aerospace drawing=on
else
  sketchybar --set app.aerospace drawing=off
fi

if is_running "Kap"; then
  sketchybar --set app.kap drawing=on
else
  sketchybar --set app.kap drawing=off
fi

if is_running "Proton Pass"; then
  sketchybar --set app.protonpass drawing=on
else
  sketchybar --set app.protonpass drawing=off
fi

if is_running "Proton VPN"; then
  sketchybar --set app.protonvpn drawing=on
else
  sketchybar --set app.protonvpn drawing=off
fi

if is_running "Cursor"; then
  sketchybar --set app.cursor drawing=on
else
  sketchybar --set app.cursor drawing=off
fi
