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
GIT_WSL_PATH=/usr/local/sbin/git
echo "$SCRIPT_NAME - Creating a git wrapper at $GIT_WSL_PATH"
# We use `tee` to be able to use sudo
# We could use `> /dev/null` to not see the output on the terminal
cat << EOF | sudo tee $GIT_WSL_PATH
#!/usr/bin/env bash

# Wrapper to set the agent environment
# as this is stored as a file on WSL
# we can't pass it via Windows Env

# Used when git is called
# with the wsl cli from windows (ie Intellij)
# ie wsl git

source \$HOME/.bashenv.d/pass.sh
source \$HOME/.bashenv.d/ssh-x.sh

/usr/bin/git "\$@"
EOF

sudo chmod +x $GIT_WSL_PATH



