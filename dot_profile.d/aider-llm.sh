
# The default llm to choose from with aider
export LLM="claude"


# Wrapper script to get the appropriate key
# by project
function aider(){

  # Projet name should be in a envrc
  PROJECT_NAME=${PROJECT_NAME:-}
  if [ "$PROJECT_NAME" == "" ]; then
    echo "Project Name is missing"
    return 1
  fi
  if ! AIDER_PATH="$(which aider)"; then
    echo "Aider path not found"
    return 1
  fi
  case "${LLM:-}" in
    "openai")
      OPENAI_API_KEY=$(pass "openai/${PROJECT_NAME}-project") "$AIDER_PATH" "$@"
      ;;
    "claude")
      ANTHROPIC_API_KEY=$(pass "anthropic/${PROJECT_NAME}") "$AIDER_PATH" "$@"
      ;;
    *)
      echo "LLM ${LLM:-} is unknown"
  esac

}
