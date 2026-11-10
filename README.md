# Dotfiles

[dotfiles](https://en.wikipedia.org/wiki/dotfile) managed by [ChezMoi](https://www.chezmoi.io/)

## Steps

### Init a new laptop

See [how to init a new laptop](docs/init.md)

### Then for every change - apply with clean

With the executable [chezmoi-apply-clean](bin-local/executable_chezmoi-apply-clean)

```bash
chezmoi-apply-clean
```

## Concept

* [bin](bin) is first in `$PATH` then `.local/bin` so that we can build wrappers to inject secret
