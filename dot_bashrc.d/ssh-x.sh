##############################
# SSH Env
##############################

# Start the agent only in interactive mode
# Otherwise we get a recursion because `ssh-x-agent-init`
# is also a script (ie non-interactive bash)
# and will called this env
if ! eval "$(source ssh-x-agent-init)"; then
  echo "SSH Agent Started Not successfully" >/dev/tty
fi

# An alias
alias ssx="ssh-x"
