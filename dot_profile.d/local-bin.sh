
# Claude and other executable are installed in it
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi
