
# Shell completion
# https://docs.dnscontrol.org/getting-started/getting-started#id-1.1.-shell-completion
if ! command -v "dnscontrol" > /dev/null 2>&1; then
  return
fi
eval "$(dnscontrol shell-completion bash)"
