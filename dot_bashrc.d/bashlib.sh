#####################
# Bash Library
#####################

# The bashlib library should be called by the script
# otherwise it's difficult to test an brew installation
#
# export BASHLIB_DIR=$HOME/code/bash-lib/lib
# idempotent (why for whatever reason, idea calls profile 2 times when starting its terminal)
# if [[ ":$PATH:" != *":$BASHLIB_DIR:"* ]]; then
#  export PATH=$BASHLIB_DIR:$PATH
# fi

# Bash lib
# BASHLIB_LIBRARY_PATH="$CODE_HOME/bash-lib/lib"
# if [ -d "$BASHLIB_LIBRARY_PATH" ]; then
#  export PATH="$BASHLIB_LIBRARY_PATH:$PATH"
# fi

export BASHLIB_ECHO_LEVEL=3 # info level
