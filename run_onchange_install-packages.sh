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

install_gpg_pinentry(){

  if ! command_exists gpg; then
    # https://packages.debian.org/bookworm/gpg
    # https://packages.debian.org/bookworm/gpg-agent
    sudo apt -y install gnupg2 gnupg-agent
  else
    echo "gpg command found"
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
  if ! command_exists yq; then
    echo "Installing yq"
    brew install yq
  else
    echo "Yq found"
  fi
}

install_vagrant(){
  if ! command_exists vagrant; then
    sudo apt install -y libfuse2
    echo "Installing Vagrant"
    brew tap hashicorp/tap
    brew install hashicorp/tap/vagrant
  else
    echo "Vagrant Found"
  fi
}

install_kind_kube_on_docker(){
  # Installation possibility is on quick start
  # https://kind.sigs.k8s.io/docs/user/quick-start
  if ! command_exists kind; then
    echo "Installing Kind"
    brew install kind
  else
    echo "Kind installed"
  fi

}

if ! command_exists git; then
  echo "Installing Git"
  sudo apt install git
else
  echo "Git Found"
fi

# cd on
if ! command_exists zoxide; then
  echo "Installing Zoxide"
  brew install zoxide
else
  echo "Zoxide Found"
fi

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

if ! command_exists lazygit; then
  echo "Installing LazyGit"
  brew install jesseduffield/lazygit/lazygit
else
  echo "LazyGit Found"
fi

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

if ! command_exists telnet; then
  sudo apt install -y telnet
else
  echo "Telnet installed"
fi

if ! command_exists envsubst; then
  sudo apt install -y gettext
else
  echo "GetText envsubst installed"
fi

# Gpg
install_gpg_pinentry
# Yq
install_yq
# Vagrant
# install_vagrant

install_kind_kube_on_docker