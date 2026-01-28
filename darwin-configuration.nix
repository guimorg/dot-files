{ config, pkgs, username, ... }:

{
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  environment.systemPackages = with pkgs; [
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
    git-extras
    k9s
    stow
    tmux
    doppler
    gnupg
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
    mkalias
    alacritty
    wezterm
    kitty
    clang
    cmake
    gnumake
    gcc
    pkg-config
    libiconv
    proton-pass-cli
    postgresql
    claude-code
    gh
    act
    docker-compose
    docker-client
    docker-credential-helpers
    colima
    zoxide
    miniflux
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.roboto-mono
    nerd-fonts.noto
    nerd-fonts.overpass
    nerd-fonts.bitstream-vera-sans-mono
    nerd-fonts.droid-sans-mono
  ];

  nixpkgs.config.allowUnfree = true;

  nix.enable = false;

  programs.zsh.enable = true;

  system.primaryUser = username;

  system.defaults = {
    dock.autohide = true;
    dock.orientation = "bottom";
    dock.show-recents = false;
    dock.tilesize = 48;

    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "Nlsv";
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;

    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # networking.hosts is not supported in nix-darwin yet.
  # You will need to manually add "127.0.0.1 miniflux.local" to your /etc/hosts
  # or use a different local domain strategy.

  launchd.user.agents.miniflux = {
    serviceConfig = {
      Label = "com.thexuh.miniflux";
      ProgramArguments = [
        "${pkgs.docker-compose}/bin/docker-compose"
        "-f"
        "/Users/${username}/projects/oss/dot-files/services/miniflux/docker-compose.yml"
        "up"
        "-d"
      ];
      RunAtLoad = true;
      KeepAlive = false; # docker-compose up -d is a one-shot command that starts background containers
      StandardOutPath = "/Users/${username}/Library/Logs/miniflux.out.log";
      StandardErrorPath = "/Users/${username}/Library/Logs/miniflux.err.log";
      WorkingDirectory = "/Users/${username}/projects/oss/dot-files/services/miniflux";
    };
  };

  services.aerospace = {
    enable = true;

    settings = {
      config-version = 2;

      # ── Layout normalization (keeps trees sane)
      "enable-normalization-flatten-containers" = true;
      "enable-normalization-opposite-orientation-for-nested-containers" = true;

      # ── Gaps
      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 12;
          right = 12;
          top = 12;
          bottom = 12;
        };
      };

      # ── Keyboard layout
      key-mapping = {
        preset = "qwerty";
      };

      # ── Modes
      mode = {
        # =========================
        # Main mode (daily driving)
        # =========================
        main = {
          binding = {
            # Focus (vim-style)
            "alt-h" = "focus left";
            "alt-j" = "focus down";
            "alt-k" = "focus up";
            "alt-l" = "focus right";

            # Move windows
            "alt-shift-h" = "move left";
            "alt-shift-j" = "move down";
            "alt-shift-k" = "move up";
            "alt-shift-l" = "move right";

            # Layouts
            "alt-slash" = "layout tiles horizontal vertical";
            "alt-comma" = "layout accordion horizontal vertical";

            # Resize (quick)
            "alt-minus" = "resize smart -50";
            "alt-equal" = "resize smart +50";

            # Modes
            "alt-r" = "mode resize";
            "alt-shift-semicolon" = "mode service";

            # Workspaces (core)
            "alt-1" = "workspace 1";
            "alt-2" = "workspace 2";
            "alt-3" = "workspace 3";
            "alt-4" = "workspace 4";
            "alt-5" = "workspace 5";

            # Send window to workspace (stay)
            "alt-shift-1" = "move-node-to-workspace 1";
            "alt-shift-2" = "move-node-to-workspace 2";
            "alt-shift-3" = "move-node-to-workspace 3";
            "alt-shift-4" = "move-node-to-workspace 4";
            "alt-shift-5" = "move-node-to-workspace 5";

            # Send window + follow
            "alt-ctrl-1" = [ "move-node-to-workspace 1" "workspace 1" ];
            "alt-ctrl-2" = [ "move-node-to-workspace 2" "workspace 2" ];
            "alt-ctrl-3" = [ "move-node-to-workspace 3" "workspace 3" ];
            "alt-ctrl-4" = [ "move-node-to-workspace 4" "workspace 4" ];
            "alt-ctrl-5" = [ "move-node-to-workspace 5" "workspace 5" ];

            # Intent-based workspaces
            # B = Browser, C = Code, T = Terminal, M = Music / Chat
            "alt-b" = "workspace B";
            "alt-c" = "workspace C";
            "alt-t" = "workspace T";
            "alt-m" = "workspace M";

            # Send window to intent workspace
            "alt-shift-b" = "move-node-to-workspace B";
            "alt-shift-c" = "move-node-to-workspace C";
            "alt-shift-t" = "move-node-to-workspace T";
            "alt-shift-m" = "move-node-to-workspace M";

            # Back & forth / monitors
            "alt-tab" = "workspace-back-and-forth";
            "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
          };
        };

        # =========================
        # Resize mode
        # =========================
        resize = {
          binding = {
            "esc" = "mode main";
            "enter" = "mode main";

            "h" = "resize smart -50";
            "j" = "resize smart -50";
            "k" = "resize smart +50";
            "l" = "resize smart +50";

            "minus" = "resize smart -50";
            "equal" = "resize smart +50";
          };
        };

        # =========================
        # Service / maintenance
        # =========================
        service = {
          binding = {
            "esc" = [ "reload-config" "mode main" ];

            "r" = [ "flatten-workspace-tree" "mode main" ];
            "f" = [ "layout floating tiling" "mode main" ];
            "backspace" = [ "close-all-windows-but-current" "mode main" ];

            "h" = [ "join-with left" "mode main" ];
            "j" = [ "join-with down" "mode main" ];
            "k" = [ "join-with up" "mode main" ];
            "l" = [ "join-with right" "mode main" ];
          };
        };
      };
    };
  };

  services.aerospace.settings = {
    "exec-on-workspace-change" = [
      "/bin/bash"
      "-c"
      "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
    ];

    "after-startup-command" = [ "exec-and-forget sketchybar" ];
  };

  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.jq pkgs.bash ];
    config = builtins.readFile ./sketchybar/.config/sketchybar/sketchybarrc;
  };

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
