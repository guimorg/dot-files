# Claude Code Configuration

This directory contains version-controlled Claude Code configuration files managed via GNU Stow.

## What's Tracked

Only **safe, non-sensitive configuration files** are version-controlled:

- **`settings.json`** - Model preferences, enabled plugins, permission settings
- **`plugins/blocklist.json`** - Plugin blocklist configuration

These files contain user preferences and are safe to share across machines.

## What's NOT Tracked (Security-Critical)

The following files in `~/.claude` are **explicitly excluded** from version control for security reasons:

- **`history.jsonl`** - All your command history and interactions
- **`projects/`** - Complete conversation histories (may contain work secrets, API keys, sensitive data)
- **`session-env/`** - May contain API keys and environment credentials
- **`paste-cache/`** - User-pasted content (potentially sensitive)
- **`debug/`** - Debug logs
- **`file-history/`** - File access history
- **`backups/`**, **`tasks/`**, **`todos/`**, **`plans/`** - Work-in-progress data
- **`cache/`**, **`shell-snapshots/`** - Runtime cache files
- **`stats-cache.json`**, **`mcp-needs-auth-cache.json`** - Runtime state

## How It Works

### Automatic Management via Stow

This configuration is automatically deployed by GNU Stow when you enter the development environment:

```bash
# Enter dev shell (auto-deploys on first run)
nix develop

# Or if using direnv
direnv allow
```

### Manual Management

```bash
# Reinstall dotfiles (including claude config)
nix run .#reinstall

# Uninstall dotfiles
nix run .#uninstall
```

### Direct Editing

Since Stow creates symlinks, you can edit the config directly and changes are immediately reflected in the repository:

```bash
# Edit settings in place
vim ~/.claude/settings.json

# Check what changed
cd ~/projects/oss/dot-files
git diff claude/

# Commit changes
git add claude/.claude/settings.json
git commit -m ":wrench: Update Claude Code settings"
```

## Security Guarantees

The repository's `.gitignore` uses a **whitelist approach** - it ignores **everything** in `.claude/` by default and only allows the specific safe files listed above. This means:

- New sensitive files created by Claude Code updates will **never** be tracked
- Accidentally running `git add .` will **not** commit sensitive data
- You don't need to remember which files are safe

## Syncing Across Machines

Once this dotfiles repository is set up on another machine:

1. The stow package will automatically deploy the configuration
2. Claude Code will inherit your settings and plugin configuration
3. Your conversation history and sensitive data remain local to each machine

## Manual Sync Instructions

If you've manually edited `~/.claude/settings.json` or `~/.claude/plugins/blocklist.json` and want to update the repository:

```bash
cd ~/projects/oss/dot-files
cp ~/.claude/settings.json claude/.claude/settings.json
cp ~/.claude/plugins/blocklist.json claude/.claude/plugins/blocklist.json
git add claude/
git commit -m ":wrench: Update Claude Code configuration"
git push
```

## Troubleshooting

### Settings not applying

1. Check if symlinks are correct:
   ```bash
   ls -la ~/.claude/settings.json
   # Should show: ~/.claude/settings.json -> /Users/thexuh/projects/oss/dot-files/claude/.claude/settings.json
   ```

2. If not symlinked, reinstall:
   ```bash
   nix run .#reinstall
   ```

### Conflicts after editing on another machine

If you've edited settings on multiple machines:

```bash
# On each machine, save local changes first
cp ~/.claude/settings.json ~/claude-settings-backup.json

# Pull latest from git
git pull

# Merge any differences manually
vimdiff ~/claude-settings-backup.json ~/.claude/settings.json
```

## File Permissions

- `settings.json` - Should be readable (644)
- `plugins/blocklist.json` - Should be readable (644)

If Claude Code creates these files with restrictive permissions (600), they'll still work via symlinks.

## Related Documentation

- Main dotfiles documentation: [`CLAUDE.md`](../CLAUDE.md)
- Nix flake configuration: [`flake.nix`](../flake.nix)
- Security rules: [`.gitignore`](../.gitignore)
