neofetch --config ~/.config/neofetch/config.conf --image_size none --backend kitty --source ~/.config/neofetch/pictures/kitty.png

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

autoload -Uz compinit
compinit

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Load plugins with zinit
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-docker
zinit light asdf-vm/asdf
zinit light MichaelAquilina/zsh-you-should-use
zinit snippet OMZP::git/git.plugin.zsh
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found
zinit snippet OMZP::sudo
# zinit snippet OMZP::pyenv/pyenv.plugin.zsh
zinit light Aloxaf/fzf-tab

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "{(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# vi-mode ftw
set -o vi

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

precmd() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

for f in ~/.config/shellconfig/*; do source "$f"; done

autoload -U +X bashcompinit && bashcompinit
autoload -U colors && colors

. $HOME/.cargo/env

fpath+=${ZDOTDIR:-~}/.zsh_functions
fpath+=~/.zfunc

bindkey -v

zinit cdreplay -q

source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
	fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
	fd --type=d --hidden --exclude .git . "$1"
}

[ -f ~/fzf-git.sh/fzf-git.sh ] && source ~/fzf-git.sh/fzf-git.sh


if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
	eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
fi

export PATH=/home/guimorg/.local/bin:${PATH}
eval "$(luarocks path --bin)"
# eval "$(pyenv virtualenv-init -)"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export MODULAR_HOME="/Users/thexuh/.modular"
export PATH="/Users/thexuh/.modular/pkg/packages.modular.com_max/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thexuh/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/thexuh/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/thexuh/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/thexuh/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/Users/thexuh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
eval "$(uv generate-shell-completion zsh)"
eval "$(direnv hook zsh)"
