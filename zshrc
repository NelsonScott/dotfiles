# zsh config
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="af-magic"
ENABLE_CORRECTION="true"
plugins=(git colored-man-pages colorize rand-quote battery thefuck)
# User configuration
source $ZSH/oh-my-zsh.sh
autoload zmv
export RPROMPT="%D{%I:%M:%S}"
cowsay -f $(cowsay -l | tail -n +2 | tr  " "  "\n" | sort -R | head -n 1) $(motivate) |  lolcat

# Aliases
alias cpwd="pwd | tr -d '\n' | pbcopy"
alias listusers="dscacheutil -q user | grep -A 3 -B 2 -e uid:\ 5'[0-9][0-9]'"
alias reload="source ~/.zshrc"
alias ccat="colorize"
alias please='sudo $(fc -ln -1)'
alias dc='docker-compose'
alias nuke_mk='kubectl delete --all pods --namespace=default && kubectl delete --all deployments --namespace=default && kubectl delete --all services'

# Applications
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

# ZSH Auto-Correct
unsetopt correct_all
setopt correct

# Updating PATH
## for python, cassandra, postgres, brew, etc
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"
export PATH="/usr/local/opt/cassandra@2.1/bin:/usr/local/opt/cassandra@2.1/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/opt/postgresql@9.5/bin:/usr/local/opt/postgresql@9.5/bin:/usr/local/opt/cassandra@2.1/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

## for go lang
export GOPATH=$HOME/go-workspace # don't forget to change your path correctly!
export GOROOT=/usr/local/opt/go/libexec
export PATH="$GOPATH/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"


# App Configs
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Handy functions on the terminal
function remind() {
	history | grep $1
}

## sort a file in place
function sort!() {
	sort $1 -o $1
}

function count_files() {
	find $1 -type f | wc -l
}

function new_shell_script() {
	touch $1
	echo "#!/usr/bin/env bash\n" >> $1
	echo "set -euxo pipefail" >> $1
}

# For long running tasks, notify when finished
notify_done() {
  terminal-notifier -title 'Terminal' -message 'Done with task!'
}

# git & github stuff
alias gdfs="git df $(git rev-parse --abbrev-ref HEAD) stash@{0}"
alias gpl='git pull'
alias master='git co master'

function fast_c() {
  git co -b scott.new-branch.$(date +"%Y-%m-%d-%s")
  ga .
  gcmsg $1
  hub pull-request -op --no-edit
}

function search_commits() {
  git log --grep=$1
}

# Format Path human readable
function path() {
  echo $PATH | tr -s ':' '\n'
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


# SRE changes for saml2aws
source ~/.sre-saml2aws 2> /dev/null

eval $(thefuck --alias)
