# How to set up a new laptop

## Step

### Install Chezmoi and prerequisites

#### Windows

* In PowerShell admin

```powershell
wsl --update
winget install twpayne.chezmoi
```

Optional: for Cygwin Only (Not WSL)

* Set your `%HOME%` to `c:\Users\$(whoami)` (ie `USERPROFILE`)
* Set the `%HOME%\bin` in your PATH on Windows

#### Linux or WSL

Prerequisites, curl, git (chezmoi)

```bash
# may be homebrew instead
apt-get install curl git
# We don't use the onliner script because we want a SSH connection git URL
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
```

### GitHub access

Create a temporary private key

```bash
ssh-keygen -t ed25519 -C "gerardnico@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
# Github > Settings > Ssh > Add key
cat ~/.ssh/id_ed25519
```

### Chez-moi init and apply

* Init

```bash
# wsl/linux
chezmoi init git@github.com:gerardnico/dotfiles.git --source $HOME/code/dotfiles
# Windows Cygwin (Chezmoi does the conversion, the source path should be in windows format)
chezmoi init https://github.com/gerardnico/dotfiles.git --source $USERPROFILE/code/dotfiles
# Windows Powershell/Dos
chezmoi init https://github.com/gerardnico/dotfiles.git --source %USERPROFILE%/code/dotfiles
```

* Then apply

```bash
# Wsl/Linux/Cygwin
chezmoi apply --source $HOME/code/dotfiles
# Windows
chezmoi apply --source %USERPROFILE%/code/dotfiles
```

### Extra

#### Extra on Linux

* Import the `master pgp` so that we can use pass.

```bash
gpg --trust-model always --import xxxx.asc # See gpg-pgp.md#my-backup-for-pass for the location
```

#### Extra on Windows

* Extra apps

```bash
winget install -e --id KeePassXCTeam.KeePassXC
winget install -e --id Dropbox.Dropbox
winget install -e --id JetBrains.Toolbox
winget install -e --id Docker.DockerDesktop
winget install -e --id Google.GoogleDrive
winget install headlamp
winget install -e --id Notepad++.Notepad++
winget install -e --id PuTTY.PuTTY
```

* ssh:
    * copy the key `pass ssh-x/wsl_id_rsa` on `~/.ssh`
    * add the [config](../dot_ssh/config)


* Then WinScp in Pref > Storage

```
Dropbox\config\WinScp\WinSCP.ini
```
