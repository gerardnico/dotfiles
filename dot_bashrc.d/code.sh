#!/bin/bash
# Add all code/repo/bin directory into the PATH

# Find all bin directories in the second level of the code directory
add_bin_dirs_from_code_repo() {
    local BASE_DIR=$1

    # Use find to locate bin directories
    while IFS= read -r bin_dir; do
        # If this is a directory
        if [ -d "$bin_dir" ]; then
            if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
                export PATH="$1:$PATH"
            fi
        fi
    done < <(find "$BASE_DIR" -maxdepth 2 -type d -name "bin")

}

# Execute the function
add_bin_dirs_from_code_repo "$HOME"/code
