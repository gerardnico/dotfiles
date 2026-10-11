# Be sure to have the agent.md file
# for all agents


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

ensure_md_symlink "$HOME/.claude/CLAUDE.md"
ensure_md_symlink "$HOME/.config/opencode/AGENTS.md"
ensure_md_symlink "$HOME/.codex/AGENTS.md"
ensure_md_symlink "$HOME/.gemini/GEMINI.md"
ensure_md_symlink "$HOME/.cursor/rules/main.mdc"
ensure_md_symlink "$HOME/.copilot/copilot-instructions.md"
