
# Install ssh-x
export PATH=$HOME/code/ssh-x/bin:$PATH

# Private Key in pass
export SSH_X_KEY_STORE="pass"


# A caller logs
SSH_X_CALLERS_LOG=/tmp/ssh-x-auth-proxy-parent.log

# Load ssh-agent env if any
SSH_X_AGENT_ENV=$HOME/.ssh/ssh-x-agent.env
if [ -f "$SSH_X_AGENT_ENV" ]; then
  # shellcheck disable=SC1090
  source "$SSH_X_AGENT_ENV" >| /dev/null
fi
