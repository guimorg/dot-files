# Ice (macOS menu bar manager)

Ice replaces `sketchybar` in this setup. It is a native macOS menu bar manager with powerful hide/show controls, an optional secondary bar (Ice Bar), and hotkeys.

## Contents

- Goals
- Requirements
- Install
- Migration from sketchybar
- Suggested setup
- Aerospace integration
- Troubleshooting
- Resources

## Goals

- Use Ice for menu bar management instead of `sketchybar`
- Keep a clean, minimal menu bar without scripting
- Store repo decisions in this guide and leave per-machine choices in Ice

## Requirements

- macOS 14+ (Ice uses macOS 14 APIs) [https://github.com/jordanbaird/Ice](https://github.com/jordanbaird/Ice)

## Install

### Homebrew (recommended)

```sh
brew install --cask jordanbaird-ice
```

### Manual

Download the latest release and move `Ice.app` to `/Applications`. [https://github.com/jordanbaird/Ice](https://github.com/jordanbaird/Ice)

## Migration from sketchybar

1. Remove `services.sketchybar` from `darwin-configuration.nix`.
2. Remove Aerospace hooks that call `sketchybar` (see `services.aerospace.settings`).
3. Delete the `sketchybar/` directory.
4. Rebuild your macOS config (for nix-darwin users): `darwin-rebuild switch --flake .`

## Suggested setup

These settings are meant to replace the old scripted bar with a clean, consistent layout:

- Hide clutter: developer tools, VPNs, background apps
- Keep visible: clock, battery, wifi, audio, window manager
- Enable Ice Bar on notched displays for overflow items
- Enable menu bar item search for quick access
- Set auto-rehide for transient items

Example layout:

| Section | Items |
| --- | --- |
| Always visible | Clock, battery, wifi, volume |
| Hidden | Sync tools, meeting apps, VPN, screenshot tools |
| Ice Bar | Rarely used items, overflow icons |

Hotkey ideas:

- Toggle hidden items
- Toggle Ice Bar
- Show search panel

## Aerospace integration

Ice is launched automatically when Aerospace starts:

- `services.aerospace.settings."after-startup-command"` runs `open -a Ice`

## Troubleshooting

If no Ice app appears:

1. Install or reinstall:

```sh
brew install --cask jordanbaird-ice
```

2. Launch manually:

```sh
open -a Ice
```

3. Confirm macOS menu bar is visible:
   System Settings → Control Center → Automatically hide and show the menu bar

   Or via `darwin-configuration.nix`:
   ```nix
   system.defaults.NSGlobalDomain._HIHideMenuBar = false;
   ```

## Resources

- macOS guides: `MACOS_APPS.md`, `NIXDARWIN.md`
- Ice GitHub: [https://github.com/jordanbaird/Ice](https://github.com/jordanbaird/Ice)
- Local configuration: `darwin-configuration.nix`
