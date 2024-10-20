

#############################
# Tmux
#############################
if [ ! -x "$(command -v tmux)" ]; then
  echo "Tmux is not available"
fi

# We can't start tmux in bashrc because
# when tmux create a pane, it starts a login bash
# (and we call bashrc from /etc/profile)
# making it nested

# alias website="tmux attach-session -t website"
