# some of this is ancient and maybe out of date; using zsh primarily
export PATH="$cassandra_dir:$PATH"
export PATH="$postgres_dir:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"
export DISABLE_SQS_AUDITING=1
export PATH="$cassandra_dir:$PATH"
export PATH="$postgres_dir:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
