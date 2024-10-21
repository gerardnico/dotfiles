
# https://github.com/junegunn/fzf
if [ ! -x "$(command -v fzf)" ]; then
  echo "Fzf is not available"
  return
fi

# Old Fzf (found in cygwin for instance)
if ! fzf --help 2>&1 | grep bash > /dev/null; then
  echo "Fzf does not support bash completion"
  echo "Fzf Version: $(fzf --version)"
else
  # Shell integration:
  # it will bring:
  #   * key bindings: https://github.com/junegunn/fzf#key-bindings-for-command-line
  #     * `Ctrl+r` for history search
  #     * `Alt+c` for cd
  #   * Fuzzy completion (use `term**<TAB>` to trigger fuzzy search in command line)
  eval "$(fzf --bash)"
fi



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
