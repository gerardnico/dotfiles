
source bashlib-git.sh




# @description Diff of one file with the head
# @args $1 - the file to diff
# @example
#   gdiff README.md
git::diff(){
  git diff HEAD "$1" | $EDITOR
}



# Alias
# See also gitconfig alias
# `call` is a git alias to add, commit, and push and accepts the message
alias gs='git st'
alias gca='git call'
alias gd='git diff | nvim'
alias gan='git add --renormalize .'
alias gau='git add --update'
alias gc='git commit -v'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcotb='git checkout --track -b'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'