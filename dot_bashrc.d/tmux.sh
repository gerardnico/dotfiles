

if [ ! -x "$(command -v tmux)" ]; then
  echo "Tmux is not installed "
  echo "https://github.com/tmux/tmux/wiki/Installing"
  echo "sudo apt install -y tmux"
  echo "alias tmux=\"tmux attach\""
  return
fi

# If tmux is invoked without arguments, it will create a new session.
# we prevent it with this alias
alias tmux="tmux attach"



