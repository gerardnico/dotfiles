#!/bin/bash

# set -Eeuo pipefail on each script at the top
# where the flag are:
# e - Exit if any error
# u - Treat unset variables as an error when substituting
# o pipefail - the return value of a pipeline is the status of the last command to exit with a non-zero status or zero if no command exited with a non-zero status
# E - the ERR trap is inherited by shell functions


print_stack(){
  # CallStack with FUNCNAME
  # The FUNCNAME variable exists only when a shell function is executing.
  # The last element is `main` with the current script being 0

  # For enhancement the caller function can be used
  # caller displays the line number, subroutine name, and source file corresponding to that position in the current execution call stack
  # caller 0 will return the actual executing function
  # caller 1 will return the actual caller
  # It returns the function and the script
  # example: main /opt/dokuwiki-docker/bin/dokuwiki-docker-entrypoint
  # See https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-caller

  # If FUNCNAME has only one element, it's the main script
  # No stack print needed
  if [ ${#FUNCNAME[@]} = 1 ]; then
      return;
  fi
  echo_err "Call Stack:"
  for ((i=0; i < ${#FUNCNAME[@]}; i++)) do
      echo_err "  $i: ${BASH_SOURCE[$i]}#${FUNCNAME[$i]}:${BASH_LINENO[$i]}"
  done
}

# Define the error handling function
error_handler() {

    local err=$?
    local line=$1
    local command="$2"
    echo_err ""
    echo_err "Command '$command' exited with status $err."
    echo_err ""
    SCRIPT=${BASH_SOURCE[1]}
    if [ "$SCRIPT" == "" ]; then
      # Line is completely off in this case
      echo_err "Error on the main script."
      echo_err "Possible causes: (as no location was given for the error by Bash)"
      echo_err "   The command was not found"
      echo_err "   The command is a bash builtin-command (shift, ...)"
      echo_err '   The `source` key word was forgotten '
      return
    fi
    echo_err "Error on $SCRIPT line $line"

    echo_err ""
    print_stack

}


## A trap on ERR, if set, is executed before the shell exits.
# Because we show the $LINENO, we need to pass a command to the trap and not a function otherwise the line number would be not correct
trap 'error_handler "$LINENO" "${BASH_COMMAND}"' ERR

## A simple trap to copy on external file
# trap 'echo_err ""; echo_err "Command error on line ($0:$LINENO)"; exit 1' ERR