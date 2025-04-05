

##############################################
# Executable: Add Homebrew bin
# It should be first as it had the binary directory to the PATH
# And as script tests the presence of binary to add shell completion
# brew bin should always come first
###############################################
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  # add Homebrew to your PATH
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
