#!/usr/bin/env bash
set -eo pipefail

LOGFILE="/tmp/wezterm-picker-wrapper.log"
echo "=== $(date) ===" >> "$LOGFILE"

SELECTED=$("$HOME/.local/bin/workspace-picker.sh" 2>> "$LOGFILE") || true
echo "SELECTED: '$SELECTED'" >> "$LOGFILE"
echo "Exit code: $?" >> "$LOGFILE"

if [ -n "${SELECTED:-}" ] && [ "$SELECTED" != "" ]; then
  echo "Sending to Lua: $SELECTED" >> "$LOGFILE"
  printf "\033]1337;SetUserVar=%s=%s\007" "WORKSPACE_SELECTED" "$(echo -n "$SELECTED" | base64)"
  sleep 0.5
else
  echo "No selection - user cancelled" >> "$LOGFILE"
fi

exit 0
