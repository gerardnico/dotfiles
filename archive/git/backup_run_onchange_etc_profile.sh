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
ETC_PROFILE_PATH=/etc/profile.d/nico_profile.sh
echo "$SCRIPT_NAME - Creating a profile file at $ETC_PROFILE_PATH"
# We use `tee` to be able to use sudo
# We could use `> /dev/null` to not see the output on the terminal

cat << EOF | sudo tee $ETC_PROFILE_PATH
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

EOF


