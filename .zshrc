# autocompletion for git
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

# vi-mode ftw
set -o vi

# some functions
mcd () {
    # Creates dir and cd into dir
    mkdir -p $1
    cd $1
}

get_ip_cidr() {
    URL=`curl --silent http://checkip.amazonaws.com/`
    echo "${URL}/32"
}

vpn_start() {
	pushd ~/.secrets &> /dev/null
	openvpn3 session-start --config client.ovpn
	popd &> /dev/null
}

vpn_stop() {
	pushd ~/.secrets &> /dev/null
	openvpn3 session-manage --config client.ovpn --disconnect
	popd &> /dev/null
}

vpn_pause() {
	pushd ~/.secrets &> /dev/null
	openvpn3 session-manage --config client.ovpn --pause
	popd &> /dev/null
}

vpn_resume() {
	pushd ~/.secrets &> /dev/null
	openvpn3 session-manage --config client.ovpn --resume
	popd &> /dev/null
}

vpn_status() {
	pushd ~/.secrets &> /dev/null
	openvpn3 session-stats --config client.ovpn
	popd &> /dev/null
}

to_gif(){
    echo "📽️  Going to transform ${1} to ${2} 📽️"
    ffmpeg -i ${1}.mp4 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > ${2}.gif
    echo "🍿 Finished! 🍿"
}

pintoken(){
    # Gets TOTP ticket
    totp --list meli >> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "TOTP for MeLi is not available!"
        return 2
    fi
    
    melitotp="$(totp --totp meli)"
    echo "${VPN_PIN}${melitotp}"
}

meli_aws_login() {
    # Getting token and pin
    which aws-bastion-cli >> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "Could not find aws-bastion-cli 😓"
        return 2
    fi
    
    echo "Getting your pintoken 😏 🍆"
    token=`pintoken`
    echo "Logging in using aws-bastion-cli ☁️"
    aws_json_fields="$(aws-bastion-cli -t ${token} --print 2>/dev/null)"
    if [[ $? -ne 0 ]]; then
        echo "Try again!"
        return 1
    fi
    expire=$(jq -r '.Expiration' <<< "${aws_json_fields}")
    echo "Credentials will expire at ${expire} ⏲️"
    export AWS_ACCESS_KEY_ID=$(jq -r '.AccessKeyId' <<< "${aws_json_fields}")
    export AWS_SECRET_ACCESS_KEY=$(jq -r '.SecretAccessKey' <<< "${aws_json_fields}")
    export AWS_SECURITY_TOKEN=$(jq -r '.SessionToken' <<< "${aws_json_fields}")
    export AWS_SESSION_TOKEN=$(jq -r '.SessionToken' <<< "${aws_json_fields}")
    echo "All done! Goodbye! 😍"
}

# some aliases
alias ll='ls -l --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias en_to_pt='trans en:pt "$@"'
alias es_to_pt='trans es:pt "$@"'
alias es_to_en='trans es:en "$@"'
alias pt_to_en='trans pt:en "$@"'
alias pt_to_es='trans pt:es "$@"'

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

plugins=(
	zsh-autosuggestions
	fast-syntax-highlighting
	docker
	tmux
	zsh-pyenv
)

# Load completion config
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

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

eval "$(pyenv virtualenv-init -)"

alias grep='grep --color=always'
export GREP_COLOR='1;35;40'

export STARSHIP_CONFIG=~/.starship
eval "$(starship init zsh)"

export ZSH=/home/guimorg/.oh-my-zsh
export ZSH_THEME="spaceship"
source $ZSH/oh-my-zsh.sh

autoload -U +X bashcompinit && bashcompinit
function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@ ;}
bindkey -v
export PATH=/home/guimorg/.local/bin:/home/guimorg/.pyenv/plugins/pyenv-virtualenv/shims:/home/guimorg/.pyenv/shims:/home/guimorg/.pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
