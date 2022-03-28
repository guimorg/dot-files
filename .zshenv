export GREP_COLOR='1;35;40'
export PATH=${HOME}/.local/bin:${HOME}/.pyenv/plugins/pyenv-virtualenv/shims:${HOME}/.pyenv/shims:${HOME}/.pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:${HOME}/.cargo/bin
export ZSH=${HOME}/.oh-my-zsh
export ZSH_THEME="spaceship"

export STARSHIP_CONFIG=~/.config/starship.toml

# default editor
export EDITOR=vim
export TERMINAL=alacritty
export OPENER=xdg-open
export PAGER=less

export SCRIPT_DIR=~/scripts
export MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)
