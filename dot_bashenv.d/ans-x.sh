
##############################
# Ans-x
##############################
# Vault id
export ANS_X_VAULT_ID_PASS=ansible/vault-password
# SSH Key
export ANS_X_SSH_KEY_PASS=ssh-x/id_gerardnico_kube


# Bin in Path (Add the ansible scripts)
ANS_X_BIN_DIR=$HOME/code/ansible/bin
if [ -d "$ANS_X_BIN_DIR" ]; then
  export PATH="$ANS_X_BIN_DIR:$PATH"
fi

##############################
# Ansible Docker Env
##############################
# Project Dir
#ANS_X_PROJECT_DIR=$HOME/code/infra
#if [ -d "$ANS_X_PROJECT_DIR" ]; then
#  export ANS_X_PROJECT_DIR
#fi
# https://github.com/gerardnico/ansible
#export ANSIBLE_CONFIG=ansible.cfg
#export ANSIBLE_HOME=ansible




