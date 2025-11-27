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
        # We set them last. The packager has a higher priority
        # If the developer want to change this priority
        # it should go to the project directory that will change it via .envrc
        export PATH="$PATH:$bin_dir"
    done < <(find "$BASE_DIR" -maxdepth 2 -type d -name "bin")

}

export CODE_HOME
CODE_HOME="$HOME"/code

# Execute the function
add_bin_dirs_from_code_repo "$CODE_HOME"
