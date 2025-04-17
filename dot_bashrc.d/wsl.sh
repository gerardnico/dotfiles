
# Check the networking mode on wsl
# It may be nat or none

KERNEL=$(uname --kernel-release)
if [[ ! "$KERNEL" =~ "WSL" ]]; then
  # not wsl
  return
fi

MODE=$(wslinfo --networking-mode)
if [ "$MODE" != "mirrored" ]; then
  echo "!!!!!!!!!!!!!!!!!"
  echo "WSL Error : Networking mode is $MODE and not mirrored"
  echo "!!!!!!!!!!!!!!!!!"
fi
