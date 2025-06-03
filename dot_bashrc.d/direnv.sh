##############################
# DirEnv hook
##############################
# https://github.com/direnv/direnv
# https://direnv.net/docs/installation.html
# We put it here to make sure it appears even after git-prompt and other shell extensions that manipulate the prompt.
# ie the $PROMPT_COMMAND env variable
# if it does not work, check the $PROMPT_COMMAND variable, it should have at minima the value `_direnv_hook`
if [ ! -x "$(command -v direnv)" ]; then
  echo "direnv is not available"
  return;
fi

eval "$(direnv hook bash)"
