#!/usr/bin/env bash
# Configure /etc/ssh/sshd_config
# sudo apt update
# sudo apt install openssh-server
set -TCEeuo pipefail

# Standard env
SCRIPT_NAME=$(basename "$0")

# This script should not run on Windows if there is no interpreter
# https://www.chezmoi.io/reference/target-types/#scripts-on-windows
# but WSL install bash.exe at C:\Windows\System32\bash.exe
if [ "$CHEZMOI_OS" == "windows" ]; then
  echo "Running from bash Windows, exiting"
  exit
fi


# A WSL Linux
KERNEL=$(uname --kernel-release)
if [[ ! "$KERNEL" =~ "WSL" ]]; then
  echo "$SCRIPT_NAME - Not WSL"
  exit
fi


# Overwriting
SSHD_CONFIG=/etc/ssh/sshd_config
echo "$SCRIPT_NAME - Setting $SSHD_CONFIG"

# Tmp
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

#mkdir -p "$TMP"
echo "$TMP"
SRC="$TMP/sshd_config"

# Permissions
sudo mkdir -p /run/sshd
sudo chmod 0755 /run/sshd

# The Quoted delimiter (<<'EOF') will not expand $ or backticks inside the config.
cat <<'EOF' | tee "$SRC"
Include /etc/ssh/sshd_config.d/*.conf

Port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
KbdInteractiveAuthentication no
UsePAM yes
X11Forwarding no
AllowUsers admin

# Listen only for local connection
ListenAddress 127.0.0.1
ListenAddress ::1

EOF

# Validate the conf
if ! sudo sshd -t -f "$SRC"; then
  echo "Error on config"
  exit 1
else
  echo "No Config Error"
fi

# We use `tee` to be able to use sudo
# We could use `> /dev/null` to not see the output on the terminal


sudo install -o root -g root -m 0644 "$SRC" "$SSHD_CONFIG"

echo "Reload"
sudo systemctl stop sshd
sudo systemctl start sshd
