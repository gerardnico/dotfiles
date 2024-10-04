
# Depend on https://github.com/gerardnico/bash-lib/lib/error.sh
source $(libpath error.sh)

## A trap on ERR, if set, is executed before the shell exits.
# Because we show the $LINENO, we need to pass a command to the trap and not a function otherwise the line number would be not correct
trap 'error::handler "$LINENO" "${BASH_COMMAND}"' ERR