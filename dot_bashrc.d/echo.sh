#!/bin/bash


function calling_script(){
  # caller return the line, the function and the script
  # example: 10 main /opt/dokuwiki-docker/bin/dokuwiki-docker-entrypoint
  CALLING_SCRIPT=$(caller 1 | awk '{print $3}')
  # Name of the calling script
  CLI_NAME=$(basename "$CALLING_SCRIPT")
  echo "$CLI_NAME"
}


# Echo an info message
function echo_info() {

  # We send all echo to the error stream
  # so that any redirection will not get them
  # this is the standard behaviour of git
  echo -e "$(calling_script): ${1:-}" >&2

}

# Print the error message $1
echo_err() {
  echo_info "${RED}Error: $1${NC}"
}

# Function to echo text in green (for success messages)
echo_success() {
    echo_info -e "${GREEN}Success: $1${NC}"
}

# Function to echo text in yellow (for warnings)
echo_warning() {
    echo_info -e "${YELLOW}Warning: $1${NC}"
}

# No idea if this is needed
export -f echo_err
export -f echo_info
export -f echo_warning
export -f calling_script