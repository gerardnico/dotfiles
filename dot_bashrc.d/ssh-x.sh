##############################
# SSH Env
##############################


# Start the agent
if ! eval "$(ssh-x-agent-init)"; then
  echo "SSH Agent Started Not successfully" >/dev/tty
fi

# An alias
alias ssx="ssh-x"

