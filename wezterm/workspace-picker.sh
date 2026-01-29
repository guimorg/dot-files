#!/usr/bin/env bash
set -o pipefail
trap '' PIPE
set +m

ZOXIDE_PATH="${ZOXIDE_PATH:-/run/current-system/sw/bin/zoxide}"
FD_PATH="${FD_PATH:-/opt/homebrew/bin/fd}"
WEZTERM_PATH="${WEZTERM_PATH:-/opt/homebrew/bin/wezterm}"

GREEN="\033[38;2;166;227;161m"
BLUE="\033[38;2;137;180;250m"
PURPLE="\033[38;2;203;166;247m"
YELLOW="\033[38;2;249;226;175m"
GRAY="\033[38;2;108;112;134m"
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"

get_active_workspaces() {
  "$WEZTERM_PATH" cli list --format json 2>/dev/null | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    workspaces = set()
    for item in data:
        ws = item.get('workspace', 'default')
        workspaces.add(ws)
    print(json.dumps(list(workspaces)))
except:
    print('[]')
"
}

ACTIVE_WS=$(get_active_workspaces)

format_entry() {
  local path=$1
  local basename=$(basename "$path")
  local display_path="${path/#$HOME/\~}"
  
  local is_active=$(echo "$ACTIVE_WS" | python3 -c "
import json, sys
ws = '$basename'
data = json.loads(sys.stdin.read())
print('1' if ws in data else '0')
")
  
  if [ "$is_active" = "1" ]; then
    echo -e "${GREEN}●${RESET}  ${GREEN}${BOLD}${basename}${RESET}$(printf '%*s' $((35-${#basename})) '')  ${DIM}active${RESET}      ${GRAY}${display_path}${RESET}|${path}"
  else
    echo -e "${BLUE}○${RESET}  ${BOLD}${basename}${RESET}$(printf '%*s' $((35-${#basename})) '')                ${GRAY}${display_path}${RESET}|${path}"
  fi
}

{
  "$ZOXIDE_PATH" query -l 2>/dev/null || true
  "$FD_PATH" -H -t d '^\.git$' "$HOME/projects" -d 6 2>/dev/null | xargs -I{} dirname "{}"
} | awk '!seen[$0]++' | while IFS= read -r dir; do
  if [ -d "$dir" ]; then
    format_entry "$dir" 2>/dev/null || true
  fi
done 2>/dev/null | \
  fzf \
    --ansi \
    --border=rounded \
    --border-label=" 󰉋  Project Selector " \
    --border-label-pos=3 \
    --pointer='▶ ' \
    --marker='✓ ' \
    --prompt='  ' \
    --header=$'\n  ● = active   ○ = available   ▶ = selected\n  Enter = open/switch   Esc/q = quit\n' \
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
    --color='pointer:#a6e3a1,marker:#a6e3a1,prompt:#cba6f7,header:#6c7086,border:#89b4fa,label:#cba6f7,fg:#cdd6f4,fg+:#cdd6f4,bg+:#313244,hl:#f38ba8,hl+:#f38ba8' \
    --bind='q:abort,ctrl-c:abort' \
    | cut -d'|' -f2
