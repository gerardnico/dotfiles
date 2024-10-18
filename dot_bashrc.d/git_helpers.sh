
source bashlib-git.sh




# @description Diff of one file with the head
# @args $1 - the file to diff
# @example
#   gdiff README.md
git::diff(){
  git diff HEAD "$1" | $EDITOR
}

# @description Go to the default branch (main/master)
# @example
#   git::checkout_main
function git::checkout_main() {
  git checkout "$(git::get_default_branch)"
  git pull
}

# @description Delete the current branch and go to the default branch
function git::delete_branch() {
  git checkout "$(git::get_default_branch)"
  # delete
  git branch -D "$(git::get_current_branch)"
  git pull
}



# Alias
# See also gitconfig alias
alias gd='git diff | nvim'
alias gan='git add --renormalize .'
alias gau='git add --update'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcotb='git checkout --track -b'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'