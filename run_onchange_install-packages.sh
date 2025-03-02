#!/usr/bin/env bash
# Shebang is mandatory: https://github.com/twpayne/chezmoi/issues/666#issuecomment-612677019

set -TCEeuo pipefail

# Install Package
# https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#install-packages-with-scripts
# You can do it also declaratively by using a yaml file [Package](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/)

# Run with `chezmoi apply` or `chezmoi update`after a file change

# The file run only if it has changed
# You can delete the script cache to run it again without changing the content
# See https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#run-a-script-when-the-contents-of-another-file-changes
#
echo "$(basename "$0") - Install my Packages"

# Function to check if a command exists
command_exists() {
    # start to check subcommand such as `kubectl oidc-login`
    # does not work always for subcommand, you could just do `if command -help >/dev/null 2>1; then`
    command -v "$@" >/dev/null 2>&1
}

# sudo is not available on windows
# This function executes it only if found
sudo_safe(){
  echo "Executing $*"
  if command -v sudo; then
    sudo "$@"
    return
  fi
  eval "$*"
}

# Winget modify the PATH of windows
# If we are working in a IDE, the path is not up to date
# We use this function to check if the package is already installed
winget_package_play(){

  local package_id="$1"
  # Check if the package is installed
  if winget list --id "$package_id" &> /dev/null; then
      echo "Package '$package_id' is installed."
      return
  fi

  echo "Winget installing '$package_id'"
  winget install --exact --id "$package_id"

}

# Binary
# Version
# Base
#
install_from_github_go_release(){

    local REPO="$1"
    local BINARY="$2" # The project
    local VERSION="$3"
    local FINAL_BINARY="${4:-$BINARY}"
    echo "Installing $BINARY version $VERSION"

    # Download URL
    ARCHIVE_NAME="${BINARY}_${VERSION}_$(get_os_name)_$(get_cpu_arch_name).tar.gz"
    DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${VERSION}/$ARCHIVE_NAME"
    echo "Downloading $ARCHIVE_NAME..."
    # Temporary directory for extraction
    TEMP_DIR=$(mktemp -d)
    curl -L -o "$TEMP_DIR/$ARCHIVE_NAME" "$DOWNLOAD_URL"

    echo "Extracting archive..."
    tar -xzf "$TEMP_DIR/$ARCHIVE_NAME" -C "$TEMP_DIR"
    # Find the binary in the extracted files
    BINARY_PATH=$(find "$TEMP_DIR" -name "${FINAL_BINARY}" -type f)
    # Check if binary was found
    if [ -z "$BINARY_PATH" ]; then
        echo "Error: Could not find '${FINAL_BINARY}' binary in the archive"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    # Installation directory
    INSTALL_DIR="/usr/local/bin"
    echo "Installing to $INSTALL_DIR/$FINAL_BINARY..."
    sudo cp "$BINARY_PATH" "$INSTALL_DIR/$FINAL_BINARY"
    sudo chmod +x "$INSTALL_DIR/$FINAL_BINARY"
    # Clean up temporary files
    rm -rf "$TEMP_DIR"
}

# Install from a exe file
# Not an archive
install_from_github_binary(){

    local REPO="$1"
    local BINARY_NAME=$2 # the target name example: jb
    local version="$3"
    local downloadFileName="${4:-$2}" # the file to download. ex: jb-win.exe
    # Base URL for downloads
    local BASE_URL="https://github.com/$REPO/releases/download/$version/"

    # Full download URL
    local DOWNLOAD_URL="${BASE_URL}${downloadFileName}"

    # Installation directory
    local INSTALL_DIR="/usr/local/bin"
    # Local bin is not created in a cygwin/git bash env
    if [ ! -d "$INSTALL_DIR" ]; then
      INSTALL_DIR="/usr/bin";
    fi

    # Download the binary directly to the system bin directory
    echo "Downloading $BINARY_NAME to $INSTALL_DIR/$BINARY_NAME..."
    sudo_safe curl -L -o "$INSTALL_DIR/$BINARY_NAME" "$DOWNLOAD_URL"


    # Make the binary executable
    sudo_safe chmod +x "$INSTALL_DIR/$BINARY_NAME"


}

# Function to check if a package is installed
package_installed() {
    dpkg -l "$1" >/dev/null 2>&1
}

install_kubectl_oidc_login(){

  if command_exists kubectl oidc-login; then
      echo "Kubectl oidc-login found"
      return
  fi

  if ! command_exists kubectl; then
    echo "Kubectl was not found. oidc-login cannot be installed"
    return 1
  fi
  # Windows, linux, ...
  # https://github.com/int128/kubelogin/tree/master?tab=readme-ov-file#setup
  kubectl krew install oidc-login

}

install_helm_plugin(){

  local subcommand=$1
  local url=$2
  if ! command_exists "helm"; then
    echo "Helm was not found. $subcommand plugin cannot be installed"
    return 1
  fi

  # The command exists does work with helm plugin ..
  # Testing the help option instead
  # shellcheck disable=SC2210
  if helm "$subcommand" --help >/dev/null 2>&1 ; then
      echo "Helm diff plugin founds"
      return
  fi

  # Windows, linux, ...
  # https://github.com/dadav/helm-schema#installation
  echo "helm $subcommand installation"
  helm plugin install "$url"

  # Deprecated
  # https://github.com/losisin/helm-values-schema-json#installation
  # helm plugin install https://github.com/losisin/helm-values-schema-json.git

}

# Postal Installation Helper
# https://docs.postalserver.io/getting-started/prerequisites#git-installation-helper-repository
install_postal(){
  if command_exists postal; then
      echo "Postal founds"
      return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
      # it's bash script, should work
      echo "Sorry postal installation on Windows not yet done"
      return
  fi
  echo "Postal installation"
  sudo git clone https://github.com/postalserver/install /opt/postal/install
  sudo ln -s /opt/postal/install/bin/postal /usr/bin/postal
  echo "Postal installation done"

}
# https://taskfile.dev/installation/
install_go_task(){
  if command_exists task; then
        echo "Task founds"
        return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Tasks installation on Windows"
      winget install Task.Task
      return
  fi
  echo "Installing brew task"
  brew install go-task/tap/go-task
  echo "Tasks installed"
}

# https://jetmore.org/john/code/swaks/installation.html
install_mail_swaks(){

  if command_exists swaks; then
      echo "Swaks founds"
      return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Swaks installation on Windows not supported"
      return
  fi
  echo "Installing swaks"
  brew install swaks
  echo "Swaks installed"
}

install_helm_readme_generator(){

  if command_exists readme-generator-for-helm; then
      echo "readme-generator-for-helm founds"
      return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "readme-generator-for-helm Windows Installation not supported"
      return
  fi

  # Nix script
  echo "readme-generator-for-helm not found, installation"
  "$HOME"/bin/install/install-helm-readme-generator
  echo "readme-generator-for-helm installed"

}
install_git_extras(){
  ## https://github.com/tj/git-extras/blob/main/Installation.md
  ## Only brew is maintained by the author
  if command_exists git-standup; then
    echo "Git Extra founds"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
      # https://github.com/tj/git-extras/blob/main/Installation.md#windows
      # Subshell to not change the working directory
     (
      local WORK_DIR
      WORK_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}/git-extras"
      rm -rf "$WORK_DIR"
      mkdir -p "$WORK_DIR"
      git clone https://github.com/tj/git-extras.git "$WORK_DIR"
      # checkout the latest tag (optional)
      cd "$WORK_DIR";
      git checkout "$(git describe --tags "$(git rev-list --tags --max-count=1)")"
      chmod +x install.cmd
      ./install.cmd
      )
      return
  fi

  echo "Installing Git Extras"
  brew install git-extras

}

# https://github.com/norwoodj/helm-docs?tab=readme-ov-file#installation
install_helm_docs(){
  # See get Helms section at https://helm.sh/
  if command_exists helm-docs; then
    echo "Helm Docs founds"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Helm docs Windows Installation not yet implemented"
      # should be
      # docker run --rm --volume "$(pwd):/helm-docs" -u $(id -u) jnorwood/helm-docs:latest
      return
  fi

  echo "Brew Installing Helm Docs"
  brew install norwoodj/tap/helm-docs
  echo "Helm Docs Installed"

}

install_helm(){

  # See get Helms section at https://helm.sh/
  if command_exists helm; then
    echo "Helm founds"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Helm Windows Installation"
      # https://helm.sh/docs/intro/install/#from-winget-windows
      winget install Helm.Helm
      return
  fi

  echo "Brew Installing Helm"
  brew install helm

}

install_gpg(){

  if  command_exists gpg; then
      echo "gpg command found"
      return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "gpg Windows Installation"
    # used by gopass
    winget_package_play GnuPG.Gpg4win
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
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
    winget_package_play MikeFarah.yq
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
    echo "Kind Windows Installation"
    winget_package_play Kubernetes.kind
    return
  fi
  echo "Brew Installing Kind"
  brew install kind

}

install_mkcert(){

  if command_exists mkcert; then
    echo "mkcert installed"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "mkcert Windows Installation"
    winget_package_play FiloSottile.mkcert
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

  echo "Brew Installing cmctl"
  brew install cmctl

}

install_git(){

  if command_exists git; then
    echo "Git Installed"
    return
  fi


  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "Winget Installing Git"
    winget install -e --id Git.Git
    return
  fi

  echo "Brew Installing Git"
  brew install git

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

  install_from_github_binary "jsonnet-bundler/jsonnet-bundler" "jb" "v0.6.0" "jb-windows-amd64.exe"


}

# https://github.com/brancz/gojsontoyaml/releases/tag/v0.1.0
install_go_json_to_yaml(){

  local BINARY="gojsontoyaml"

  if command_exists "$BINARY"; then
    echo "$BINARY is already installed"
    return
  fi

  install_from_github_go_release "brancz/gojsontoyaml" "$BINARY" "0.1.0"

}

# https://github.com/google/go-jsonnet
install_jsonnet(){

  local FINAL_BINARY="jsonnet"
  if command_exists "$FINAL_BINARY"; then
    echo "Jsonnet is already installed"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Jsonnet Windows Installation Not done Skipping"
      install_from_github_go_release "google/go-jsonnet" "go-jsonnet" "0.20.0" "$FINAL_BINARY"
      return
  fi

  echo "brew jsonnet installation"
  brew install go-jsonnet

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
    winget_package_play "ajeetdsouza.zoxide"
    return
  fi
  echo "Brew Installing Zoxide"
  brew install zoxide

}

install_lazy_git(){

  if command_exists lazygit; then
    echo "LazyGit Found"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "LazyGit Windows Installation"
      winget_package_play JesseDuffield.lazygit
      return
  fi

  echo "Brew Installing LazyGit"
  brew install jesseduffield/lazygit/lazygit

}

install_envsubst(){

  if command_exists envsubst; then
    echo "GetText envsubst installed"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "envsubst on Windows should be installed with the GetText Cygwin Package"
    return
  fi

  sudo apt install -y gettext

}

# fuzzy finder
install_fzf(){
  if command_exists fzf; then
    echo "Fzf Found"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
      # https://github.com/junegunn/fzf#windows-packages
      echo "Windows fzf Windows Installation"
      winget_package_play "fzf"
      return
  fi
  echo "Brew Installing Fzf"
  brew install fzf
}

install_telnet(){
  if command_exists telnet; then
    echo "Telnet installed"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Telnet Windows Installation"
      # https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc771275(v=ws.10)
      if ! net session; then
        echo "To install telnet, you should be in a elevated terminal"
        echo "Execute"
        echo "pkgmgr /iu:\"TelnetClient\""
        return 1
      fi
      pkgmgr /iu:"TelnetClient"
      return
  fi
  echo "Telnet Apt Installation"
  sudo apt install -y telnet
}

# https://rsync.samba.org/download.html
install_rsync(){

  # rsync
  if command_exists rsync; then
    echo "Rsync Found"
    return
  fi
  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "Rsync Windows Installation should be done via Cygwin"
    return
  fi
  echo "Brew Installing Rsync"
  brew install rsync

}

install_tmux(){
  if command_exists tmux; then
    echo "Tmux Found"
    return
  fi

  # https://github.com/tmux/tmux/wiki/Installing
  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Tmux is not supported on Windows"
      return
  fi

  echo "Installing Tmux"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "Tmux: Don't forget to disable the ALT+Fn shortcut on MinTty Wsl/Cygwin"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

  brew install tmux

}


# https://sectools.org/tool/netcat/
# https://netcat.sourceforge.net/
install_netcat_nmap(){
  if command_exists nc; then
    echo "Netcat found"
    return;
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
      # On windows, ncat from nmap
      # https://nmap.org/ncat/
      echo "Windows install ncat (via nmap)"
      winget_package_play Insecure.Nmap
      return
  fi

  # https://formulae.brew.sh/formula/netcat
  brew install netcat

}

# ? A ssh askpass gui prompt
# https://packages.debian.org/bookworm/ssh-askpass
# Orphaned: https://tracker.debian.org/pkg/ssh-askpass
# Do we really need that? Uses nix instead
install_ssh_askpass(){
  # Needed with ssh
  if command_exists ssh-askpass; then
    echo "ssh-askpass installed"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "Ssh askpass is not a windows package"
    return
  fi
  echo "Installing askpass"
  sudo apt install -y ssh-askpass
}

install_mail_utils(){
  # https://mailutils.org
  if command_exists mail; then
    echo "Mailutils installed"
    return
  fi

  if [ "$CHEZMOI_OS" == "windows" ]; then
    echo "Mailutils package Installation should be done from Cygwin"
    return
  fi

  # Apt Old
  #  sudo apt install -y mailutils
  #  sudo apt install -y libmailutils-dev # mailutils command
  #  sudo apt install -y mailutils-mda # putmail
  echo "Brew Install Mailtuils"
  # https://formulae.brew.sh/formula/mailutils
  brew install mailutils

}

# Pre-commit
# https://pre-commit.com/#installation
install_pre_commit(){
  if command_exists pre-commit; then
     echo "Pre-commit already installed"
     return
  fi

  echo "Pre-commit installation"
  pip install pre-commit
  echo "Pre-commit installed"

}

# https://github.com/Foundry376/Mailspring/tree/master
install_mail_spring_gui(){

  if command_exists mailspring; then
    echo "Mail spring installed"
    return
  fi

  # https://github.com/Foundry376/Mailspring/tree/master
  if [ "$CHEZMOI_OS" == "windows" ]; then
      echo "Mailspring Windows Installation"
      # https://winget.run/pkg/Foundry376/Mailspring
      winget install -e --id Foundry376.Mailspring
      return
  fi

  echo "Mailspring Brew Installation"
  # https://formulae.brew.sh/cask/mailspring#default
  brew install --cask mailspring

}


## Installation
main(){

  # For python installation, the venv should be configured
  local PYTHON_CONF="$HOME/.bashrc.d/python.sh"
  if [ ! -f "$PYTHON_CONF" ]; then
    echo "Python venv conf file was not found ($PYTHON_CONF)"
    return 1
  fi
  # shellcheck disable=SC1090
  source "$PYTHON_CONF"

  # Task Runner
  install_go_task

  # Pre-commit
  install_pre_commit

  # Git
  install_git
  # Zoxide cd
  install_zoxide_cd
  # Fuzzy finder
  install_fzf
  # Rsync
  install_rsync
  # tmux
  install_tmux
  # standup
  install_git_extras
  # Lazy git
  install_lazy_git
  # nc / netcat
  install_netcat_nmap
  # Mail Util
  install_mail_utils
  # Telnet
  install_telnet
  # Get text subset
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
  # Helm Docs
  install_helm_docs
  # Install The readme generator (Deprecated)
  # install_helm_readme_generator
  # Install Helm Schema
  install_helm_plugin 'schema' 'https://github.com/dadav/helm-schema'
  install_helm_plugin 'diff' 'https://github.com/databus23/helm-diff'
  # Install kubectl and oidc-login
  install_kubectl_oidc_login
  # Install swaks email client
  install_mail_swaks
  # Install postal helper
  install_postal
}

main