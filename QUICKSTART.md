# Quick Start Guide

## Setup

Your dotfiles now use **Nix flakes** for reproducible, declarative environment management with automatic installation.

### First Time Setup

```bash
cd ~/projects/oss/dot-files
nix develop  # Dotfiles install automatically on first run
```

Or with Flox:

```bash
flox activate
```

### Automatic Activation (Recommended)

```bash
direnv allow
```

Now the environment activates automatically when you enter the directory!

## Available Commands

Once in the Nix/Flox environment, you have:

- `python` (3.12)
- `node` (22.x)
- `go` (1.25)
- `cargo` (Rust)
- `uv` (Python package manager)
- `bun`, `pnpm` (Node package managers)
- `fd`, `rg`, `bat`, `eza` (modern CLI tools)
- `gh` (GitHub CLI)
- `jq`, `yq` (JSON/YAML processors)

**Fonts**: Nerd Fonts automatically symlinked to `~/Library/Fonts` (macOS) or `~/.local/share/fonts` (Linux)

**macOS Apps** (on first activation):
- Alacritty, WezTerm, Kitty installed to `~/Applications/Nix/`
- Make them searchable: System Settings → Siri & Spotlight → Remove `~/Applications/Nix` from exclusion list

## Useful Aliases (from .zsh_nix)

- `fx` → `flox`
- `fxa` → `flox activate`
- `fxi` → `flox install`
- `fxs` → `flox search`
- `nix-dev` → `nix develop`
- `nix-update` → `nix flake update`

## Managing Dotfiles

Inside the Nix environment, you can manually manage dotfiles:

```bash
dotfiles-reinstall    # Reinstall all dotfiles
dotfiles-uninstall    # Remove all symlinks
apps-install          # Reinstall macOS apps (macOS only)
```

Or use Nix directly:

```bash
nix run .#install         # Install dotfiles
nix run .#reinstall       # Reinstall dotfiles  
nix run .#uninstall       # Uninstall dotfiles
nix run .#install-fonts   # Reinstall fonts (if needed)
nix run .#install-apps    # Reinstall macOS apps (macOS only)
```

**Note**: Fonts and macOS apps are now managed by Nix! The `.local/share/fonts/` directory has been removed from the repository. Everything is automatically installed from nixpkgs.

## Adding New Tools

### Using Nix

Edit `flake.nix` and add packages to the `buildInputs` list:

```nix
buildInputs = with pkgs; [
  python312
  nodejs_22
  # Add your package here
  myNewTool
];
```

Then:

```bash
nix flake update
```

### Using Flox

```bash
flox search <package>
flox install <package>
```

## Updating Dependencies

```bash
nix flake update
```

This updates all packages to their latest versions while maintaining reproducibility via `flake.lock`.

## Benefits

- **No more version conflicts**: Each environment is isolated
- **Fast setup**: Binary caching means quick installs
- **Reproducible**: Same environment on any machine
- **No global pollution**: Tools only available in this directory
- **Version locked**: `flake.lock` ensures consistency across machines

## Troubleshooting

### direnv not working

```bash
direnv allow
```

### Need to reload environment

```bash
direnv reload
```

### Clear Nix cache

```bash
nix-collect-garbage -d
```

## Migration Tips

You can gradually migrate away from:

- **pyenv** → Use Nix's Python versions
- **nvm** → Use Nix's Node.js versions
- **rbenv** → Use Nix's Ruby versions
- **sdkman** → Use Nix's Java/JVM tools

The Nix environment provides everything these tools did, but declaratively and reproducibly.
