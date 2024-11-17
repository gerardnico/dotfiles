
##############################
# Ans-x
##############################
# Vault id
export ANS_X_VAULT_ID_PASS=ansible/vault-password

# Project Dir
ANS_X_PROJECT_DIR=$HOME/code/infra
if [ -d "$ANS_X_PROJECT_DIR" ]; then
  export ANS_X_PROJECT_DIR
fi

# Bin in Path (Add the ansible scripts)
ANS_X_BIN_DIR=$HOME/code/ansible/bin
if [ -d "$ANS_X_BIN_DIR" ]; then
  export PATH="$ANS_X_BIN_DIR:$PATH"
fi

##############################
# Ansible Docker Env
##############################
# https://github.com/gerardnico/ansible
export ANSIBLE_CONFIG=ansible.cfg
export ANSIBLE_HOME=ansible




