#!/usr/bin/env bash
set -euo pipefail

DATAFILE="$1"

GREEN="\033[38;2;166;227;161m"
PURPLE="\033[38;2;203;166;247m"
BLUE="\033[38;2;137;180;250m"
YELLOW="\033[38;2;249;226;175m"
GRAY="\033[38;2;108;112;134m"
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"

RESULT=$(while IFS='|' read -r ws marker panes cwd; do
  if [ "$marker" = "CURRENT" ]; then
    icon="●"
    ws_color="$GREEN"
  else
    icon="○"
    ws_color="$BLUE"
  fi
  
  display_cwd="${cwd/#$HOME/\~}"
  
  echo -e "${ws_color}${icon}${RESET}  ${ws_color}${BOLD}${ws}${RESET}$(printf '%*s' $((35-${#ws})) '')  ${PURPLE}${BOLD}${panes}${RESET}${DIM} panes${RESET}  ${GRAY}${display_cwd}${RESET}|${ws}"
done < "$DATAFILE" | \
  fzf \
    --ansi \
    --border=rounded \
    --border-label=" 󰖯  Workspace Manager " \
    --border-label-pos=3 \
    --pointer='▶ ' \
    --marker='✓ ' \
    --prompt='  ' \
    --header=$'\n  ● = active   ○ = inactive   ▶ = selected\n  Enter = switch   Ctrl+d = delete   Esc/q = quit\n' \
    --header-first \
    --height=70% \
    --reverse \
    --delimiter='|' \
    --with-nth=1 \
    --layout=reverse \
    --info=inline \
    --no-scrollbar \
    --padding=1 \
    --margin=1 \
    --expect=ctrl-d \
    --color='pointer:#a6e3a1,marker:#a6e3a1,prompt:#cba6f7,header:#6c7086,border:#89b4fa,label:#cba6f7,fg:#cdd6f4,fg+:#cdd6f4,bg+:#313244,hl:#f38ba8,hl+:#f38ba8' \
    --bind='q:abort,ctrl-c:abort')

rm -f "$DATAFILE"

KEY=$(echo "$RESULT" | head -1)
SELECTED=$(echo "$RESULT" | tail -1 | cut -d'|' -f2)

if [ -n "${SELECTED:-}" ]; then
  if [ "$KEY" = "ctrl-d" ]; then
    printf "\033]1337;SetUserVar=%s=%s\007" "WORKSPACE_DELETE" "$(echo -n "$SELECTED" | base64)"
  else
    printf "\033]1337;SetUserVar=%s=%s\007" "WORKSPACE_SWITCH" "$(echo -n "$SELECTED" | base64)"
  fi
  sleep 0.5
fi

rm -f "$DATAFILE"

if [ -n "${SELECTED:-}" ]; then
  printf "\033]1337;SetUserVar=%s=%s\007" "WORKSPACE_SWITCH" "$(echo -n "$SELECTED" | base64)"
  sleep 0.5
fi
