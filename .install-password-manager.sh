#!/bin/sh
# https://www.chezmoi.io/user-guide/advanced/install-your-password-manager-on-init/
# Install Pass
# https://www.passwordstore.org/

# exit immediately if pass is already in $PATH
type pass >/dev/null 2>&1 && exit

OS=$(uname -s)
case "$OS" in
Linux)
    sudo apt-get install -y pass
    ;;
*)
    echo "unsupported OS: $OS"
    exit 1
    ;;
esac