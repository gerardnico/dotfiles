#!/bin/bash
# Configure /etc/wsl.conf

# Standard env
SCRIPT_NAME=$(basename "$0")

# A script should not run on Windows if there is no interpreter
# https://www.chezmoi.io/reference/target-types/#scripts-on-windows
# but WSL install bash.exe at C:\Windows\System32\bash.exe
# We don't run it if the pwd is `/mnt/c/Users`
if [[ "$PWD" =~ "/mnt/c/Users" ]]; then
  echo "$SCRIPT_NAME - Running from bash Windows, exiting"
  exit
fi


# A WSL Linux
KERNEL=$(uname --kernel-release)
if [[ ! "$KERNEL" =~ "WSL" ]]; then
  echo "$SCRIPT_NAME - Not WSL"
  exit
fi

# To be able to send an email, a domain is needed
# for the EHLO command in SMTP
HOSTNAME=$(hostname)
DOMAIN=${HOSTNAME%%.*}
if [ "$DOMAIN" != "" ]; then
  echo "$SCRIPT_NAME - Check: Wsl hostname ($HOSTNAME) has the domain ($DOMAIN)"
  exit
fi

# Overwriting wsl
WSL_CONF=/etc/wsl.conf
HOSTNAME="$HOSTNAME.local"
echo "$SCRIPT_NAME - Setting Hostname to $HOSTNAME at $WSL_CONF"
# We use `tee` to be able to use sudo
# We could use `> /dev/null` to not see the output on the terminal
cat << EOF | sudo tee $WSL_CONF

[network]
hostname = $HOSTNAME

EOF


