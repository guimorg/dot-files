# Ghostty

GPU-accelerated terminal emulator. Config stowed to `~/.config/ghostty/config`.

## Install

Managed via `pkgs.ghostty-bin` in nixpkgs — a repackaging of the official `.dmg` binary. Nix cannot compile Ghostty from source on macOS (requires Swift 6 + xcodebuild), so `ghostty-bin` is the correct nixpkgs package for Darwin. Listed in `darwin-configuration.nix` and the devShell.

After `darwin-rebuild switch`, find it in `~/Applications/Nix Apps/Ghostty.app` or launch via Spotlight.

## Opening

```bash
# From terminal
ghostty

# Or open the .app
open ~/Applications/Nix\ Apps/Ghostty.app
```

Ghostty opens a new window directly — no server process, no attach step. Just open it.

## Daily use

Ghostty is intentionally minimal: it's a terminal emulator, not a multiplexer. Run `herdr` inside it for pane/session management (see `herdr/README.md`).

Useful built-in commands:

```bash
ghostty +list-themes       # browse built-in themes
ghostty +list-fonts        # list fonts Ghostty can see
ghostty +show-config       # dump active config (with defaults merged in)
```

## Keybindings (defaults)

| Key | Action |
|-----|--------|
| `cmd+n` | New window |
| `cmd+t` | New tab |
| `cmd+w` | Close tab/window |
| `cmd+shift+[` / `]` | Previous / next tab |
| `cmd++` / `cmd+-` | Increase / decrease font size |
| `cmd+0` | Reset font size |
| `cmd+k` | Clear scrollback |
| `cmd+shift+c` | Copy |
| `cmd+shift+v` | Paste |

## Config

Key settings in `~/.config/ghostty/config`:

| Option | Value |
|--------|-------|
| Font | JetBrainsMono Nerd Font 15pt |
| Theme | catppuccin-mocha |
| Background opacity | 85% with macOS blur |
| Cursor | blinking bar |
| Shell | /bin/zsh |

To tweak: edit `ghostty/.config/ghostty/config` in this repo (symlinked, changes take effect on next Ghostty window). No restart needed for most settings — new windows pick up config changes immediately.

## Updating

`ghostty-bin` tracks the version in nixpkgs-unstable. It updates when you run:

```bash
nix flake update
darwin-rebuild switch --flake .#darwin-system
```
