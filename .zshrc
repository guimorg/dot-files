# autocompletion for git
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

# some aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ls='ls -GwF'
alias ll='ls -alh'

# python3
alias python=python3

# to quickly edit zshrc
alias zshrc='vim ~/.zshrc'

# to quickly edit vimrc
alias vimrc='vim ~/.vimrc'

# quickly update zhsrc
alias update="source ~/.zshrc"

# default editor
EDITOR=vim

# gitconfig if needed
alias gitconfig='vim ~/.gitconfig'
# Added by furycli:
export PATH="$HOME/Library/Python/3.7/bin:$PATH"
source "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load completion config
source $HOME/.zsh/completion.zsh

# Initialize the completion system
autoload -Uz compinit

# Cache completion if nothing changed - faster startup time
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Enhanced form of menu completion called `menu selection'
zmodload -i zsh/complist

eval "$(starship init zsh)"
source /Users/guamorim/.zsh/history.zsh
