
# Gpg
# As seen here:
# https://gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
GPG_TTY=$(tty)
export GPG_TTY

# See https://wiki.archlinux.org/title/GnuPG#SSH_agent
# Eliminate SSH keys and use a GNU Privacy Guard (GPG) subkey instead.
# Use GPG key instead of SSH private keys
# GPG make key distribution and backup easier
# If you enabled the Ssh Agent Support, you also need to tell ssh about it by adding this to your init script:
# From: https://gnupg.org/documentation/manuals/gnupg/Agent-Examples.html
# unset SSH_AGENT_PID
# if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
#  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# fi