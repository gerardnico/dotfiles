#!/bin/bash
# Create git in wsl

# Standard env
SCRIPT_NAME=$(basename "$0")

# This script should not run on Windows if there is no interpreter
# https://www.chezmoi.io/reference/target-types/#scripts-on-windows
# but WSL install bash.exe at C:\Windows\System32\bash.exe
if [ "$CHEZMOI_OS" == "windows" ]; then
  echo "$(basename "$0") - Running from bash Windows, exiting"
  exit
fi


# A WSL Linux
KERNEL=$(uname --kernel-release)
if [[ ! "$KERNEL" =~ "WSL" ]]; then
  echo "$SCRIPT_NAME - Not WSL"
  exit
fi



# Overwriting wsl
GIT_WRAPPER_TARGET_PATH=/usr/local/sbin/git


echo "$SCRIPT_NAME - Creating a git wrapper at $GIT_WRAPPER_TARGET_PATH"
# We use `tee` to be able to use sudo
# We could use `> /dev/null` to not see the output on the terminal

cat << EOF | sudo tee $GIT_WRAPPER_TARGET_PATH
#!/usr/bin/env bash

# Wrapper to set the agent environment
# as this is stored as a file on WSL
# we can't pass it via Windows Env

# Used when git is called
# with the wsl cli from windows (ie Intellij)
# ie wsl git

if [ -d "$HOME/.profile.d" ]; then
  # All file loaded in a directory should have a sh extension
  # This is how /etc/profile also work
  for file in "$HOME"/.profile.d/*.sh; do
    # shellcheck disable=SC1090
    [ -r "\$file" ] && source "\$file"
  done
  unset file
fi

# Which git is wrapped (os or Brew)
GIT_WRAPPED=/usr/bin/git
GIT_BREW=/home/linuxbrew/.linuxbrew/bin/git
if [ -f "$GIT_BREW" ]; then
  GIT_WRAPPED=\$GIT_BREW
fi

\$GIT_WRAPPED "\$@"
EOF

sudo chmod +x $GIT_WRAPPER_TARGET_PATH



