#!/bin/bash

##############################
# Node
##############################
# fnm Eval for the search of node version file on each cd
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  # Set default to system to avoid: Can't find an installed Node version matching default
  fnm default system
  eval "$(fnm env --use-on-cd --shell bash --version-file-strategy recursive --log-level info)" >/dev/null 2>&1
  # https://github.com/Schniz/fnm?tab=readme-ov-file#completions
  # The below output only the completion script
  eval "$(fnm completions --shell bash)"
fi
