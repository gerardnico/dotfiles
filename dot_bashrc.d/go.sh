#####################
# Go Environment Variables"
#####################
if [ -d "/usr/local/go" ]; then
	export GOROOT=/usr/local/go
	export GOPATH=$HOME/go
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi
