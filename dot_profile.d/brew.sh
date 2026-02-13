BIN_BREW="/home/linuxbrew/.linuxbrew/bin"
##############################################
# Executable: Add Homebrew bin
# It should be first as it had the binary directory to the PATH
# And as script tests the presence of binary to add shell completion
# brew bin should always come first
###############################################
# For some reason, this may run twice, we check then if the directory is not already in the PATH
if [ -f "$BIN_BREW/brew" ] && [[ ":$PATH:" != *":$BIN_BREW:"* ]]; then
  # add Homebrew to your PATH
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
