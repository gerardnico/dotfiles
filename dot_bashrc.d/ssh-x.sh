##############################
# SSH Env
##############################

# Start the agent only in interactive mode
# Otherwise we get a recursion because `ssh-x-agent-start`
# is also a script (ie non-interactive bash)
# and will called this env
if ! eval "$(source ssh-x-agent-start)"; then
  echo "SSH Agent Started Not successfully" >/dev/tty
fi

# An alias
alias ssx="ssh-x"
