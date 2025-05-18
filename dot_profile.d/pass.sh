
# https://man.archlinux.org/man/extra/pass/pass.1.en#ENVIRONMENT_VARIABLES
export PASSWORD_STORE_DIR=$HOME/code/passpartout

# when third party library don't pass env
# the default is HOME/password
# we create a symlink
DEFAULT_PASS_STORE="$HOME/.password-store"
if [ ! -d "$DEFAULT_PASS_STORE" ]; then
  echo "Creating the symlink from $DEFAULT_PASS_STORE to $PASSWORD_STORE_DIR" > /dev/stderr
  ln -s "$PASSWORD_STORE_DIR" "$DEFAULT_PASS_STORE"
fi
