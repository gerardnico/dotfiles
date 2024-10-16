
# https://github.com/junegunn/fzf
if [ ! -x "$(command -v fzf)" ]; then
  if [ ! -x "$(command -v brew)" ]; then
    echo "Fzf not installed because brew is not installed"
    return
  fi
  brew install fzf
fi

# To set up shell integration, add this to your shell configuration file:
# bash
# It will take over `Ctrl+r`
eval "$(fzf --bash)"

# To use fzf in Vim, add the following line to your .vimrc:
# set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

## Concurrent
# https://github.com/ktr0731/go-fuzzyfinder
# https://github.com/jhawthorn/fzy