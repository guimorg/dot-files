{
  description = "Dotfiles with Nix flakes and nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, flake-utils }:
    let
      username = "thexuh";
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations."darwin-system" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username; };
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        inherit (pkgs) lib stdenv;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python312
            nodejs_22
            go
            rustup
            cargo
            fd
            fzf
            neofetch
            ripgrep
            bat
            eza
            direnv
            git
            stow
            tmux
            vim
            neovim
            zsh
            uv
            jq
            yq-go
            gh
            oh-my-posh
            luarocks
            bun
            nodePackages.pnpm
            nerd-fonts.fira-code
            nerd-fonts.hack
            nerd-fonts.jetbrains-mono
            nerd-fonts.roboto-mono
            nerd-fonts.noto
            nerd-fonts.overpass
            nerd-fonts.bitstream-vera-sans-mono
            nerd-fonts.droid-sans-mono
          ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
            mkalias
            alacritty
            wezterm
            kitty
          ];

          shellHook = ''
            export EDITOR=vim
            export TERMINAL=alacritty
            export PAGER=less
            export GOPATH=$HOME/go
            export GOBIN=$HOME/go/bin
            export GREP_COLORS='mt=1;35;40'
            export HISTFILE=~/.zsh_history
            export SAVEHIST=10000
            export HISTSIZE=25000
            export HISTTIMEFORMAT="[%F %T] "
            export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
            export FZF_CTRL_T_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
            export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

            if [ ! -f "$HOME/.dotfiles-installed" ]; then
              echo "🔗 Installing dotfiles with stow..."
              ${pkgs.stow}/bin/stow -d "$PWD" -t "$HOME" \
                direnv dbt emacs bash config git tmux vim zsh ohmyposh kanata wezterm \
                2>/dev/null || true
              touch "$HOME/.dotfiles-installed"
              echo "✅ Dotfiles installed!"
            fi

            if [ ! -f "$HOME/.fonts-installed" ]; then
              echo "🔤 Installing Nerd Fonts..."
              FONTS="${pkgs.nerd-fonts.fira-code} ${pkgs.nerd-fonts.hack} ${pkgs.nerd-fonts.jetbrains-mono} ${pkgs.nerd-fonts.roboto-mono} ${pkgs.nerd-fonts.noto} ${pkgs.nerd-fonts.overpass} ${pkgs.nerd-fonts.bitstream-vera-sans-mono} ${pkgs.nerd-fonts.droid-sans-mono}"
              if [ "$(uname)" = "Darwin" ]; then
                mkdir -p "$HOME/Library/Fonts"
                for font_pkg in $FONTS; do
                  find "$font_pkg/share/fonts" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec ln -sf {} "$HOME/Library/Fonts/" \; 2>/dev/null || true
                done
              else
                mkdir -p "$HOME/.local/share/fonts"
                for font_pkg in $FONTS; do
                  find "$font_pkg/share/fonts" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec ln -sf {} "$HOME/.local/share/fonts/" \; 2>/dev/null || true
                done
                fc-cache -f 2>/dev/null || true
              fi
              touch "$HOME/.fonts-installed"
              echo "✅ Fonts installed!"
            fi

            if [ "$(uname)" = "Darwin" ] && [ ! -f "$HOME/.apps-installed" ]; then
              echo "📱 Installing macOS applications..."
              rm -rf "$HOME/Applications/Nix Apps"
              mkdir -p "$HOME/Applications/Nix Apps"
              ${lib.optionalString stdenv.hostPlatform.isDarwin ''
              for app in ${pkgs.alacritty}/Applications/*.app ${pkgs.wezterm}/Applications/*.app ${pkgs.kitty}/Applications/*.app ${pkgs.ice-bar}/Applications/*.app; do
                if [ -d "$app" ]; then
                  app_name=$(basename "$app")
                  echo "  Creating alias for $app_name"
                  ${pkgs.mkalias}/bin/mkalias "$app" "$HOME/Applications/Nix Apps/$app_name"
                fi
              done
              ''}
              touch "$HOME/.apps-installed"
              echo "✅ Applications installed in ~/Applications/Nix Apps/"
              echo "   Apps should now be searchable in Spotlight!"
            fi

            echo "🎉 Nix development environment activated!"
            echo "📦 Tools: python, node, go, rust, and more..."
          '';
        };

        packages = {
          install = pkgs.writeShellScriptBin "install-dotfiles" ''
            echo "🔗 Installing dotfiles..."
            ${pkgs.stow}/bin/stow -d "$PWD" -t "$HOME" \
              direnv dbt emacs bash config git tmux vim zsh ohmyposh kanata wezterm
            touch "$HOME/.dotfiles-installed"
            echo "✅ Dotfiles installed!"
          '';

          reinstall = pkgs.writeShellScriptBin "reinstall-dotfiles" ''
            echo "🔄 Reinstalling dotfiles..."
            rm -f "$HOME/.dotfiles-installed"
            ${pkgs.stow}/bin/stow -R -d "$PWD" -t "$HOME" \
              direnv dbt emacs bash config git tmux vim zsh ohmyposh kanata wezterm
            touch "$HOME/.dotfiles-installed"
            echo "✅ Dotfiles reinstalled!"
          '';

          uninstall = pkgs.writeShellScriptBin "uninstall-dotfiles" ''
            echo "🗑️  Uninstalling dotfiles..."
            ${pkgs.stow}/bin/stow -D -d "$PWD" -t "$HOME" \
              direnv dbt emacs bash config git tmux vim zsh ohmyposh kanata wezterm
            rm -f "$HOME/.dotfiles-installed"
            echo "✅ Dotfiles uninstalled!"
          '';

          install-fonts = pkgs.writeShellScriptBin "install-fonts" ''
            echo "🔤 Installing Nerd Fonts..."
            FONTS="${pkgs.nerd-fonts.fira-code} ${pkgs.nerd-fonts.hack} ${pkgs.nerd-fonts.jetbrains-mono} ${pkgs.nerd-fonts.roboto-mono} ${pkgs.nerd-fonts.noto} ${pkgs.nerd-fonts.overpass} ${pkgs.nerd-fonts.bitstream-vera-sans-mono} ${pkgs.nerd-fonts.droid-sans-mono}"
            if [ "$(uname)" = "Darwin" ]; then
              mkdir -p "$HOME/Library/Fonts"
              for font_pkg in $FONTS; do
                find "$font_pkg/share/fonts" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec ln -sf {} "$HOME/Library/Fonts/" \; 2>/dev/null || true
              done
            else
              mkdir -p "$HOME/.local/share/fonts"
              for font_pkg in $FONTS; do
                find "$font_pkg/share/fonts" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec ln -sf {} "$HOME/.local/share/fonts/" \; 2>/dev/null || true
              done
              fc-cache -f 2>/dev/null || true
            fi
            touch "$HOME/.fonts-installed"
            echo "✅ Fonts installed!"
          '';

          install-apps = pkgs.writeShellScriptBin "install-apps" ''
            if [ "$(uname)" != "Darwin" ]; then
              echo "⚠️  This command is only for macOS"
              exit 1
            fi
            echo "📱 Installing macOS applications..."
            rm -rf "$HOME/Applications/Nix Apps"
            mkdir -p "$HOME/Applications/Nix Apps"
            ${lib.optionalString stdenv.hostPlatform.isDarwin ''
            for app in ${pkgs.alacritty}/Applications/*.app ${pkgs.wezterm}/Applications/*.app ${pkgs.kitty}/Applications/*.app ${pkgs.ice-bar}/Applications/*.app; do
              if [ -d "$app" ]; then
                app_name=$(basename "$app")
                echo "  Creating alias for $app_name"
                ${pkgs.mkalias}/bin/mkalias "$app" "$HOME/Applications/Nix Apps/$app_name"
              fi
            done
            ''}
            touch "$HOME/.apps-installed"
            echo "✅ Applications installed in ~/Applications/Nix Apps/"
            echo "   Apps should now be searchable in Spotlight!"
          '';
        };
      }
    );
}
