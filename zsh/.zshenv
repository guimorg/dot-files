export GREP_COLORS='mt=1;35;40'
export GOPATH=${HOME}/go
export GOBIN=${GOPATH}/bin

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export PATH=/run/current-system/sw/bin:${HOME}/.local/bin:${HOME}/.pyenv/plugins/pyenv-virtualenv/shims:${HOME}/.pyenv/shims:${HOME}/.pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:${HOME}/.cargo/bin:${HOME}/git/networkmanager-dmenu:${GOPATH}/bin
export PATH=$HOME/.config/rofi/scripts:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=${HOME}/.npm-global/bin:$PATH
export PATH=$HOME/.emacs.d/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=$PWD/node_modules/.bin:$PATH
export PATH=$HOME/tinygo/bin:$PATH
export PATH=/nix/var/nix/profiles/default/bin:$PATH
export ZSH=${HOME}/.oh-my-zsh
export ZSH_THEME="spaceship"
export ZSH_PYENV_VIRTUALENV=true

export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTSIZE=25000
export HISTTIMEFORMAT="[%F %T] "

# default editor
export EDITOR=vim
export TERMINAL=alacritty
export OPENER=xdg-open
export PAGER=less

export SCRIPT_DIR=~/scripts
if [ "$(uname)" = "Darwin" ]; then
  # set MONITORS to an empty string on Mac
  export MONITORS=""
else
  # set MONITORS based on xrandr output on Ubuntu
  export MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)
fi
. "$HOME/.cargo/env"
skip_global_compinit=1
