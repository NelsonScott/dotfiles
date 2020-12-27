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
## for python, cassandra, postgres, etc
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"
export PATH="/usr/local/opt/cassandra@2.1/bin:/usr/local/opt/cassandra@2.1/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/opt/postgresql@9.5/bin:/usr/local/opt/postgresql@9.5/bin:/usr/local/opt/cassandra@2.1/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/bin:$PATH"

## for go lang
export GOPATH=$HOME/go-workspace # don't forget to change your path correctly!
export GOROOT=/usr/local/opt/go/libexec
export PATH="$GOPATH/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"


# App Configs
 [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
 export PGDATABASE=peloton

# UNSUPPORTED: Below function has not been used/tested in quite some time
# Usage: input directory surrounding flaky test and then path to flaky test
# find_cause_of_flaky_test tests/scripts/cron scripts/cron/compare_redshift_workout_counts.py
# gotcha: Don't put a / at the end of directory tests/scripts/cron/ is bad
function find_cause_of_flaky_test() {
  for test_file in $(find $1 -iname "*.py"); do echo nosetests -Pvs $test_file $2; done
}
# use this one instead? or fix the above
#function find_cause_of_flaky_test() {
 # for test_file in $(find tests -iname "*.py"); do nosetests -Pvs $test_file $2; done
#}

# Serverless framework Stuff
# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/scottnelson/Documents/serverless_lambdas/meraki/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/scottnelson/Documents/serverless_lambdas/meraki/node_modules/tabtab/.completions/slss.zsh

# handle functions on the terminal
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

# Format Path
function path() {
  echo $PATH | tr -s ':' '\n'
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


##### SRE changes for saml2aws
# we are not multi-region yet
export AWS_DEFAULT_REGION=us-east-1

# account IDs (copied from the AWS Okta tile sign in, if you have more/others)
export PCYCLE=106877218800
export PPROD=386675210126
export PSTAGE=486598304777
export PTEST=152245890419
export TKITCH=048438595429
export PES1=429007243955

# prefer to get push notifications (switch to Passcode if you like)
export FORCE_MFA="Duo Push"

# login to an account if necessary
s2al () { saml2aws login --skip-prompt --profile=${1} --duo-mfa-option "${FORCE_MFA}" --role="arn:aws:iam::${2}:role/test-infra"; }
# inject the active credentials for an account into your env
s2a () { eval $(saml2aws script --shell=bash --skip-prompt --profile=${1}); }
# shortcut to remember who you are (and which account you are in)
awho () { aws sts get-caller-identity; }

# these are the aliases to trigger login (if necessary)
alias apc="s2al pc ${PCYCLE}"
alias atest="s2al test ${PTEST}"
alias astage="s2al stage ${PSTAGE}"
alias aprod="s2al prod ${PPROD}"

# these are the aliases to trigger account switch
alias spc="s2a pc"
alias stest="s2a test"
alias sstage="s2a stage"
alias sprod="s2a prod"

# these are the aliases to trigger account login (if necessary) and switch
alias jpc="s2al pc ${PCYCLE} && s2a pc"
alias jtest="s2al test ${PTEST} && s2a test"
alias jstage="s2al stage ${PSTAGE} && s2a stage"
alias jprod="s2al prod ${PPROD} && s2a prod"

eval $(thefuck --alias)
