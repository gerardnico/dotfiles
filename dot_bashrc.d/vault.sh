# Hashicorp Vault

if [ -x "$(command -v vault)" ]; then

  export VAULT_ADDR=https://vault-188-245-43-250.sslip.io
  # https://developer.hashicorp.com/vault/docs/commands/login
  # `export VAULT_TOKEN=toor` is not necessary in case of `vault login` (for production use)

  # https://developer.hashicorp.com/vault/docs/commands#autocompletion
  # need to restart the shell
  # `vault -autocomplete-install` add the below line to bashrc
  complete -C /usr/bin/vault vault

fi