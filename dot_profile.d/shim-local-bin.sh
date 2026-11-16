
# The user local bin
# Claude and other executable are installed in it
# idempotent (why for whatever reason, idea calls profile 2 times when starting its terminal)
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Our shims
# idempotent (why for whatever reason, idea calls profile 2 times when starting its terminal)
if [ -d "$HOME/shims" ] && [[ ":$PATH:" != *":$HOME/shims:"* ]]; then
    export PATH="$HOME/shims:$PATH"
fi
