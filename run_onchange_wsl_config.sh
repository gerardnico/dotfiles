#!/bin/bash
# This script will copy from WSL .wslconfig to Windows %UserProfile%/.wslconfig
# From Windows or Linux host

# This is a windows file located in %UserProfile%
# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconfig

# All config are here
# https://learn.microsoft.com/en-us/windows/wsl/wsl-config

# Use wsl --shutdown to apply the new conf
# event restart for mirrored networking


# Standard env
SCRIPT_NAME=$(basename "$0")

# This script should not run on Windows if there is no interpreter
# https://www.chezmoi.io/reference/target-types/#scripts-on-windows
# but WSL install bash.exe at C:\Windows\System32\bash.exe
if [ "$CHEZMOI_OS" == "windows" ]; then
  USER_HOME=$HOME
else

  # Wsl config is for WSL Linux
  KERNEL=$(uname --kernel-release)
  if [[ ! "$KERNEL" =~ "WSL" ]]; then
    echo "$SCRIPT_NAME - Not WSL"
    exit
  fi

  # Hardcoded
  USER_HOME=/mnt/c/Users/ngera
fi

WSL_CONFIG=$USER_HOME/.wslconfig

echo "$SCRIPT_NAME - Creating file $WSL_CONFIG"
# We use `tee` to be able to use sudo
# We could use `> /dev/null` to not see the output on the terminal
cat << EOF | sudo tee "$WSL_CONFIG"

[wsl2]
# Access windows service as localhost from wsl
# https://github.com/microsoft/WSL/issues/5211
# You can check by running in Debian: <wslinfo --networking-mode>
# It will then not create the <vEthernet (WSL)> interface
# https://github.com/microsoft/WSL/issues/7267
networkingMode=mirrored
# https://stackoverflow.com/questions/69926941/localhost-refused-to-connect-on-wsl2-when-accessed-via-https-localhost8000-b
# kernelCommandLine=ipv6.disable=1

[experimental]
hostAddressLoopback=true


EOF


