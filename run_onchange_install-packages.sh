#!/bin/bash

# This script should not run on Windows if there is no interpreter
# https://www.chezmoi.io/reference/target-types/#scripts-on-windows
# but WSL install bash.exe at C:\Windows\System32\bash.exe
# We don't run if the pwd is `/mnt/c/Users`
if [[ "$PWD" =~ "/mnt/c/Users" ]]; then
  echo "Running from bash Windows, exiting"
  exit
fi

# Shebang is mandatory: https://github.com/twpayne/chezmoi/issues/666#issuecomment-612677019
# We use a template to disable the script on windows/cygwin
# If the output is empty, the script is not run
# On Windows, we get `%1 is not a valid Win32 application.`

# To get the syntax highlighting we moved the installation script
bin/install-all
