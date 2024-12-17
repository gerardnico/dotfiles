
if [ ! -x "$(command -v cmctl)" ]; then
  echo "cmctl is not available"
  return
fi

# https://cert-manager.io/docs/reference/cmctl/#completion

# cmctl supports auto-completion for both subcommands as well as suggestions for runtime objects.
# cmctl approve -n <TAB> <TAB>

# shellcheck disable=SC1090
source <(cmctl completion bash)
# To load completions for each session, execute once:
# cmctl completion bash > /etc/bash_completion.d/cmctl