# Install ssh-x
SSH_BIN="$HOME/code/ssh-x/bin"
# idempotent (why for whatever reason, idea calls profile 2 times when starting its terminal)
if [[ ":$PATH:" != *":$SSH_BIN:"* ]]; then
  export PATH="$SSH_BIN:$PATH"
fi
unset SSH_BIN

# Private Key in pass
export SSH_X_KEY_STORE="pass"

export SSH_BASHLIB_LIBRARY_PATH="$HOME/code/bash-lib/lib"

# A caller logs
export SSH_X_CALLERS_LOG=/tmp/ssh-x-auth-proxy-parent.log

# Load ssh-agent env if any
SSH_X_AGENT_ENV=$HOME/.ssh/ssh-x-agent.env
if [ -f "$SSH_X_AGENT_ENV" ]; then
  # shellcheck disable=SC1090
  source "$SSH_X_AGENT_ENV" >|/dev/null
fi
