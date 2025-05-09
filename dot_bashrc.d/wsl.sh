
# Check the networking mode on wsl
# It may be nat or none

KERNEL=$(uname --kernel-release)
if [[ ! "$KERNEL" =~ "WSL" ]]; then
  # not wsl
  return
fi

MODE=$(wslinfo --networking-mode)
# mirrored does not work with IDEA
if [ "$MODE" == "mirrored" ]; then
  echo "!!!!!!!!!!!!!!!!!"
  echo "WSL Error : Networking mode is mirrored"
  echo "!!!!!!!!!!!!!!!!!"
fi
