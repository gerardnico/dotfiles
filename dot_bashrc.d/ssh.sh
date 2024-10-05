##############################
# SSH Env
##############################
# Depend on https://github.com/gerardnico/bash-lib/lib/ssh.sh
# We start the SSH agent and load the keys

source bashlib-ssh.sh

# The location of the env file
export SSH_ENV="$HOME"/.ssh/ssh-agent.env
# The location of the agent socket
export SSH_AUTH_SOCK="$HOME"/.ssh/agent.sock

ssh::agent_init
