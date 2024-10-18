#!/bin/bash

##############################
# Git
##############################
# Git Completion
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Bash
if [[ ! -f ~/git-completion.bash ]]; then
	echo "Git Completion Not Found. Download"
	curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/git-completion.bash
fi
if [ -f "$HOME"/git-completion.bash ]; then
  . "$HOME"/git-completion.bash
fi
# Git Prompt Customization
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Bash
if [[ ! -f ~/git-prompt.sh ]]; then
    echo "Git Prompt Not Found. Download"
	curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/git-prompt.sh
fi
if [ -f ~/git-prompt.sh ]; then
  . "$HOME"/git-prompt.sh
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
# Undo: https://github.com/Bhupesh-V/ugit (Conflict with git-extras)
# Terminal GUI: https://github.com/jesseduffield/lazygit


