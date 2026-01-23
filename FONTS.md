# Font Management

Fonts are now managed through Nix instead of being committed to the repository.

## What Changed

**Before**: 
- ~900 font files (TTF/OTF) stored in `.local/share/fonts/`
- Large repository size
- Manual font updates

**After**:
- Fonts installed via Nix packages
- Declarative font management in `flake.nix`
- Automatic installation on first activation
- Clean repository without binary files

## Installed Fonts

The following Nerd Fonts are automatically installed:

- **FiraCode** - Programming ligatures, enlarged operators
- **Hack** - Legible at common sizes, dotted zero
- **JetBrains Mono** - Official JetBrains font for developers
- **Roboto Mono** - Dashed zero, clean design
- **Noto** - Google's comprehensive font family
- **Overpass** - Inspired by Highway Gothic
- **Bitstream Vera Sans Mono** - Compact, dotted zero
- **Droid Sans Mono** - Good for small screens

## Installation Location

- **macOS**: `~/Library/Fonts/`
- **Linux**: `~/.local/share/fonts/`

Fonts are symlinked from the Nix store, so updates are automatic when you run `nix flake update`.

## Adding More Fonts

Edit `flake.nix` and add to the `buildInputs` list:

```nix
nerd-fonts.iosevka
nerd-fonts.victor-mono
```

See all available fonts:

```bash
nix search nixpkgs nerd-fonts
```

## Reinstalling Fonts

If fonts are missing or corrupted:

```bash
rm ~/.fonts-installed
nix develop  # or: nix run .#install-fonts
```

## Migration from .local/

The old `.local/share/fonts/` directory is now gitignored. You can safely delete your local copy:

```bash
rm -rf .local/
```

Fonts will be automatically installed from Nix on the next activation.

## See Also

- [MACOS_APPS.md](MACOS_APPS.md) - Managing GUI applications on macOS with Nix
