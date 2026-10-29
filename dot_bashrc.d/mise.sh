

if ! command -v "mise" > /dev/null 2>&1 ; then
  exit
fi

# mise doesn’t override cd.
# It hooks into the prompt (PROMPT_COMMAND in bash, precmd in zsh)
eval "$(mise activate bash)"
# config is in the .config/mise/config.toml
