# Be sure to have the agent.md file
# for all harnesses/agents

ensure_md_symlink() {

  local TARGET_MD_PATH="$1"
  if [ -e "$TARGET_MD_PATH" ] && [ -L "$TARGET_MD_PATH" ]; then
    return
  fi

  AGENT_MD="$HOME/.agents/AGENTS.md"
  mkdir -p "$(dirname "$TARGET_MD_PATH")" || return 1
  echo "Creating the symlink from $AGENT_MD to $TARGET_MD_PATH" > /dev/stderr
  ln -s "$AGENT_MD" "$TARGET_MD_PATH"

}

# Claude
# to see the sessions, no env as for pi unfortunately
AITM_DIR="$HOME/code/gerardnico/aitm/.aitm"
export CLAUDE_CONFIG_DIR="$AITM_DIR/.claude"
# No git information by default
# https://code.claude.com/docs/en/agent-sdk/modifying-system-prompts#context-claude-code-adds-outside-the-system-prompt
export CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS="1"
export CLAUDE_CODE_MAX_CONTEXT_TOKENS=1000000
ensure_md_symlink "$CLAUDE_CONFIG_DIR/CLAUDE.md"

# Pi Agent
# export PI_CODING_AGENT_SESSION_DIR="$AITM_DIR/pi-sessions"
export PI_CODING_AGENT_DIR="$AITM_DIR/pi-agent"

# Aider
# The AGENTS.md is in the read property of the configuration file
export AIDER_CACHE_PROMPTS=true

# Other harness
ensure_md_symlink "$HOME/.config/opencode/AGENTS.md"
ensure_md_symlink "$HOME/.codex/AGENTS.md"
ensure_md_symlink "$HOME/.gemini/GEMINI.md"
ensure_md_symlink "$HOME/.cursor/rules/main.mdc"
ensure_md_symlink "$HOME/.copilot/copilot-instructions.md"

# Api Key, the keys should be set by project
# where provider is openai/claude/openrouter
# LLM_KEY_PATH="${PROVIDER}/${ORGANIZATION_NAME}/${PROJECT_NAME}"
# LLM_KEY_PATH="${PROVIDER}/${ORGANIZATION_NAME}/default"
