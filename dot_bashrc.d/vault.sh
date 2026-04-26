# Hashicorp Vault

if [ -x "$(command -v vault)" ]; then

  # https://developer.hashicorp.com/vault/docs/commands#autocompletion
  # need to restart the shell
  # `vault -autocomplete-install` add the below line to bashrc
  complete -C /usr/bin/vault vault

fi
