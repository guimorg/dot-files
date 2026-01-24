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

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
