

NEOVIM_PATH=/opt/nvim-linux64/bin
if [ -d $NEOVIM_PATH ]; then
  export PATH="$PATH:$NEOVIM_PATH"
  export EDITOR=nvim
fi
