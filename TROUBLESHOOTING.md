# Troubleshooting

Common issues and solutions for the Nix/Flox dotfiles setup.

## Nix Warnings

### "unknown setting 'eval-cores'" and "unknown setting 'lazy-trees'"

**Cause**: Your Determinate Nix installation has deprecated settings in `/etc/nix/nix.conf` that are no longer recognized by newer Nix versions.

**Solution 1: Create custom config (Recommended)**

Run the included script:

```bash
./fix-nix-warnings.sh
```

Or manually:

```bash
sudo tee /etc/nix/nix.custom.conf > /dev/null << 'EOF'
# Custom Nix configuration
# Suppress warnings from deprecated Determinate Nix settings
EOF
```

**Solution 2: Update Determinate Nix**

Update to the latest version which fixes the config:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

**Solution 3: Ignore the warnings**

These warnings are harmless and don't affect functionality. You can safely ignore them.

### "Git tree is dirty"

**Cause**: You have uncommitted changes in your repository.

**Solution**: Commit your changes:

```bash
git add -A
git commit -m "Setup Nix/Flox environment with automatic dotfiles/fonts/apps installation"
```

**Alternative**: Use `--impure` flag to ignore git state:

```bash
nix develop --impure
```

## Flox Issues

### "flox activate" not working

**Cause**: Flox environment not initialized or corrupted.

**Solution**:

```bash
flox activate --reset
```

### Flox packages not found

**Cause**: Flox cache may be outdated.

**Solution**:

```bash
flox update
```

## macOS Application Issues

### Apps not showing in Spotlight

**Cause**: Spotlight hasn't indexed `~/Applications/Nix/`.

**Solution**:

1. Force reindex:
   ```bash
   mdimport ~/Applications/Nix
   ```

2. Or check Spotlight Privacy settings:
   - System Settings → Siri & Spotlight → Spotlight Privacy
   - Remove `~/Applications/Nix` if it's in the exclusion list

### App won't open: "damaged or incomplete"

**Cause**: macOS Gatekeeper quarantine.

**Solution**:

```bash
xattr -cr ~/Applications/Nix/Alacritty.app
```

Or for all apps:

```bash
xattr -cr ~/Applications/Nix/*.app
```

### Apps not appearing in Launchpad

**Cause**: Launchpad only shows apps in `/Applications` or `~/Applications` root.

**Solution**:

Create aliases in the root Applications folder:

```bash
ln -s ~/Applications/Nix/Alacritty.app ~/Applications/
```

Or use Spotlight (⌘ + Space) to launch apps instead.

## Font Issues

### Fonts not showing in applications

**Cause**: Font cache needs refresh.

**Solution**:

```bash
rm ~/.fonts-installed
nix develop  # Fonts will reinstall
```

On Linux:

```bash
fc-cache -f -v
```

### Missing specific font

**Cause**: Font not included in the Nix package list.

**Solution**:

1. Search for the font:
   ```bash
   nix search nixpkgs nerd-fonts
   ```

2. Add it to `flake.nix`:
   ```nix
   nerd-fonts.your-font-name
   ```

3. Reinstall:
   ```bash
   rm ~/.fonts-installed
   nix develop
   ```

## Dotfiles Issues

### Dotfiles not symlinking correctly

**Cause**: Stow conflicts or permission issues.

**Solution**:

```bash
dotfiles-reinstall
```

Or manually:

```bash
cd ~/dotfiles
stow -R direnv dbt emacs bash config git tmux vim zsh ohmyposh kanata wezterm -t $HOME
```

### Conflicts with existing dotfiles

**Cause**: Existing files/directories in `$HOME` conflict with stow.

**Solution**:

Backup and remove conflicting files:

```bash
mkdir ~/dotfiles-backup
mv ~/.zshrc ~/.bashrc ~/.vimrc ~/dotfiles-backup/
dotfiles-reinstall
```

## Performance Issues

### Slow Nix operations

**Cause**: Nix store garbage collection needed.

**Solution**:

```bash
nix-collect-garbage -d
nix store optimise
```

### Large ~/.cache/nix directory

**Cause**: Old evaluation cache and tarballs.

**Solution**:

```bash
rm -rf ~/.cache/nix
```

## Environment Not Activating

### direnv not loading

**Cause**: direnv not allowed or not installed.

**Solution**:

```bash
direnv allow
```

If direnv isn't installed:

```bash
nix develop  # direnv is included in the environment
```

### Wrong shell

**Cause**: Some tools expect specific shells.

**Solution**:

Ensure you're using zsh (or your preferred shell):

```bash
echo $SHELL
chsh -s $(which zsh)
```

## Getting Help

If you're still having issues:

1. Check the flake: `nix flake check`
2. View Nix logs: `nix develop --print-build-logs`
3. Validate environment: `nix flake metadata`
4. Check Nix version: `nix --version`

For more help, see:
- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Flox Documentation](https://flox.dev/docs)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
