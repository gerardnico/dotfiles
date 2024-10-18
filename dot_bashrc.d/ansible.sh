

##############################
# Ansible Docker Env
##############################
# https://github.com/gerardnico/ansible
export ANSIBLE_CONFIG=ansible.cfg
export ANSIBLE_HOME=ansible
ANSIBLE_SCRIPTS=$HOME/code/ansible
if [ -d "$ANSIBLE_SCRIPTS" ]; then
  export PATH="$ANSIBLE_SCRIPTS:$PATH"
fi
ANSIBLE_LOCAL_HOME=$HOME/code/infra
if [ -d "$ANSIBLE_SCRIPTS" ]; then
  export ANSIBLE_LOCAL_HOME
fi
