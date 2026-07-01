# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Overview

Modern macOS dotfiles repository using Nix ecosystem for declarative, reproducible system and development environment management. Primary user is `thexuh` on Apple Silicon (aarch64-darwin).

## Architecture

### Three-Layer Configuration System

1. **nix-darwin** (`darwin-configuration.nix`) - System-level macOS configuration
   - System packages, fonts, macOS defaults
   - LaunchDaemons/Agents (miniflux service)
   - Aerospace window manager configuration
   - System keyboard settings (Caps Lock → Control)

2. **home-manager** (`home.nix`) - User-level configuration
   - Shell integrations (direnv, fzf, zoxide)
   - Session variables and PATH
   - Custom scripts deployment to `~/.local/bin`

3. **GNU Stow** (via flake.nix) - Dotfiles symlinking
   - Application configs from subdirectories: direnv, dbt, emacs, bash, config, git, tmux, vim, zsh, ohmyposh, kanata, wezterm, Codex
   - Automatically applied on first `nix develop` activation

### Nix Flake Structure

- **inputs**: nixpkgs-unstable, nix-darwin, home-manager, fenix (Rust toolchain), flake-utils
- **darwinConfigurations**: System configuration for hostname "darwin-system"
- **devShells.default**: Development environment with auto-installation hooks
- **packages**: Helper scripts (install/reinstall/uninstall dotfiles, install fonts/apps)

## Common Commands

### System Management (nix-darwin)

```bash
# Apply system configuration changes
darwin-rebuild switch --flake .#darwin-system

# Build without activating
darwin-rebuild build --flake .#darwin-system

# Initial installation (first time only)
./install-nix-darwin.sh
```

### Development Environment

```bash
# Enter development shell (auto-installs dotfiles on first run)
nix develop

# Or use direnv for automatic activation
direnv allow

# Update all dependencies
nix flake update
```

### Dotfiles Management

```bash
# Reinstall all dotfiles
nix run .#reinstall

# Uninstall dotfiles
nix run .#uninstall

# Reinstall fonts
nix run .#install-fonts

# Reinstall macOS apps (to ~/Applications/Nix Apps/)
nix run .#install-apps
```

### Miniflux Service

RSS reader service configured as LaunchAgent, runs via docker-compose:

```bash
# Service logs location
~/Library/Logs/miniflux.{out,err}.log

# Manual control
cd services/miniflux
docker-compose up -d    # start
docker-compose down     # stop
docker-compose logs -f  # view logs
```

Note: Add `127.0.0.1 miniflux.local` to `/etc/hosts` manually (not yet automated).

## Configuration Locations

### Stow-managed Dotfiles

Each subdirectory contains dotfiles deployed to `$HOME`:

