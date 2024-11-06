##############################
# SSH Env
##############################


# Start the agent
if ! eval "$(ssh-x-agent-init)"; then
  echo "SSH Agent Started Not successfully" >/dev/tty
fi

# Private Key in pass
export SSH_X_KEY_STORE="pass"

# An alias
alias ssx="ssh-x"

