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
  source "$GIT_PROMPT_SCRIPT"
  export GIT_PS1_SHOWDIRTYSTATE=1
  # PS1:
  # This is the default PS1 where we have added the __git_ps1 function just before the dollar character
  # Explanation:
  # The \w means print the current working directory,
  # the \$ prints the $ part of the prompt,
  # \[exxx] are color formatting syntax
  # and __git_ps1 " (%s)" calls the function provided by git-prompt.sh with a formatting argument.

  export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n$(__git_ps1 "(%s)")\$ '
fi


# https://github.com/tj/git-extras/blob/main/Installation.md
# Only brew is maintained by the author
# brew install git-extras
# Install also Standup: https://github.com/kamranahmedse/git-standup


## Not installed but found
# Git Stats: https://github.com/arzzen/git-quick-stats
# Git Absorb: Don't create new commit. https://github.com/tummychow/git-absorb/
# Undo: https://github.com/Bhupesh-V/ugit (Conflict with git-extras)
# Terminal GUI: https://github.com/jesseduffield/lazygit


