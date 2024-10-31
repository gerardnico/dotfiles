##############################
# SSH Env
##############################


# The location of the env file
export SSH_X_ENV="$HOME"/.ssh/ssh-agent.env
# The location of the agent socket
export SSH_AUTH_SOCK="$HOME"/.ssh/agent.sock
ssh-x-agent-init


# An alias
alias ssx="ssh-x"

