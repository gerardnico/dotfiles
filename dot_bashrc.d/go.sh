#####################
# Go Environment Variables"
#####################


#
# GOROOT is the root of the installation
#
# The GOROOT is added by Idea in its own shell !
#
# Using nix, we will get
# version "go1.23.0" does not match go tool version "go1.23.6"
# because the nix version is 1.23.6 and the version in GOROOT is 1.23
#
# We comment it out
# if [ -d "/usr/local/go" ]; then
  # export GOROOT=/usr/local/go
  # export PATH=$GOROOT/bin:$PATH
# fi

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
