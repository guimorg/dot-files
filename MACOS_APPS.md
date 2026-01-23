# macOS Application Management

Applications are now managed through Nix with automatic installation to `~/Applications/Nix/`.

## What's Installed

The following GUI applications are automatically installed on macOS:

- **Alacritty** - GPU-accelerated terminal emulator
- **WezTerm** - GPU-accelerated terminal with advanced features
- **Kitty** - Fast, feature-rich terminal emulator
- **Neovim** - Modern Vim (CLI version, but has GUI support)

## How It Works

### Automatic Installation

On first activation of the Nix environment, apps are automatically symlinked to `~/Applications/Nix/`:

```bash
nix develop  # or: flox activate
```

Apps are symlinked from the Nix store, so they're:
- ✅ Version controlled
- ✅ Reproducible across machines
- ✅ Automatically updated with `nix flake update`
- ✅ No conflicts with Homebrew or Mac App Store

### Manual Installation

If you need to reinstall or update apps:

```bash
apps-install              # Using alias
nix run .#install-apps    # Using Nix directly
```

## Making Apps Searchable in Spotlight

By default, Spotlight may not index `~/Applications/Nix/`. To fix this:

1. Open **System Settings**
2. Go to **Siri & Spotlight**
3. Click **Spotlight Privacy**
4. If `~/Applications/Nix` is in the exclusion list, remove it
5. Click the **+** button and add `~/Applications/Nix` to force reindexing

Alternatively, force Spotlight to reindex:

```bash
mdimport ~/Applications/Nix
```

## Why Symlinks Instead of Aliases?

**Symlinks** (what we use):
- Work with command-line tools
- Survive system updates
- Can be version controlled
- Fast and efficient

**macOS Aliases**:
- Only work well in Finder
- Can break with system updates
- Binary format (can't be tracked in git)

For Nix-managed apps, symlinks are the better choice.

## Adding More Applications

Edit `flake.nix` and add packages to the Darwin-specific section:

```nix
] ++ lib.optionals stdenv.hostPlatform.isDarwin [
  alacritty
  wezterm
  kitty
  # Add more apps here
  vscode
  firefox
];
```

Search for available macOS apps:

```bash
nix search nixpkgs firefox
nix search nixpkgs vscode
nix search nixpkgs cursor
```

## Troubleshooting

### Apps not showing in Launchpad

Launchpad only shows apps in `/Applications` or `~/Applications` root. Our apps are in `~/Applications/Nix/`. 

**Solutions**:
1. Use Spotlight to launch apps (⌘ + Space)
2. Add `~/Applications/Nix` to your Dock as a folder
3. Create aliases in `~/Applications` if needed:

```bash
ln -s ~/Applications/Nix/Alacritty.app ~/Applications/
```

### App signature issues

If macOS complains about unsigned apps:

```bash
xattr -cr ~/Applications/Nix/Alacritty.app
```

### Reinstalling all apps

```bash
rm ~/.apps-installed
nix develop  # Will reinstall on next activation
```

## Benefits Over Homebrew Casks

**Nix**:
- ✅ Declarative configuration
- ✅ Reproducible builds
- ✅ Multiple versions possible
- ✅ Atomic updates
- ✅ Easy rollback

**Homebrew Casks**:
- ❌ Imperative (manual install)
- ❌ Global state
- ❌ Can't easily roll back
- ❌ Version conflicts

## Integration with nix-darwin

This setup is compatible with nix-darwin. If you later decide to use nix-darwin for full system management, you can move these app definitions to your nix-darwin configuration.
