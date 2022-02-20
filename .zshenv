typeset -U PATH path

export GREP_COLOR='1;35;40'
# export PATH=${HOME}/.local/bin:${HOME}/.pyenv/plugins/pyenv-virtualenv/shims:${HOME}/.pyenv/shims:${HOME}/.pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:${HOME}/.cargo/bin
export ZSH=${HOME}/.oh-my-zsh
export ZSH_THEME="spaceship"

export STARSHIP_CONFIG=~/.config/starship.toml

# default apps
export EDITOR=vim
export TERMINAL=alacritty
export OPENER=xdg-open
export PAGER=less

path=("$HOME/scripts" "$HOME/.local/bin" "$HOME/.pyenv/plugins/pyenv-virtualenv/shims" "$HOME/.pyenv/shims" "$HOME/.pyenv/bin" "$HOME/.cargo/bin" "$path[@]")
export PATH

# Start blinking
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
# Start bold
export LESS_TERMCAP_md=$(tput bold; tput setaf 2) # green
# Start stand out
export LESS_TERMCAP_so=$(tput bold; tput setaf 3) # yellow
# End standout
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
# Start underline
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 1) # red
# End Underline
export LESS_TERMCAP_ue=$(tput sgr0)
# End bold, blinking, standout, underline
export LESS_TERMCAP_me=$(tput sgr0)
