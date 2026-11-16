# Shims

This binary are here to create wrapper (shims) that overrides binary
Other binary scripts should be created in [scripts](../scripts)

## Installation

* Default, you add a symlink created by [local installer](../scripts/executable_chezmoi-install-local) into
  `.local/bin` which is the default (for instance for git IDE detection)
* If you can't, because installer install in `~/.local/bin` (ie pipx, ...), you can create the shims in
  the [shims/bin directory](bin) (It is added to the PATH) (it wraps
  `.local/bin`)
