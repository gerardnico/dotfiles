

if ! command -v "mise" > /dev/null 2>&1 ; then
  return
fi

# mise doesn’t override cd. It hooks into the prompt (PROMPT_COMMAND in bash, precmd in zsh)
# Deprecated globally: No global activation otherwise we get shims on path
# such as pi: ~/.local/share/mise/shims/pi
# Activate by repository via direnv
# eval "$(mise activate bash)"
# config is in the .config/mise/config.toml

# ie in direnv, execute
# eval "$(mise env -s bash)"
