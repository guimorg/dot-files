# dotfiles

Modern dotfiles with Nix flakes for reproducible development environments.

## Setup

Clone and activate:

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
nix develop  # or: flox activate
```

That's it! Dotfiles are automatically symlinked and all tools are available.

### With direnv (recommended)

```bash
direnv allow
```

Environment activates automatically when you `cd` into the directory.

## What's Included

**Languages**: Python 3.12, Node.js 22, Go, Rust  
**CLI Tools**: fd, ripgrep, bat, eza, fzf, gh, jq, yq  
**Dev Tools**: git, tmux, vim, neovim, zsh, direnv, stow  
**Package Managers**: uv, bun, pnpm, cargo  
**Fonts**: Nerd Fonts (FiraCode, Hack, JetBrains Mono, Roboto Mono, Noto, Overpass)  
**macOS Apps**: Alacritty, WezTerm, Kitty (automatically installed to ~/Applications/Nix Apps with macOS aliases)

## Configuration

- `flake.nix` - Nix environment definition
- `.flox/` - Flox environment (alternative to Nix)
- `bash/`, `zsh/`, `vim/`, `tmux/`, etc. - Application configs

## Updating

```bash
nix flake update
```

## Why Nix?

✅ Reproducible - same environment everywhere  
✅ Declarative - configuration as code  
✅ Fast - binary caching  
✅ Isolated - no global state pollution

## Next Steps

Ready for more? See [NIXDARWIN.md](NIXDARWIN.md) for:
- **nix-darwin** - Full macOS system management
- **nix-homebrew** - Declarative Homebrew integration
- **System settings** - Configure macOS preferences as code

Menu bar management (Ice): [MACOS_ICE.md](MACOS_ICE.md)

Current setup works great standalone! Only migrate if you want system-wide configuration.
