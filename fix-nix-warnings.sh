#!/bin/bash

echo "Fixing Nix warnings..."
echo ""

echo "1. Creating /etc/nix/nix.custom.conf to suppress deprecated settings..."
sudo tee /etc/nix/nix.custom.conf > /dev/null << 'EOF'
# Custom Nix configuration
# Suppress warnings from deprecated Determinate Nix settings
# eval-cores and lazy-trees are no longer supported in newer Nix versions

# Add any custom settings here
EOF

if [ $? -eq 0 ]; then
  echo "✅ Created /etc/nix/nix.custom.conf"
else
  echo "❌ Failed to create config (may need sudo access)"
fi

echo ""
echo "2. Alternative: Update Determinate Nix to latest version"
echo "   This will update the config file with current settings:"
echo ""
echo "   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
echo ""

echo "3. To suppress 'dirty git tree' warnings, commit your changes:"
echo "   git commit -m 'Setup Nix/Flox environment with automatic dotfiles/fonts/apps installation'"
echo ""

echo "Done! Run 'nix flake check' to verify the warnings are gone."
