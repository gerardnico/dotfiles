
# Install ssh-x
export PATH=$HOME/code/ssh-x/bin:$PATH

# Private Key in pass
export SSH_X_KEY_STORE="pass"

# Load ssh-agent env if any
# shellcheck disable=SC1090
test -f "$SSH_X_AGENT_ENV" && source "$SSH_X_AGENT_ENV" >| /dev/null
