#!/bin/bash

##############################
# Git
##############################
# Git Completion
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Bash
GIT_COMPLETION_SCRIPT=$HOME/git-completion.bash
if [[ ! -f $GIT_COMPLETION_SCRIPT ]]; then
	echo "Download Git Completion Script ($GIT_COMPLETION_SCRIPT)"
	if [[ $(uname -a) =~ "CYGWIN" ]]; then
      GIT_COMPLETION_SCRIPT=$(cygpath -w "$GIT_COMPLETION_SCRIPT")
	    echo "Cygwin detected. Download at: ($GIT_COMPLETION_SCRIPT)"
    fi
	curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "$GIT_COMPLETION_SCRIPT"
fi
if [ -f "$GIT_COMPLETION_SCRIPT" ]; then
  # shellcheck disable=SC1090
  source "$GIT_COMPLETION_SCRIPT"
fi
# Git Prompt Customization
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Bash
GIT_PROMPT_SCRIPT=$HOME/git-prompt.sh
if [[ ! -f "$GIT_PROMPT_SCRIPT" ]]; then
  echo "Download Git Completion Script ($GIT_PROMPT_SCRIPT)"
  if [[ $(uname -a) =~ "CYGWIN" ]]; then
    GIT_PROMPT_SCRIPT=$(cygpath -w "$GIT_PROMPT_SCRIPT")
    echo "Cygwin detected. Download at: ($GIT_PROMPT_SCRIPT)"
  fi
	curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o "$GIT_PROMPT_SCRIPT"
fi
if [ -f "$GIT_PROMPT_SCRIPT" ]; then
  # shellcheck disable=SC1090
  export GIT_PS1_SHOWDIRTYSTATE=1
  source "$GIT_PROMPT_SCRIPT"
  # PS1:
  # This is the default PS1 where we have added the __git_ps1 function just before the dollar character
  # Explanation:
  # The \w means print the current working directory,
  # the \$ prints the $ part of the prompt,
  # \[exxx] are color formatting syntax
  # and __git_ps1 " (%s)" calls the function provided by git-prompt.sh with a formatting argument.

  # __git_ps1 starts bashrc, I don't know why
  export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n$(__git_ps1 "(%s)")\$ '
  #export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
fi


# Alias
# See also gitconfig alias
# `call` is a git alias to add, commit, and push and accepts the message
alias gx='git-exec' # and not git exec if you are working with Cygwin otherwise there is a path problem
alias gxs='git-exec st'
alias gxac='git-exec auto-commit'
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


# No GIT_AUTHOR env
# Why? Because it has the higher priority than the repository config
# Deprecated: export GIT_AUTHOR_NAME="Nicolas GERARD"
# Deprecated: export GIT_AUTHOR_EMAIL="gerardnico@gmail.com"

# Gitx
# Where all repo are
export GIT_X_REPOS_DIR="$HOME/code"

# Loss repo in the wild where the path is rigid
# Brew Tap
# export to be able to query them with env
export HOMEBREW_TAP_HOME="/home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/gerardnico/homebrew-tap"
export HOMEBREW_ERALDY_TAP_HOME="/home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/eraldyhq/homebrew-tap"
# Ansible collection
# path is not directly the collection directory (https://docs.ansible.com/ansible/latest/reference_appendices/config.html#collections-paths)
# export to be able to query them with env
export ANSIBLE_X_COLLECTION_PATH="$HOME/.ansible/collections/ansible_collections/ans_e/ans_e_base"
# Path
export GIT_X_REPOS_PATH="$HOMEBREW_TAP_HOME:$ANSIBLE_X_COLLECTION_PATH:$HOMEBREW_ERALDY_TAP_HOME"
