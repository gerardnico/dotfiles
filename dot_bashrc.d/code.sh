#!/bin/bash
# Add all code/repo/bin directory into the PATH

# Find all bin directories in the second level of the code directory
add_bin_dirs_from_code_repo() {
    local BASE_DIR
    BASE_DIR=$(readlink -f "$1")

    # Use find to locate bin directories
    while IFS= read -r bin_dir; do
        # If this is a directory
        if [ ! -d "$bin_dir" ]; then
          continue
        fi
        # already in path
        if [[ ":$PATH:" == *":$bin_dir:"* ]]; then
          continue
        fi
        # don't add kubee
        if [[ "$bin_dir" == *"kubee"* ]]; then
          continue
        fi
        export PATH="$bin_dir:$PATH"
    done < <(find "$BASE_DIR" -maxdepth 2 -type d -name "bin")

}

export CODE_HOME
CODE_HOME="$HOME"/code

# Execute the function
add_bin_dirs_from_code_repo "$CODE_HOME"

# Bash lib
BASHLIB_LIBRARY_PATH="$CODE_HOME/bash-lib/lib"
if [ -d "$BASHLIB_LIBRARY_PATH" ]; then
  export PATH="$BASHLIB_LIBRARY_PATH:$PATH"
fi
