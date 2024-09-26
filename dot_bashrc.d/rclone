#!/bin/bash

###############################
# Rclone completion
##############################
RCLONE_COMPLETION=/etc/bash_completion.d/rclone
if [ -x "$(command -v rclone)" ] && [ ! -f "$RCLONE_COMPLETION" ]; then
  sudo rclone genautocomplete bash $RCLONE_COMPLETION
  # shellcheck disable=SC1090
  source $RCLONE_COMPLETION
fi
