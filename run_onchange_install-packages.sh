#!/usr/bin/env bash


# This script should not run on Windows if there is no interpreter
# https://www.chezmoi.io/reference/target-types/#scripts-on-windows
# but WSL install bash.exe at C:\Windows\System32\bash.exe
if [ "$CHEZMOI_OS" == "windows" ]; then
  echo "$(basename "$0") - Running from bash Windows, exiting"
  exit
fi

# Shebang is mandatory: https://github.com/twpayne/chezmoi/issues/666#issuecomment-612677019

# Install Package
# https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#install-packages-with-scripts
# You can do it also declaratively by using a yaml file [Package](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/)
# Run with `chezmoi apply` or `chezmoi update`

# The file run only if it has changed
# You can delete the script cache to run it again without changing the content
# See https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#run-a-script-when-the-contents-of-another-file-changes
#
echo "Install my Packages"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a package is installed
package_installed() {
    dpkg -l "$1" >/dev/null 2>&1
}

install_git_extras(){
  ## https://github.com/tj/git-extras/blob/main/Installation.md
  ## Only brew is maintained by the author
  if ! command_exists git-standup; then
    echo "Installing Git Extras"
    brew install git-extras
  else
    echo "Git Extra founds"
  fi
}

install_helm(){
  # See get Helms section at https://helm.sh/
  if ! command_exists helm; then
    echo "Installing Helm"
    brew install helm
  else
    echo "Helm founds"
  fi
}

install_gpg(){

  if  command_exists gpg; then
      echo "gpg command found"
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "gpg Windows Installation"
    # used by gopass
    winget install -e --id GnuPG.Gpg4win
    return
  fi

  # https://packages.debian.org/bookworm/gpg
  # https://packages.debian.org/bookworm/gpg-agent
  echo "gpg command installation"
  sudo apt -y install gnupg2 gnupg-agent

}

install_gpg_pinentry(){

  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "gpg pinentry Windows Installation not supported skipping"
      return
  fi

  if ! command_exists pinentry-qt; then
        echo "Installing pinentry-qt"
        sudo apt -y install pinentry-qt
        echo "Installed pinentry-qt"
  else
    echo "pinentry-qt command found"
  fi

  if ! command_exists info; then
    # info is needed to get the pinentry doc
    # with `info pinentry`
    sudo apt install -y info
  else
      echo "Info command found"
  fi
  # Doc for pinentry
  if ! package_installed pinentry-doc; then
    sudo apt install -y pinentry-doc
  else
    echo "Ggp pinentry-doc found"
  fi
}

install_yq(){
  if command_exists yq; then
    echo "Yq found"
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
    winget install -e --id MikeFarah.yq
    return
  fi
  echo "Installing yq"
  brew install yq
}

install_vagrant(){
  if command_exists vagrant; then
    echo "Vagrant Found"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "Vagrant Windows Installation Not done Skipping"
    return
  fi
  sudo apt install -y libfuse2
  echo "Installing Vagrant"
  brew tap hashicorp/tap
  brew install hashicorp/tap/vagrant
}

install_kind_kube_on_docker(){
  # Installation possibility is on quick start
  # https://kind.sigs.k8s.io/docs/user/quick-start
  if command_exists kind; then
    echo "Kind installed"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "Kind Windows Installation Not done Skipping"
    return
  fi
  echo "Installing Kind"
  brew install kind


}

install_mkcert(){

  if command_exists mkcert; then
    echo "mkcert installed"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "mkcert Windows Installation Not done Skipping"
    return
  fi
  # https://github.com/FiloSottile/mkcert?tab=readme-ov-file#linux
  echo "Installing mkcert"
  sudo apt install -y libnss3-tools
  brew install mkcert

}

install_cert_manager_cmctl(){
  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Cmctl Windows Installation Not done Skipping"
      return
  fi
  ## https://cert-manager.io/docs/reference/cmctl/#installation
  if command_exists cmctl; then
    echo "cmctl installed"
    return
  fi

  echo "Installing cmctl"
  brew install cmctl

}

install_git(){

  if command_exists git; then
    echo "Git Installed"
    return
  fi

  echo "Installing Git"
  if [ "$CHEZMOI_OS" == "windows" ]; then
    winget install -e --id Git.Git
    return
  fi

  sudo apt install git

}

get_os_name(){
  # Detect operating system
  uname -s | tr '[:upper:]' '[:lower:]'
}

get_cpu_arch_name(){

  # Detect CPU architecture
  ARCH=$(uname -m)

  # Map architecture to the binary names
  case "$ARCH" in
      x86_64)
          ARCH_NAME="amd64"
          ;;
      aarch64)
          ARCH_NAME="arm64"
          ;;
      arm*)
          ARCH_NAME="arm"
          ;;
      *)
          echo "Unsupported architecture: $ARCH"
          return 1
          ;;
  esac
  echo $ARCH_NAME

}

install_jsonnet_bundler_manager(){

  if  command_exists jb; then
    echo "jsonnet-bundler is installed (jsonnet package manager)"
    return
  fi

  echo "Installing jsonnet-bundler"
  # Construct the binary filename
  BINARY_NAME="jb-$(get_os_name)-$(get_cpu_arch_name)"

  # For Windows, add .exe extension
  if [ "$OS" == "windows" ]; then
      BINARY_NAME="${BINARY_NAME}.exe"
  fi

  # Base URL for downloads
  BASE_URL="https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v0.6.0/"

  # Full download URL
  DOWNLOAD_URL="${BASE_URL}${BINARY_NAME}"

  # Installation directory
  INSTALL_DIR="/usr/local/bin"

  # Download the binary directly to the system bin directory
  echo "Downloading $BINARY_NAME to $INSTALL_DIR/jb..."
  sudo curl -L -o "$INSTALL_DIR/jb" "$DOWNLOAD_URL"

  # Make the binary executable
  sudo chmod +x "$INSTALL_DIR/jb"

}

