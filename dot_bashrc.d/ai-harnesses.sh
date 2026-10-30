# Be sure to have the agent.md file
# for all harnesses/agents

RED='\033[0;31m'
NC='\033[0m'  # no color

ensure_symlink() {

  local TARGET_MD_PATH="$2"
  local AGENT_MD="$1"
  # -e: true if the target path exists and is reachable
  if [ ! -e "$TARGET_MD_PATH" ]; then
    echo -e "${RED}The symlink target path $TARGET_MD_PATH does not exists for the source: $AGENT_MD${NC}" > /dev/stderr
    return
  fi

  # -L: true if the path is a symbolic link
  if [ -L "$TARGET_MD_PATH" ]; then
    return
  fi

  mkdir -p "$(dirname "$TARGET_MD_PATH")" || return 1
  echo "Creating the symlink from $AGENT_MD to $TARGET_MD_PATH" > /dev/stderr
  ln -s "$AGENT_MD" "$TARGET_MD_PATH"

}

AITM_DIR="$HOME/code/gerardnico/aitm/.aitm"
AITM_SKILLS_DIR="$HOME/code/gerardnico/agent-skills/skills"
AITM_AGENT_MD="$HOME/.agents/AGENTS.md"
# Claude
# to see the sessions, no env as for pi unfortunately
export CLAUDE_CONFIG_DIR="$AITM_DIR/.claude"
# No git information by default
# https://code.claude.com/docs/en/agent-sdk/modifying-system-prompts#context-claude-code-adds-outside-the-system-prompt
export CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS="1"
export CLAUDE_CODE_MAX_CONTEXT_TOKENS=1000000
ensure_symlink "$AITM_AGENT_MD" "$CLAUDE_CONFIG_DIR/CLAUDE.md"
ensure_symlink "$AITM_SKILLS_DIR" "$CLAUDE_CONFIG_DIR/skills"

# Pi Agent
# export PI_CODING_AGENT_SESSION_DIR="$AITM_DIR/pi-sessions"
export PI_CODING_AGENT_DIR="$AITM_DIR/pi-agent"

# Aider
# The AGENTS.md is in the read property of the configuration file
export AIDER_CACHE_PROMPTS=true

# Other harness
ensure_symlink "$AITM_AGENT_MD" "$HOME/.config/opencode/AGENTS.md"
ensure_symlink "$AITM_AGENT_MD" "$HOME/.codex/AGENTS.md"
ensure_symlink "$AITM_AGENT_MD" "$HOME/.gemini/GEMINI.md"
ensure_symlink "$AITM_AGENT_MD" "$HOME/.cursor/rules/main.mdc"
ensure_symlink "$AITM_AGENT_MD" "$HOME/.copilot/copilot-instructions.md"

# Api Key, the keys should be set by project
# where provider is openai/claude/openrouter
# LLM_KEY_PATH="${PROVIDER}/${ORGANIZATION_NAME}/${PROJECT_NAME}"
# LLM_KEY_PATH="${PROVIDER}/${ORGANIZATION_NAME}/default"
