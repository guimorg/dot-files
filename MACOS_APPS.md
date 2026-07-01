# macOS Application Management

Applications are now managed through Nix with automatic installation to `~/Applications/Nix/`.

## What's Installed

The following GUI applications are automatically installed on macOS:

- **Alacritty** - GPU-accelerated terminal emulator
- **WezTerm** - GPU-accelerated terminal with advanced features
- **Kitty** - Fast, feature-rich terminal emulator
- **Neovim** - Modern Vim (CLI version, but has GUI support)

## Daily Apps (optional)

These are commonly used on this machine but are not managed by Nix in this repo. Install them manually, or via Homebrew if you choose to use `nix-homebrew`.

- **Ice** - Menu bar manager
- **Cursor** - Code editor
- **Slack** - Team chat
- **Discord** - Community chat
- **Kap** - Screen recording
- **Proton Pass** - Password manager
- **Proton VPN** - VPN client
- **Mic Drop** - Microphone mute/status control

## How It Works

### Automatic Installation

On first activation of the Nix environment, apps are automatically installed to `~/Applications/Nix Apps/` using **macOS aliases**:

```bash
nix develop  # or: flox activate
```

Apps use proper macOS aliases (via [`mkalias`](https://github.com/reckenrode/mkalias)), so they're:
- ✅ Version controlled
- ✅ Reproducible across machines
- ✅ Automatically updated with `nix flake update`
- ✅ No conflicts with Homebrew or Mac App Store
- ✅ Fully searchable in Spotlight and Launchpad

### Manual Installation

If you need to reinstall or update apps:

```bash
apps-install              # Using alias
nix run .#install-apps    # Using Nix directly
```

## Spotlight Integration

Apps installed via macOS aliases should be **automatically searchable in Spotlight** (⌘ + Space)!

If apps don't appear in Spotlight:

1. Force reindex:
   ```bash
   mdimport ~/Applications/Nix\ Apps
   ```

2. Check Spotlight Privacy settings:
   - System Settings → Siri & Spotlight → Spotlight Privacy
   - Ensure `~/Applications/Nix Apps` is NOT in the exclusion list

3. Wait a few minutes for macOS to index the aliases

## Why macOS Aliases Instead of Symlinks?

**macOS Aliases** (what we use via `mkalias`):
- ✅ Work perfectly with Spotlight
- ✅ Appear in Launchpad
- ✅ Survive file moves (aliases track by file ID)
- ✅ Native macOS feature
- ✅ Better integration with macOS ecosystem

**Symlinks** (previous approach):
- ❌ Often invisible to Spotlight
- ❌ Don't work well with Launchpad
- ❌ Break if target moves
- ✅ Work with command-line tools

For Nix-managed GUI apps on macOS, **aliases are the better choice**.

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

## Alternatives & Enhancements

### mac-app-util (Better nix-darwin integration)

If you plan to use [nix-darwin](https://github.com/LnL7/nix-darwin), consider using [`mac-app-util`](https://github.com/hraban/mac-app-util) which provides even better integration:

```nix
# In your nix-darwin configuration
imports = [ inputs.mac-app-util.darwinModules.default ];
```

This handles app linking automatically with better integration into the macOS ecosystem.

### nix-homebrew (Declarative Homebrew management)

Many macOS apps aren't available in nixpkgs but are in Homebrew. Use [`nix-homebrew`](https://github.com/zhaofengli/nix-homebrew) to manage Homebrew declaratively:

```nix
# In your nix-darwin flake
inputs = {
  nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  homebrew-core = {
    url = "github:homebrew/homebrew-core";
    flake = false;
  };
  homebrew-cask = {
    url = "github:homebrew/homebrew-cask";
    flake = false;
  };
};

# In your configuration
modules = [
  nix-homebrew.darwinModules.nix-homebrew
  {
    nix-homebrew = {
      enable = true;
      enableRosetta = true;  # For Apple Silicon
      user = "yourname";
      
      # Declarative tap management
      taps = {
        "homebrew/homebrew-core" = homebrew-core;
        "homebrew/homebrew-cask" = homebrew-cask;
      };
      mutableTaps = false;
    };
    
    # Then declare packages
    homebrew = {
      enable = true;
      casks = [
        "1password"
        "cursor"
        "discord"
        "docker"
        "jordanbaird-ice"
        "kap"
        "mic-drop"
        "proton-pass"
        "protonvpn"
        "slack"
        "spotify"
      ];
    };
  }
];
```

**Benefits:**
- ✅ Larger app catalog (Homebrew has more apps than nixpkgs)
- ✅ Declarative Homebrew management
- ✅ Pinned versions via flake.lock
- ✅ Works alongside Nix packages

**Note:** Requires nix-darwin. This is a great next step after setting up basic Nix dotfiles.

## Integration with nix-darwin

This setup is compatible with nix-darwin. If you later decide to use nix-darwin for full system management, you can:

1. Use this approach (with `mkalias`) in nix-darwin activation scripts
2. Or migrate to `mac-app-util` for automatic handling

See the [nix-darwin activation script example](https://gist.github.com/elliottminns/211ef645ebd484eb9a5228570bb60ec3) for reference.