# https://github.com/brancz/gojsontoyaml/releases/tag/v0.1.0
install_go_json_to_yaml(){

  local BINARY="gojsontoyaml"

  if ! command_exists "$BINARY"; then

    # https://github.com/brancz/gojsontoyaml/releases/tag/v0.1.0
    local VERSION="0.1.0"
    echo "Installing $BINARY version $VERSION"

    # Download URL
    ARCHIVE_NAME="${BINARY}_${VERSION}_$(get_os_name)_$(get_cpu_arch_name).tar.gz"
    DOWNLOAD_URL="https://github.com/brancz/gojsontoyaml/releases/download/v${VERSION}/$ARCHIVE_NAME"
    echo "Downloading $ARCHIVE_NAME..."
    # Temporary directory for extraction
    TEMP_DIR=$(mktemp -d)
    curl -L -o "$TEMP_DIR/$ARCHIVE_NAME" "$DOWNLOAD_URL"

    echo "Extracting archive..."
    tar -xzf "$TEMP_DIR/$ARCHIVE_NAME" -C "$TEMP_DIR"
    # Find the binary in the extracted files
    BINARY_PATH=$(find "$TEMP_DIR" -name "${BINARY}" -type f)
    # Check if binary was found
    if [ -z "$BINARY_PATH" ]; then
        echo "Error: Could not find '${BINARY}' binary in the archive"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    # Installation directory
    INSTALL_DIR="/usr/local/bin"
    echo "Installing to $INSTALL_DIR/$BINARY..."
    sudo cp "$BINARY_PATH" "$INSTALL_DIR/$BINARY"
    sudo chmod +x "$INSTALL_DIR/$BINARY"
    # Clean up temporary files
    rm -rf "$TEMP_DIR"

  fi

  echo "$BINARY is installed"
}

# https://github.com/google/go-jsonnet
install_jsonnet(){
  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Jsonnet Windows Installation Not done Skipping"
      return
  fi
  if ! command_exists "jsonnet"; then
    echo "Installing jsonnet"
    brew install go-jsonnet
  fi

  echo "jsonnet is installed"
}

# https://nix.dev/manual/nix/2.24/installation/
install_nix(){

  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "Nix does not support windows - Skipping"
    return
  fi
  if ! command_exists "nix-shell"; then
      echo "Installing Nix"
      bash <(curl -L https://nixos.org/nix/install) --no-daemon
  fi

  echo "Nix is already installed"

}

install_zoxide_cd(){
  # cd on
  if command_exists zoxide; then
    echo "Zoxide Found"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "Zoxide Windows Installation"
    winget install ajeetdsouza.zoxide
    return
  fi
  echo "Brew Installing Zoxide"
  brew install zoxide

}

install_lazy_git(){
  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "LazyGit Windows Installation Not done Skipping"
    return
  fi
  if ! command_exists lazygit; then
    echo "Installing LazyGit"
    brew install jesseduffield/lazygit/lazygit
  else
    echo "LazyGit Found"
  fi
}

install_envsubst(){
  if command_exists envsubst; then
    echo "GetText envsubst installed"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "envsubst on Windows should be installed with Cygwin"
    return
  fi

  sudo apt install -y gettext

}

install_telnet(){
  if command_exists telnet; then
    echo "Telnet installed"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Telnet Windows Installation"
      # https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc771275(v=ws.10)
      pkgmgr /iu:"TelnetClient"
      return
  fi
  echo "Telnet Apt Installation"
  sudo apt install -y telnet
}

install_git

install_zoxide_cd


# fuzzy finder
if ! command_exists fzf; then
  echo "Installing Fzf"
  brew install fzf
else
  echo "Fzf Found"
fi

# rsync
if ! command_exists rsync; then
  echo "Installing Rsync"
  sudo apt install -y rsync
else
  echo "Rsync Found"
fi

# tmux
if ! command_exists tmux; then
  echo "Installing Tmux"
  # https://github.com/tmux/tmux/wiki/Installing
  sudo apt install -y tmux
  echo "Tmux: Don't forget to disable the ALT+Fn shortcut on MinTty Wsl/Cygwin"
else
  echo "Tmux Found"
fi

# Call Install function
install_git_extras

# Lazy git
install_lazy_git

if ! command_exists nc; then
  sudo apt install -y netcat-openbsd
else
  echo "Netcat installed"
fi

# Needed with ssh
if ! command_exists ssh-askpass; then
  sudo apt install -y ssh-askpass
else
  echo "ssh-askpass installed"
fi

# https://mailutils.org
if ! command_exists mail; then
  sudo apt install -y mailutils
  sudo apt install -y libmailutils-dev # mailutils command
  sudo apt install -y mailutils-mda # putmail
else
  echo "Mailutils installed"
fi


install_telnet

install_envsubst


# Gpg
install_gpg
install_gpg_pinentry
# Yq
install_yq
# Vagrant
# install_vagrant
install_kind_kube_on_docker
# Mkcert
install_mkcert
# Cert manager cmctl
install_cert_manager_cmctl
# Install jsonnet bundler (package manager)
install_jsonnet_bundler_manager
# Install utility gojsontoyaml
install_go_json_to_yaml
# Install jsonnet
install_jsonnet
# Install nix
install_nix
# Helm
install_helm
