# Herdr

[Herdr](https://herdr.dev) is an agent-aware terminal multiplexer. It runs **inside** Ghostty and provides persistent pane/tab sessions plus live awareness of AI coding agents (Claude Code, Codex, Cursor, etc.).

## What it is

- **Not** a terminal emulator — it runs inside Ghostty as a process
- Persistent PTY sessions that survive closing Ghostty (like tmux)
- Tracks agent state per pane: blocked / working / done / idle
- SSH-attachable: attach from any machine or phone
- CLI + socket API for scripting

## Opening for the first time

```bash
# Inside Ghostty, just run:
herdr
```

This starts the Herdr server and attaches you to it. On subsequent opens, `herdr` re-attaches to the running session. Your panes survive closing Ghostty.

To explicitly start a new session:

```bash
herdr new-session
```

To list and attach to named sessions:

```bash
herdr list-sessions
herdr attach <session-name>
```

## Daily workflow

1. Open Ghostty
2. Run `herdr` — you're back where you left off
3. Create panes/tabs with the prefix bindings below
4. Open the sidebar (`ctrl+b b`) to see agent states
5. Use `ctrl+b alt+c` to spawn Claude Code in a new pane

## Structure

```
Session  →  Workspaces  →  Tabs  →  Panes
```

Think of **workspaces** as projects (e.g. "api", "frontend"), **tabs** as contexts within a project, **panes** as splits.

## Prefix key: `ctrl+b`

Press `ctrl+b`, release, then press the second key.

### Workspaces

| Key | Action |
|-----|--------|
| `ctrl+b w` | Workspace picker — navigate/switch |
| `ctrl+b shift+n` | New workspace (prompts for name) |
| `ctrl+b shift+w` | Rename current workspace |
| `ctrl+b shift+d` | Close current workspace |
| `ctrl+b g` | Go to... (jump by name) |

### Tabs

| Key | Action |
|-----|--------|
| `ctrl+b c` | New tab |
| `ctrl+b n` | Next tab |
| `ctrl+b p` | Previous tab |
| `ctrl+b 1`…`9` | Jump to tab by number |
| `ctrl+b shift+t` | Rename current tab |
| `ctrl+b shift+x` | Close current tab |

### Panes

| Key | Action |
|-----|--------|
| `ctrl+b v` | Split pane right |
| `ctrl+b -` | Split pane down |
| `ctrl+b h/j/k/l` | Focus pane left/down/up/right |
| `ctrl+b x` | Close pane |
| `ctrl+b z` | Zoom pane (toggle fullscreen) |
| `ctrl+b r` | Resize mode |

### Session & misc

| Key | Action |
|-----|--------|
| `ctrl+b b` | Toggle agent sidebar |
| `ctrl+b [` | Enter copy mode (scroll / select) |
| `ctrl+b alt+g` | Open lazygit in a new pane |
| `ctrl+b alt+c` | Open Claude Code in a new pane |
| `ctrl+b ?` | Help |
| `ctrl+b q` | Detach (Herdr stays running) |

## CLI reference

```bash
herdr                          # launch / reattach
herdr --session myproject      # open named session

# workspaces
herdr workspace list
herdr workspace create --label "api" --focus
herdr workspace rename <id> "new-name"
herdr workspace close <id>

# tabs
herdr tab create --label "tests" --focus
herdr tab list

# panes
herdr pane split --direction right   # split current pane right
herdr pane split --direction down
herdr pane zoom --toggle             # zoom current pane
herdr pane read <id> --lines 50      # read pane output (great for scripting)
```

## Typical workflow

```
herdr                         # enter
ctrl+b shift+n  →  "api"      # new workspace for your project
ctrl+b c        →  "editor"   # tab for nvim
ctrl+b v                      # split right for shell
ctrl+b alt+c                  # open claude in a pane
ctrl+b w                      # switch between workspaces
```

## Agent sidebar

`ctrl+b b` opens the sidebar showing all running agents grouped by workspace with their current state. Agents needing attention (blocked / requesting input) surface at the top when `agent_panel_sort = "priority"`.

## Session persistence

- Closing Ghostty does **not** kill your session — just detach with `ctrl+b d` or close the window
- On restart, run `herdr` to re-attach
- `resume_agents_on_restore = true` restarts Claude Code and other supported agents in their previous state
- `pane_history = true` replays recent pane output after reconnect

## Configuration

Config at `~/.config/herdr/config.toml` (stowed from this repo).

```bash
herdr --default-config          # see all defaults
herdr server reload-config      # reload without restarting
```

## Updating the version pin

Herdr is pinned at v0.7.1 via the flake input.

1. Check https://github.com/ogulcancelik/herdr/releases for new versions
2. Edit `flake.nix`:
   ```nix
   herdr.url = "github:ogulcancelik/herdr/vX.Y.Z";
   ```
3. Apply:
   ```bash
   nix flake update herdr
   darwin-rebuild switch --flake .#darwin-system
   ```
