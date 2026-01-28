#!/usr/bin/env sh
is_running() {
  APP_NAME="$1"
  if osascript -e "application \"$APP_NAME\" is running" 2>/dev/null | grep -q true; then
    return 0
  fi
  if pgrep -x "$APP_NAME" >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

if is_running "AeroSpace" || is_running "Aerospace" || is_running "aerospace"; then
  sketchybar --set app.aerospace drawing=on
else
  sketchybar --set app.aerospace drawing=off
fi

if is_running "Kap" || is_running "kap"; then
  sketchybar --set app.kap drawing=on
else
  sketchybar --set app.kap drawing=off
fi

if is_running "Proton Pass" || is_running "ProtonPass" || is_running "proton-pass"; then
  sketchybar --set app.protonpass drawing=on
else
  sketchybar --set app.protonpass drawing=off
fi

if is_running "Proton VPN" || is_running "ProtonVPN" || is_running "ProtonVPNApp"; then
  sketchybar --set app.protonvpn drawing=on
else
  sketchybar --set app.protonvpn drawing=off
fi

if is_running "Cursor" || is_running "cursor"; then
  sketchybar --set app.cursor drawing=on
else
  sketchybar --set app.cursor drawing=off
fi
