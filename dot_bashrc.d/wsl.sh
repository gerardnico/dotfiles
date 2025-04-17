
# Check the networking mode on wsl
# It may be nat or none

KERNEL=$(uname --kernel-release)
if [[ ! "$KERNEL" =~ "WSL" ]]; then
  # not wsl
  return
fi

MODE=$(wslinfo --networking-mode)
if [ "$MODE" != "networking" ]; then
  echo "!!!!!!!!!!!!!!!!!"
  echo "WSL Error : Networking mode should be networking"
  echo "!!!!!!!!!!!!!!!!!"
fi
