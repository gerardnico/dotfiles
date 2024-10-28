# Command History
# Note if you don't want to have a specific command show up in .bash_history, prefix the command with a space.

# Options for the `Ctrl+R` with fzf

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

# History
# Histfile (This is the default)
export HISTFILE=$HOME/.bash_history
# number of lines or commands that (a) are allowed in the history file
# 500 = default
export HISTFILESIZE=500
# number of lines or commands that are stored in memory
# 500 = default
export HISTSIZE=500
