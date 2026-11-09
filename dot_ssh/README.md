## The Windows key to connect on WSL

For herdr, we added [sshd](../run_onchange_sshd_config.sh)

To log in from Windows into WSL:

* copy the `private key` (`pass ssh-x/wsl_id_rsa`)
* add in the config

```
Host localhost
    HostName localhost
    Port 22
    User admin
    IdentityFile ~/.ssh/wsl_id_rsa
    IdentitiesOnly yes
```

* The corresponding public key is in [authorized](authorized_keys)
