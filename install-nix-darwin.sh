#!/usr/bin/env bash

set -e

echo "🍎 Installing nix-darwin..."
echo ""

if [ ! -d "/nix" ]; then
    echo "❌ Nix is not installed. Please install Nix first:"
    echo "   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi

cd "$(dirname "$0")"

echo "📦 Updating flake..."
nix flake update

echo ""
echo "🚀 Installing nix-darwin (this may take a while)..."
echo ""

sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#darwin-system

echo ""
echo "✅ nix-darwin installed successfully!"
echo ""
echo "📝 Next steps:"
echo "  1. Restart your terminal"
echo "  2. Use 'darwin-rebuild switch --flake ~/projects/oss/dot-files#darwin-system' to apply changes"
echo "  3. Or add this alias to make it easier:"
echo "     alias darwin-switch='darwin-rebuild switch --flake ~/projects/oss/dot-files#darwin-system'"
echo ""
echo "📖 See NIX_DARWIN.md for more information"
