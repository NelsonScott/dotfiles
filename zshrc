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
# Private local keys
## e.g. openai api
source ~/Documents/dotfiles/.env

# Aliases
alias cpwd="pwd | tr -d '\n' | pbcopy"
alias listusers="dscacheutil -q user | grep -A 3 -B 2 -e uid:\ 5'[0-9][0-9]'"
alias reload="source ~/.zshrc"
alias ccat="colorize"
alias please='sudo $(fc -ln -1)'
alias dc='docker-compose'
alias nuke_mk='kubectl delete --all pods --namespace=default && kubectl delete --all deployments --namespace=default && kubectl delete --all services'
alias chatgpt='mods'
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
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Library/Python/3.11/bin:$PATH"

## for go lang
export GOPATH=$HOME/go-workspace # don't forget to change your path correctly!
export GOROOT=/usr/local/opt/go/libexec
export PATH="$GOPATH/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Android
## Make ADB available
export PATH="$HOME/Library/Android/sdk/platform-tools/:$PATH"

# App Configs
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

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
alias recent_branches='git branch --sort=-committerdate'

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

eval $(thefuck --alias)

# Manage nvm with homebrew
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# OpenCV
export PATH="/opt/homebrew/opt/opencv@3/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home)

# Dotnet 
export PATH=$PATH:/usr/local/share/dotnet
# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Bluetooth
function connect() {
    local device_address

    if [[ -z "$1" ]]; then
        echo "Usage: connect <device_name>"
    else
        case "$1" in
            logi)
                device_address="10-94-97-39-12-f3" ;;
            jbl)
                device_address="d8-37-3b-15-08-e3" ;;
            *)
                echo "Device '$1' not recognized." ;;
        esac

        if [[ -n "$device_address" ]]; then
            blueutil --disconnect "$device_address" && \
            blueutil --connect "$device_address"
        fi
    fi
}

search() {
    # Default settings
    local phrase=""
    local everywhere=false
    local filenames_only=false
    local search_scope="current directory"
    local search_type="file contents"

    # Parse options
    local OPTIND
    while getopts ":he:n" opt; do
        case ${opt} in
            h )
                echo "Usage: search [-h] [--everywhere] [-n] <phrase>"
                echo "  -h: Help/show this message"
                echo "  --everywhere: Search entire system"
                echo "  -n: Filenames only"
                return 0
                ;;
            e )
                everywhere=true
                search_scope="entire system"
                ;;
            n )
                filenames_only=true
                search_type="filenames"
                ;;
            \? )
                echo "Invalid option: $OPTARG" 1>&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    # Validate input
    if [[ $# -eq 0 ]]; then
        echo "Error: Search phrase is required. Use -h for help." 1>&2
        return 1
    fi
    phrase="$1"

    # Print search context
    echo "🔍 Searching $search_type in $search_scope for: '$phrase'"

    # Build command
    local cmd=""
    if $filenames_only; then
        if $everywhere; then
            cmd="locate '$phrase'"
        else
            cmd="find . -type f -iname '*$phrase*'"
        fi
    else
        if $everywhere; then
            cmd="find / -type f -print0 | xargs -0 grep -l -n '$phrase'"
        else
            cmd="find . -type f -print0 | xargs -0 grep -l -n '$phrase'"
        fi
    fi

    # Execute and display command
    local results
    results=$(eval "$cmd")

    # If not searching filenames, add highlighting
    if [[ "$filenames_only" == "false" ]]; then
        echo "$results" | while read -r file; do
            echo -e "\n📄 $file:"
            grep -n "$phrase" "$file" | sed "s/$phrase/\x1b[1;31m$phrase\x1b[0m/g"
        done
    else
        echo "$results"
    fi
}