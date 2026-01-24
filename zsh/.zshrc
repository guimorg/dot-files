if [[ -o interactive ]] && [[ -z "$ZSHRC_SOURCED" ]]; then
    neofetch --config ~/.config/neofetch/config.conf
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

autoload -Uz compinit

if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

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

# Load plugins with zinit (using turbo mode for faster startup)
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zsh-users/zsh-syntax-highlighting \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit wait"1" lucid for \
  zsh-users/zsh-docker \
  asdf-vm/asdf \
  MichaelAquilina/zsh-you-should-use \
  OMZP::git/git.plugin.zsh \
  OMZP::aws \
  OMZP::command-not-found \
  OMZP::sudo

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

bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char

zinit cdreplay -q

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

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

pyenv() {
  unset -f pyenv
  eval "$(command pyenv init -)"
  pyenv "$@"
}

python() {
  unset -f pyenv python
  eval "$(command pyenv init -)"
  python "$@"
}
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

# bun completions
[ -s "/Users/thexuh/.bun/_bun" ] && source "/Users/thexuh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}

npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npx "$@"
}
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="/opt/homebrew/opt/apache-flink@1/bin:$PATH"
export PATH="/nix/var/nix/profiles/default/bin:$PATH"
pass-cli ssh-agent load >/dev/null 2>&1

[ -f ~/.zsh_nix ] && source ~/.zsh_nix

export ZSHRC_SOURCED=1
