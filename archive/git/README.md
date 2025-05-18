# Git integration

Git is called by a lot of tools:
* Idea
* Brew
and is called without env leading to error.

We tried to create wrapper and all but the most
efficient resolution was to just create symlink
for the default values.

For instance, for pass that expect to have the store under home 
```bash
ln -s "$PASSWORD_STORE_DIR" "$HOME/.password-store"
```

