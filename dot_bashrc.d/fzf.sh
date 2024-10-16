
# https://github.com/junegunn/fzf
if [ ! -x "$(command -v fzf)" ]; then
  if [ ! -x "$(command -v brew)" ]; then
    echo "Fzf not installed because brew is not installed"
    return
  fi
  brew install fzf
fi

# Shell integration:
# it will bring:
#   * key bindings: https://github.com/junegunn/fzf#key-bindings-for-command-line
#     * `Ctrl+r` for history search
#     * `Alt+c` for cd
#   * Fuzzy completion (use `term**<TAB>` to trigger fuzzy search in command line)
eval "$(fzf --bash)"


# Fuzzy completion Trigger
# Only for supported command: https://github.com/junegunn/fzf?tab=readme-ov-file#supported-commands
export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Vim:
# To use fzf in Vim, add the following line to your .vimrc:
# set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

## Concurrent
# https://github.com/ktr0731/go-fuzzyfinder
# https://github.com/jhawthorn/fzy
