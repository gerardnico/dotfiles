

#############################
# Tmux
#############################
if [ ! -x "$(command -v tmux)" ]; then
  echo "Tmux is not installed "
  echo "https://github.com/tmux/tmux/wiki/Installing"
  echo "On debian"
  echo "  sudo apt install -y tmux"
  echo "Don't forget to disable the ALT+Fn shortcut on MinTty Wsl"
fi

# We can't start tmux in bashrc because
# when tmux create a pane, it starts a login bash
# (and we call bashrc from /etc/profile)
# making it nested

# alias website="tmux attach-session -t website"
