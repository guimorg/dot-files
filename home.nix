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
}