- **bash/**: `.bashrc`, `.profile`, `.bash_profile`
- **zsh/**: `.zshrc`, `.zshenv`, `.zsh_nix`
- **vim/**: `.vimrc`
- **emacs/**: `.config/doom/` (Doom Emacs)
- **config/**: `.config/` for nvim, alacritty, kitty, ledger, etc.
- **git/**: `.gitconfig`
- **tmux/**: `.tmux.conf`, `.tmux.conf.local`, `tmux-sessionizer`
- **wezterm/**: `.wezterm.lua`, sessionizer scripts
- **direnv/**: `.config/direnv/` with custom templates and utilities
- **kanata/**: Keyboard remapping configuration
- **ohmyposh/**: Shell prompt theme
- **Codex/**: `.Codex/` (Codex configuration - `settings.json`, `plugins/blocklist.json` only; sensitive data excluded)

### Key Config Files Not in Stow

- `darwin-configuration.nix`: System packages, macOS settings, services
- `home.nix`: home-manager user configuration
- `flake.nix`: Development shell, package definitions
- `.envrc`: direnv flake activation

## Development Stack

**Languages**: Python 3.12, Node.js 22, Go 1.25, Rust (via fenix stable toolchain with rust-analyzer, clippy, rustfmt, cargo-nextest)

**CLI Tools**: fd, ripgrep, bat, eza, fzf, gh, jq, yq-go, zoxide, doppler, k9s, git-extras, act, actionlint, gh-dash

**Build Tools**: clang, cmake, gnumake, gcc, pkg-config, libiconv, terraform-ls, tflint, tilt, kind, just

**Package Managers**: uv (Python), bun, pnpm (Node), cargo (Rust)

**Terminals/Apps**: alacritty, wezterm, kitty, ice-bar (menu bar manager), stats (system monitor)

**Services**: postgresql, miniflux, docker-compose, docker-client, colima

**Editors**: vim, neovim (extensive Lua config in config/.config/nvim), Doom Emacs (config/.config/doom)

**Other**: tmux, direnv, stow, ledger, hledger, aspell, hunspell, proton-pass-cli, Codex

## Window Management (Aerospace)

Tiling window manager configured in `darwin-configuration.nix` with vim-style keybindings:

- **Focus**: `alt-{h,j,k,l}` for left/down/up/right
- **Move windows**: `alt-shift-{h,j,k,l}`
- **Workspaces**: `alt-{1-5}` for numbered, `alt-{b,c,t,m}` for intent-based (Browser/Code/Terminal/Music)
- **Resize mode**: `alt-r`
- **Service mode**: `alt-shift-;` (reload config, flatten tree, toggle floating)

Auto-starts Ice menu bar manager on system startup.

## Important Notes

### When Modifying Configurations

1. **System-level changes**: Edit `darwin-configuration.nix`, then run `darwin-rebuild switch --flake .#darwin-system`
2. **User-level changes**: Edit `home.nix`, then run `darwin-rebuild switch --flake .#darwin-system` (home-manager is integrated)
3. **Dotfiles changes**: Edit files in subdirectories, use `nix run .#reinstall` if needed (or just edit directly in `$HOME` since they're symlinked)
4. **Package updates**: Edit `flake.nix`, run `nix flake update`, then rebuild

### Stow Configuration

All stow operations target `$HOME` and manage these directories: `direnv dbt emacs bash config git tmux vim zsh ohmyposh kanata wezterm Codex`

### State Files

- `~/.dotfiles-installed`: Marker for stow completion
- `~/.fonts-installed`: Marker for font installation
- `~/.apps-installed`: Marker for macOS app installation

Delete these to force reinstallation on next `nix develop` entry.

### Rust Toolchain

Uses fenix for Rust instead of rustup in system packages, providing rust-analyzer, clippy, rustfmt, cargo-nextest. LIBRARY_PATH and CPATH configured for libiconv (required for some Rust builds on macOS).

### direnv Integration

The repository uses direnv with `use flake` in `.envrc` for automatic environment activation. Custom direnv utilities in `direnv/.config/direnv/bin/`: `envrc-init`, `envrc-validate`.

### Neovim Configuration

Extensive Lua-based configuration in `config/.config/nvim/` with neotest integration for testing. Configuration uses modern plugin architecture (lazy.nvim or similar based on file structure).

### Codex Configuration

Codex settings are version-controlled via the `Codex/` stow package. Only safe configuration files are tracked:

**Tracked files:**
- `settings.json` - Model preferences, enabled plugins, permission settings
- `plugins/blocklist.json` - Plugin blocklist configuration

**Excluded (sensitive/runtime data):**
- `history.jsonl` - Command history and interactions
- `projects/` - Conversation histories (may contain secrets)
- `session-env/` - Environment variables and credentials
- `paste-cache/`, `debug/`, `file-history/`, `backups/`, `tasks/`, `todos/`, `plans/`, `cache/`, `shell-snapshots/` - Runtime state and work-in-progress data

The `.gitignore` uses a whitelist approach - everything in `.Codex/` is ignored by default, and only the safe config files are explicitly allowed. This prevents accidental commits of sensitive data even as Codex evolves.

**Editing config:**
Since files are symlinked via stow, you can edit directly:
```bash
vim ~/.Codex/settings.json
cd ~/projects/oss/dot-files && git diff Codex/
```

See `Codex/README.md` for detailed documentation.

## Troubleshooting

- **"activation script" errors**: Check LaunchAgent logs in `~/Library/Logs/`
- **Font not showing**: Run `nix run .#install-fonts` and restart affected apps
- **Apps not in Spotlight**: Run `nix run .#install-apps`, wait 30s for indexing
- **direnv not activating**: Run `direnv allow` in repository root
- **Rust build issues**: Verify LIBRARY_PATH includes libiconv: `echo $LIBRARY_PATH`
- **aws-lc-sys / "dsymutil not found"**: Nix’s wrapped clang can’t find `dsymutil`. Either apply the system config so `llvm` (which provides `dsymutil`) is on PATH, or in that project use the system compiler: `CC=/usr/bin/clang CXX=/usr/bin/clang++ cargo run`
