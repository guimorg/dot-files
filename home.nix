{ config, pkgs, ... }:

{
  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "vim";
    TERMINAL = "alacritty";
    PAGER = "less";
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    GREP_COLORS = "mt=1;35;40";
    HISTFILE = "~/.zsh_history";
    SAVEHIST = "10000";
    HISTSIZE = "25000";
    HISTTIMEFORMAT = "[%F %T] ";
    FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
    FZF_CTRL_T_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
    FZF_ALT_C_COMMAND = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
  };

  programs.git = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/wezterm/sessionizer.lua" = {
    source = ./wezterm/sessionizer.lua;
  };

  home.file.".local/bin/workspace-picker.sh" = {
    source = ./wezterm/workspace-picker.sh;
    executable = true;
  };

  home.file.".local/bin/workspace-picker-wrapper.sh" = {
    source = ./wezterm/workspace-picker-wrapper.sh;
    executable = true;
  };

  home.file.".local/bin/workspace-manager-display.sh" = {
    source = ./wezterm/workspace-manager-display.sh;
    executable = true;
  };

  home.file.".local/bin/envrc-init" = {
    source = ./direnv/.config/direnv/bin/envrc-init;
    executable = true;
  };

  home.file.".local/bin/envrc-validate" = {
    source = ./direnv/.config/direnv/bin/envrc-validate;
    executable = true;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "/Applications/WezTerm.app/Contents/MacOS"
  ];
}
