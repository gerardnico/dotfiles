
# set PATH so it includes user's private bin if it exists
# idempotent (why for whatever reason, idea calls profile 2 times when starting its terminal)
# Claude and other executable are installed in it
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
# It should includes only wrapper that overrides .local/bin
# the other should be installed with a symlink into .local/bin
# so that we don't pollute $PATH
# idempotent (why for whatever reason, idea calls profile 2 times when starting its terminal)
if [ -d "$HOME/bin" ] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi
